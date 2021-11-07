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
        button.layer.shadowOpacity = 0.5
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowRadius = 20
        let image = UIImage(named:"map")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var dataSource: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.dataSource = Utils.fetchPlaces(fromFile: "ValidNearbyPlacesResponse")
        //self.dataSource = Utils.fetchPlaces(fromFile: "TextSearchAPIResponse")
        self.locationManager.delegate = self
        self.setUp()
        self.locationManager.requestWhenInUseAuthorization()
        let params = ["location" : "47.80,-122.26"]
//        RestaurantService.fetchNearbyPlaces(with: params) { places in
//            guard places.count > 0 else {
//                return
//            }
//            
//            print(places)
//        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }


    func setUp() {
        self.addNav()
        self.setupTableView()
        self.addMapOrListButton()
        self.setupMap()
    }
    
    func addNav() {
        self.view.addSubview(self.nav)
        
        self.nav.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(160)
        }
    }
    
    func setupTableView() {
        self.view.addSubview(self.tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(AllTrailsCell.self, forCellReuseIdentifier: AllTrailsCell.reuseIdentifier)
        tableView.isUserInteractionEnabled = true
        
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
            let cl = CLLocationCoordinate2D(latitude: 47.8044201, longitude: -122.2500863)
            self.mapView.camera = MKMapCamera(lookingAtCenter: cl, fromDistance: 5, pitch: 0, heading: .zero)
        } else {
            self.mapOrListButton.setTitle("Map", for: .normal)
            let image = UIImage(named: "map")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
            self.mapOrListButton.setImage(image, for: .normal)
            
            self.tableView.isHidden = false
            self.mapView.isHidden = true
        }
        
        self.mapOrListButton.tintColor = .white
    }
    
    func setupMap() {
        self.view.addSubview(self.mapView)
        self.view.sendSubviewToBack(self.mapView)
        
        self.mapView.snp.makeConstraints { maker in
            maker.bottom.equalTo(self.view.snp.bottom)
            maker.left.right.equalToSuperview()
            maker.top.equalTo(self.nav.snp.bottom)
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllTrailsCellIdentifiier") as? AllTrailsCell else {
            return UITableViewCell()
        }
        
        let place = self.dataSource[indexPath.row]

        cell.restaurantNameLabel.text = place.name
        cell.priceAndSupportingTextLabel.text = place.ratingString + " \u{00B7}" + " Restaurant"
        cell.reviewCountLabel.text = "(\(place.userRating ?? 0))"
        cell.rating = Int(place.rating ?? 0)
        
        if let icon = place.icon {
            let url = URL(string: icon)

            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        cell.placeImageView.image = UIImage(data: data)
                    }
                }
            }
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = RestaurantDetailViewController()
        vc.place = Utils.fetchDetails(fromFile: "ValidPlaceDetailsResponse")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true) {
            
        }
        
        
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("locationManagerDidChangeAuthorization")
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError")
        
        let cl = CLLocationCoordinate2D(latitude: 47.8044201, longitude: -122.2500863)
        self.mapView.camera = MKMapCamera(lookingAtCenter: cl, fromDistance: 5, pitch: 0, heading: .zero)
        let region = MKCoordinateRegion(center: cl, latitudinalMeters: 5, longitudinalMeters: 5)
        self.mapView.setRegion(region, animated: true)
        
        let anno = MKPointAnnotation()
        anno.coordinate = cl
        self.mapView.addAnnotation(anno)
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidPauseLocationUpdates")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            self.locationManager.stopUpdatingLocation()
            return
            
        }
        self.locationManager.stopUpdatingLocation()
        self.currentLocation = locValue

        if let cl = self.currentLocation {
            self.mapView.camera = MKMapCamera(lookingAtCenter: cl, fromDistance: 5, pitch: 0, heading: .zero)
        } else {
            let cl = CLLocationCoordinate2D(latitude: 47.8044201, longitude: -122.2500863)
            self.mapView.camera = MKMapCamera(lookingAtCenter: cl, fromDistance: 5, pitch: 0, heading: .zero)
        }
    }
}
