//
//  ResponseModels.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/2/21.
//

import Foundation
struct GooglePlaceDetailsResponse : Codable {
    let result : Place
    enum CodingKeys : String, CodingKey {
        case result = "result"
    }
}

struct GooglePlacesResponse : Codable {
    let results : [Place]
    enum CodingKeys : String, CodingKey {
        case results = "results"
    }
}

struct Place : Codable {
    
    let geometry : Location?
    let name : String?
    let openingHours : OpenNow?
    let photos : [PhotoInfo]?
    let types : [String]?
    let address : String?
    let userRating: Int?
    let priceLevel: Int?
    let rating: Double?
    let icon: String?
    let formattedAddress: String?
    var ratingString: String {
        get{
            String(repeating: "$", count: priceLevel ?? 0)
        }
    }
    
    enum CodingKeys : String, CodingKey {
        case geometry = "geometry"
        case name = "name"
        case openingHours = "opening_hours"
        case photos = "photos"
        case types = "types"
        case address = "vicinity"
        case userRating = "user_ratings_total"
        case priceLevel = "price_level"
        case rating = "rating"
        case icon = "icon"
        case formattedAddress = "formatted_address"
    }
    
    struct Location : Codable {
        
        let location : LatLong
        
        enum CodingKeys : String, CodingKey {
            case location = "location"
        }
        
        struct LatLong : Codable {
            
            let latitude : Double
            let longitude : Double
            
            enum CodingKeys : String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
    }
    
    struct OpenNow : Codable {
        
        let isOpen : Bool
        
        enum CodingKeys : String, CodingKey {
            case isOpen = "open_now"
        }
    }
    
    struct PhotoInfo : Codable {
        
        let height : Int
        let width : Int
        let photoReference : String
        
        enum CodingKeys : String, CodingKey {
            case height = "height"
            case width = "width"
            case photoReference = "photo_reference"
        }
    }
}

struct AutoCompleteResponse: Codable {
    let predictions: [PredictionResults]
    
    enum CodingKeys : String, CodingKey {
        case predictions = "predictions"
    }
}

struct PredictionResults: Codable {
    let description: String?
    
    enum CodingKeys : String, CodingKey {
        case description = "description"
    }
}

