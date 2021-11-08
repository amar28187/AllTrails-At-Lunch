//
//  ViewModel.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/7/21.
//

import Foundation
import CoreLocation
import UIKit

class ViewModel {
    // Text search
    func search(withCoordinates: CLLocationCoordinate2D, andText: String, completion: @escaping ([Place]) -> Void) {
        let params = ["location" : "\(withCoordinates.latitude),\(withCoordinates.longitude)",
                      "query" : andText]
        RestaurantService.textSearch(with: params) { places in
            completion(places)
        }
    }
    
    // Place details
    func getPlaceDetails(withId: String, completion: @escaping (Place?) -> Void) {
        let params = ["place_id" : withId]
        RestaurantService.fetchPlaceDetails(with: params) { place in
            completion(place)
        }
    }
    
    // Place photo
    func getPlacePhoto(withReference: String, completion: @escaping (UIImage?) -> Void) {
        let params = ["photo_reference" : withReference,
                      "maxwidth": Int(400),
                      "maxheight" : Int(400)] as [String : Any]
        RestaurantService.fetchPlacePhoto(with: params) { photo in
            completion(photo)
        }
    }
    
    // Nearby search
    func nearbySearch(forCoordinates: CLLocationCoordinate2D, completion: @escaping ([Place]) -> Void) {
        let params = ["location" : "\(forCoordinates.latitude),\(forCoordinates.longitude)"]
        RestaurantService.fetchNearbyPlaces(with: params) { places in
            completion(places)
        }
    }
    
    // This can be updated with CoreData or Cache, currently using UserDefaults
    func updateFavorite(for place: Place, isFavorite: Bool = true) {
        if let id = place.placeId {
            isFavorite ? UserDefaults.standard.setValue(id, forKey: id) : UserDefaults.standard.removeObject(forKey: id)
        }
    }
    
    // Copying to cache directory
    @discardableResult
    func copyToCache(image: UIImage, forPlaceId: String) -> URL? {
        do {
            let fileName = "\(forPlaceId).jpeg"
            let destURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
            try image.jpegData(compressionQuality: 1.0)?.write(to: destURL)
            return destURL
        } catch {
            print("Error in copying file to cache: " + error.localizedDescription)
        }
        
        return nil
    }
    
    // Fetch cached image
    func getImage(forPlaceId: String) -> UIImage? {
        let destURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        if let files = try? FileManager.default.contentsOfDirectory(atPath: destURL.path).filter({$0.contains(forPlaceId)}),
           let file = files.first {
            return UIImage(contentsOfFile: FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(file).path)
        }
        
        return nil
    }
    
}
