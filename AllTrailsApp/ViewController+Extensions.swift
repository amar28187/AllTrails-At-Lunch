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
        if let coordinates = self.currentLocation, withText.count > 0 {
            self.viewModel.search(withCoordinates: coordinates, andText: withText) { places in
                guard places.count > 0 else {
                    print("\(#function): places count: 0")
                    return
                }

                self.dataSource = places
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("\(#function)")
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            manager.stopUpdatingLocation()
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(#function)")
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidPauseLocationUpdates")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(#function)")
        guard let location: CLLocationCoordinate2D = locations.last?.coordinate else {
            print("\(#function): location coordinates missing")
            self.locationManager.stopUpdatingLocation()
            return
            
        }
        self.locationManager.stopUpdatingLocation()
        self.currentLocation = location

        let cl: CLLocationCoordinate2D = self.currentLocation ?? CLLocationCoordinate2D(latitude: 47.8044201, longitude: -122.2500863)
        self.mapView.camera = MKMapCamera(lookingAtCenter: cl, fromDistance: 8000, pitch: 0, heading: .zero)
        updateResults(forLocation: cl)
        
    }
    
    func updateResults(forLocation: CLLocationCoordinate2D) {
        self.viewModel.nearbySearch(forCoordinates: forLocation) { [weak self] places in
            guard places.count > 0 else {
                return
            }
            
            let dg = DispatchGroup()
            for place in places {
                dg.enter()
                if let ref = place.photos?.first?.photoReference {
                    self?.viewModel.getPlacePhoto(withReference: ref) { photo in
                        if let p = photo, let id = place.placeId {
                            self?.viewModel.copyToCache(image: p, forPlaceId: id)
                        }
                        dg.leave()
                    }
                } else {
                    dg.leave()
                }
            }
            
            dg.notify(queue: .main) {
                self?.dataSource = places
            }
            
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllTrailsCell.reuseIdentifier) as? AllTrailsCell else {
            return UITableViewCell()
        }
        
        let place = self.dataSource[indexPath.row]

        cell.restaurantNameLabel.text = place.name
        if place.ratingString.count > 0 {
            cell.priceAndSupportingTextLabel.text = place.ratingString + " \u{00B7}" + " Restaurant"
        }
        cell.reviewCountLabel.text = "(\(place.userRating ?? 0))"
        cell.rating = Int(place.rating ?? 0)
        
        // Test code
//        if let icon = place.icon, let url = URL(string: icon) {
//
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        cell.placeImageView.image = UIImage(data: data)
//                    }
//                }
//            }
//        }
        

        
        if let id = place.placeId, let image = self.viewModel.getImage(forPlaceId: id) {
            cell.placeImageView.image = image
        } else {
            if let photoRef = place.photos?.first?.photoReference {
                self.viewModel.getPlacePhoto(withReference: photoRef) { image in
                    if let img = image {
                        DispatchQueue.main.async {
                            cell.placeImageView.image = img
                        }
                    }
                }
            }
        }

        cell.favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        
        if let placeId = place.placeId, UserDefaults.standard.value(forKey: placeId) != nil {
            let image = UIImage(named:"favoriteFilled")?.withRenderingMode(
                UIImage.RenderingMode.alwaysTemplate)
            cell.favoriteButton.setImage(image, for: .normal)
            cell.favoriteButton.imageView?.tintColor = ColorUtils.mapButtonColor
            
        } else {
            let image = UIImage(named:"favorite")?.withRenderingMode(
               UIImage.RenderingMode.alwaysTemplate)
            cell.favoriteButton.setImage(image, for: .normal)
            cell.favoriteButton.imageView?.tintColor = .lightGray
        }
        
        return cell
        
    }
    
    @objc func toggleFavorite(_ sender: UIButton) {
        guard let sup = sender.superview else {
            return
        }
        let point = tableView.convert(sender.center, from: sup)
        if let indexPath = self.tableView.indexPathForRow(at: point) {
            let place = self.dataSource[indexPath.row]
            if let cell = tableView.cellForRow(at: indexPath) as? AllTrailsCell {
                if cell.favoriteButton.imageView?.image == UIImage(named: "favorite")?.withRenderingMode(
                    UIImage.RenderingMode.alwaysTemplate){
                    // Test code
                    //let image = UIImage(named:"favoriteFilled")?.withRenderingMode(
                        //UIImage.RenderingMode.alwaysTemplate)
                    //cell.favoriteButton.setImage(image, for: .normal)
                    //cell.favoriteButton.imageView?.tintColor = ColorUtils.mapButtonColor
                    self.viewModel.updateFavorite(for: place, isFavorite: true)
                } else {
                    // Test code
                    //let image = UIImage(named:"favorite")?.withRenderingMode(
                       //UIImage.RenderingMode.alwaysTemplate)
                    //cell.favoriteButton.setImage(image, for: .normal)
                    //cell.favoriteButton.imageView?.tintColor = .lightGray
                    self.viewModel.updateFavorite(for: place, isFavorite: false)
                }
                
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                tableView.endUpdates()
            }
        }
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
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: MapMarkerView.reuseIdentifier) as? MapMarkerView else {
            print("Custom annotation failed")
            return MKAnnotationView()
        }
        
        view.image = UIImage(named:"markerUnselected")
        view.annotation = annotation

        if let anno = annotation as? MapPointAnnotation {
            view.annotationView.restaurantNameLabel.text = anno.name
            view.annotationView.rating = anno.rating ?? 0
            view.annotationView.priceAndSupportingTextLabel.text = anno.priceText
            view.annotationView.reviewCountLabel.text = anno.reviewCount
            if let photoRef = anno.photoReference {
                self.viewModel.getPlacePhoto(withReference: photoRef) { image in
                    if let img = image {
                        view.annotationView.placeImageView.image = img
                    }
                }
            }
        }

        //view.isFavorite = true
        
        return view
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named:"markerUnselected")
    }
    
}
