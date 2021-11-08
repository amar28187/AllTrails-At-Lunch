//
//  RestaurantService.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/4/21.
//

import Foundation
import Moya
import Alamofire
import UIKit

enum AllTrailsService {
    case nearbySearch(params: [String: Any])
    case textSearch(params: [String: Any])
    case placeDetail(params: [String: Any])
    case autoComplete(params: [String: Any])
    case placePhoto(params: [String: Any])
    case queryAutoComplete(params: [String: Any])
}

extension AllTrailsService: TargetType {
    var baseURL: URL {
        return URL(string: "https://maps.googleapis.com/maps/api/place/")!
    }
    
    var path: String {
        switch self {
        case .nearbySearch(_):
            return Paths.nearbySearch + Paths.json
        case .textSearch(_):
            return Paths.textSearch + Paths.json
        case .placeDetail(_):
            return Paths.placeDetail + Paths.json
        case .autoComplete(_):
            return Paths.autoComplete + Paths.json
        case .placePhoto(_):
            return Paths.placePhoto
        case .queryAutoComplete(_):
            return Paths.queryAutoComplete + Paths.json
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .nearbySearch(let params):
            fallthrough
        case .textSearch(let params):
            fallthrough
        case .placeDetail(let params):
            fallthrough
        case .autoComplete(let params):
            fallthrough
        case .queryAutoComplete(let params):
            var p = params
            p["type"] = "restaurant"
            p["radius"] = 8000
            p["language"] = "en"
            p["key"] = "AIzaSyDQSd210wKX_7cz9MELkxhaEOUhFP0AkSk"
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        case .placePhoto(let params):
            var p = params
            p["key"] = "AIzaSyDQSd210wKX_7cz9MELkxhaEOUhFP0AkSk"
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let baseHeaders = [
            "Content-Type": "application/json",
        ]
        
        switch self {
            case .placePhoto(_):
                return ["Accept" : "*/*",
                        "Connection" : "keep-alive",
                        "Accept-Encoding" : "gzip, deflate, br"]
            default:
                break
        }
        return baseHeaders
    }
    
}

class Paths {
    static let autoComplete = "autocomplete/"
    static let placePhoto = "photo"
    static let textSearch = "textsearch/"
    static let placeDetail = "details/"
    static let nearbySearch = "nearbysearch/"
    static let queryAutoComplete = "queryautocomplete/"
    static let json = "json"
}

class RestaurantService {
    /// Provider for RestaurantService
    static let provider = MoyaProvider<AllTrailsService>(session: FastTimeoutAlamofireManager.sharedManager, plugins: [NetworkLoggerPlugin()])
    
    static func fetchPlaces() {
        
    }
    
    static func fetchPlaceDetails(with parameters: [String: Any], completion: @escaping (Place?) -> Void) {
        self.provider.request(.placeDetail(params: parameters)) { result in
            switch result {
            case .success(let response):
                guard let json = try? JSONDecoder().decode(GooglePlaceDetailsResponse.self, from: response.data) else {
                    print("\(#function): no results")
                    completion(nil)
                    return
                }
                
                completion(json.result)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    static func fetchNearbyPlaces(with parameters: [String: Any], completion: @escaping ([Place]) -> Void) {
        self.provider.request(.nearbySearch(params: parameters)) { result in
            switch result {
            case .success(let response):
                guard let json = try? JSONDecoder().decode(GooglePlacesResponse.self, from: response.data) else {
                    print("\(#function): no results")
                    completion([])
                    return
                }
                
                completion(json.results)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    static func fetchPlacePhoto(with parameters: [String: Any], completion: @escaping (UIImage?) -> Void) {
        self.provider.request(.placePhoto(params: parameters)) { result in
            switch result {
            case .success(let response):
                guard let image = UIImage(data: response.data) else {
                    print("\(#function): no results")
                    completion(nil)
                    return
                }
                
                completion(image)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    static func textSearch(with parameters: [String: Any], completion: @escaping ([Place]) -> Void) {
        self.provider.request(.textSearch(params: parameters)) { result in
            switch result {
            case .success(let response):
                guard let json = try? JSONDecoder().decode(GooglePlacesResponse.self, from: response.data) else {
                    print("\(#function): no results")
                    completion([])
                    return
                }
                
                completion(json.results)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    static func autoComplete(with parameters: [String: Any], completion: @escaping ([Predictions]) -> Void) {
        self.provider.request(.autoComplete(params: parameters)) { result in
            switch result {
            case .success(let response):
                guard let json = try? JSONDecoder().decode(AutoCompleteResponse.self, from: response.data) else {
                    print("\(#function): no results")
                    completion([])
                    return
                }
                completion(json.predictions)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    static func queryAutoComplete(with parameters: [String: Any], completion: @escaping ([Predictions]) -> Void) {
        self.provider.request(.queryAutoComplete(params: parameters)) { result in
            switch result {
            case .success(let response):
                guard let json = try? JSONDecoder().decode(AutoCompleteResponse.self, from: response.data) else {
                    print("\(#function): no results")
                    completion([])
                    return
                }
                completion(json.predictions)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
}


class FastTimeoutAlamofireManager: Alamofire.Session {
    static let sharedManager: FastTimeoutAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20 //seconds
        configuration.timeoutIntervalForResource = 20 //seconds
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return FastTimeoutAlamofireManager(configuration: configuration)
    }()
}
