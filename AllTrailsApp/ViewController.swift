//
//  ViewController.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/2/21.
//

import UIKit
import SnapKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    let viewModel: ViewModel = ViewModel()
    let tableView = UITableView()
    let nav = NavView(frame: .zero)
    let mapView = MKMapView(frame: .zero)
    var currentLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    let mapOrListButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorUtils.mapButtonColor
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        button.layer.shadowOpacity = 0.5
//        button.layer.shadowColor = UIColor.lightGray.cgColor
//        button.layer.shadowRadius = 20
        let image = UIImage(named:"map")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var dataSource: [Place] = [] {
        didSet{
            DispatchQueue.main.async {
                self.updateMap()
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Test code
        //self.dataSource = Utils.fetchPlaces(fromFile: "ValidNearbyPlacesResponse")
        //self.dataSource = Utils.fetchPlaces(fromFile: "TextSearchAPIResponse")
        
        
        self.locationManager.delegate = self
        self.setUp()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        // Test code
        //self.currentLocation = CLLocationCoordinate2D(latitude: 47.8044201, longitude: -122.2500863)
//        if let coordinates = self.currentLocation {
//            self.viewModel.nearbySearch(forCoordinates: coordinates) { places in
//                guard places.count > 0 else {
//                    return
//                }
//
//                self.dataSource = places
//            }
//        }

    }

    func updateMap() {
        print(#function)
        if let res = self.dataSource.first {
            let cl = CLLocationCoordinate2D(latitude: res.geometry?.location.latitude ?? 0, longitude: res.geometry?.location.longitude ?? 0)
            self.mapView.camera = MKMapCamera(lookingAtCenter: cl, fromDistance: 8000, pitch: 0, heading: .zero)
            let region = MKCoordinateRegion(center: cl, latitudinalMeters: 8000, longitudinalMeters: 8000)
            self.mapView.setRegion(region, animated: true)
            
            var annotations = [MapPointAnnotation]()
            for result in self.dataSource {
                guard let latitude = result.geometry?.location.latitude,
                      let longitude = result.geometry?.location.longitude else {
                    continue
                }
                
                let anno = MapPointAnnotation()
                anno.name = result.name
                anno.photoReference = result.photos?.first?.photoReference
                if result.ratingString.count > 0 {
                    anno.priceText = result.ratingString + " \u{00B7}" + " Restaurant"
                }
                anno.imageURL = result.icon
                anno.rating = Int(result.rating ?? 0)
                anno.reviewCount = "(\(result.userRating ?? 0))"
                anno.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotations.append(anno)
            }

            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func setUp() {
        self.addNav()
        self.setupTableView()
        self.addMapOrListButton()
        self.setupMap()
    }
    
    func addNav() {
        self.nav.delegate = self
        self.view.addSubview(self.nav)
        
        self.nav.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(160)
        }
    }
    
    func setupTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        tableView.register(AllTrailsCell.self, forCellReuseIdentifier: AllTrailsCell.reuseIdentifier)
        
        self.tableView.snp.makeConstraints { maker in
            maker.bottom.equalTo(self.view.snp.bottom)
            maker.left.right.equalToSuperview()
            maker.top.equalTo(self.nav.snp.bottom)
        }
    }
    
    func addMapOrListButton() {
        self.view.addSubview(self.mapOrListButton)

        self.mapOrListButton.setTitle("Map", for: .normal)
        self.mapOrListButton.tintColor = .white
        self.mapOrListButton.addTarget(self, action: #selector(mapListToggle(sender:)), for: .touchUpInside)
        self.mapOrListButton.snp.makeConstraints { maker in
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-25)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(50)
            maker.width.equalTo(120)
        }
    }
    
    @objc func mapListToggle(sender: UIButton) {
        if sender.titleLabel?.text == "Map" {
            self.mapOrListButton.setTitle("List", for: .normal)
            let image = UIImage(named: "list")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
            self.mapOrListButton.setImage(image, for: .normal)
            self.tableView.isHidden = true
            self.mapView.isHidden = false
            if let cl = self.currentLocation {
                self.mapView.camera = MKMapCamera(lookingAtCenter: cl, fromDistance: 8000, pitch: 0, heading: .zero)
            }
        } else {
            self.mapOrListButton.setTitle("Map", for: .normal)
            let image = UIImage(named: "map")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
            self.mapOrListButton.setImage(image, for: .normal)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            self.tableView.isHidden = false
            self.mapView.isHidden = true
        }
        
        self.mapOrListButton.tintColor = .white
    }
    
    func setupMap() {
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.register(MapMarkerView.self, forAnnotationViewWithReuseIdentifier: MapMarkerView.reuseIdentifier)
        
        self.view.addSubview(self.mapView)
        self.view.sendSubviewToBack(self.mapView)
        
        self.mapView.snp.makeConstraints { maker in
            maker.bottom.equalTo(self.view.snp.bottom)
            maker.left.right.equalToSuperview()
            maker.top.equalTo(self.nav.snp.bottom)
        }
    }

}
