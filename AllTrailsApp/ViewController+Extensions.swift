//
//  ViewController+Extensions.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/7/21.
//

import Foundation
import CoreLocation
import MapKit
import SnapKit

extension ViewController: NavViewDelegate {
    func search(withText: String) {
        //self.viewModel.search(withText: withText)
    }
}

class MapPointAnnotation: MKPointAnnotation {
    var name: String?
    var imageURL: String?
    var priceText: String?
    var rating: Int?
    var reviewCount: String?
    
    override init() {
        super.init()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("\(#function)")
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(#function)")
        let res = self.dataSource.first
        if let res = res {
            let cl = CLLocationCoordinate2D(latitude: res.geometry?.location.latitude ?? 0, longitude: res.geometry?.location.longitude ?? 0)
            self.mapView.camera = MKMapCamera(lookingAtCenter: cl, fromDistance: 5, pitch: 0, heading: .zero)
            let region = MKCoordinateRegion(center: cl, latitudinalMeters: 5, longitudinalMeters: 5)
            self.mapView.setRegion(region, animated: true)
            
            var annotations = [MapPointAnnotation]()
            for result in self.dataSource {
                guard let latitude = result.geometry?.location.latitude,
                      let longitude = result.geometry?.location.longitude else {
                    continue
                }
                
                let anno = MapPointAnnotation()
                //anno.subtitle = result.name
                //anno.title = ""
                anno.name = result.name
                anno.priceText = result.ratingString + " \u{00B7}" + " Restaurant"
                anno.imageURL = result.icon
                anno.rating = Int(result.rating ?? 0)
                anno.reviewCount = "(\(result.userRating ?? 0))"
                anno.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotations.append(anno)
            }
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
            }
        }


    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidPauseLocationUpdates")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(#function)")
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else {
            print("\(#function): location coordinates missing")
            self.locationManager.stopUpdatingLocation()
            return
            
        }
        self.locationManager.stopUpdatingLocation()
        self.currentLocation = location

        if let cl = self.currentLocation {
            self.mapView.camera = MKMapCamera(lookingAtCenter: cl, fromDistance: 5, pitch: 0, heading: .zero)
        } else {
            let cl = CLLocationCoordinate2D(latitude: 47.8044201, longitude: -122.2500863)
            self.mapView.camera = MKMapCamera(lookingAtCenter: cl, fromDistance: 5, pitch: 0, heading: .zero)
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
        vc.place = self.dataSource[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(named:"markerSelected")

        view.canShowCallout = true


    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: MapMarkerView.reuseIdentifier) as? MapMarkerView else {
            print("Custom annotation failed")
            return MKAnnotationView()
        }
        
        if let a = annotation as? MapPointAnnotation {
            view.mapPointAnnotation = a
        }
        view.image = UIImage(named:"markerUnselected")
        
        
        if let v = annotation as? MapPointAnnotation {
            view.annotationView.restaurantNameLabel.text = v.name
            view.annotationView.rating = v.rating ?? 0
            view.annotationView.priceAndSupportingTextLabel.text = v.priceText
            view.annotationView.reviewCountLabel.text = v.reviewCount
        }
        
        view.isFavorite = true
        
        return view
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named:"markerUnselected")
    }
    
}
