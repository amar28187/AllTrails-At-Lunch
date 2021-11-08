//
//  ViewModel.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/7/21.
//

import Foundation
import CoreLocation

class ViewModel {
    func search(withText: String) {
        RestaurantService.textSearch(with: [String: Any]()) { places in
            
        }
    }
    
    func search(withLocation: CLLocationCoordinate2D) {
        let params = ["location" : "47.80,-122.26"]
        RestaurantService.fetchNearbyPlaces(with: params) { places in
            guard places.count > 0 else {
                return
            }

            print(places)
        }
    }
    
    func getPlaceDetails(withReference: String) {
        RestaurantService.fetchPlaceDetails(with: [String: Any]()) { place in
            guard let pl = place else {
                return
            }
            
            
        }
    }
    
    func getPlacePhots(withReference: String) {
        RestaurantService.fetchPlacePhoto(with: [String: Any]()) { photo in
            
        }
    }
    
    func nearbySearch() {
        RestaurantService.fetchNearbyPlaces(with: [String: Any]()) { places in
            guard places.count > 0 else {
                return
            }
        }
    }
    
    
}
