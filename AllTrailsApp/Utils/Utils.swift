//
//  Utils.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/2/21.
//

import Foundation

class Utils {
    class func readFile(_ fileName: String) -> Data? {

        let bundle = Bundle(for: type(of: Utils().self))
        if let filepath = bundle.path(forResource: fileName, ofType: "json") {
            let data = try? Data(contentsOf: URL(fileURLWithPath: filepath))
            return data
        }
        return nil
    }
    
    class func fetchPlaces(fromFile: String) -> [Place]{
        if let data = readFile(fromFile){
            do {
                let json = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
                return json.results
            } catch let error{
                print(error.localizedDescription)
                return []
            }
                            
        } else {
            return []
        }
             
    }
    
    class func fetchDetails(fromFile: String) -> Place? {
        if let data = readFile(fromFile){
            do {
                let json = try JSONDecoder().decode(GooglePlaceDetailsResponse.self, from: data)
                return json.result
            } catch let error{
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
             
    }
    
    class func fetchPredictions(fromFile: String) -> [PredictionResults] {
        if let data = readFile(fromFile){
            do {
                let json = try JSONDecoder().decode(AutoCompleteResponse.self, from: data)
                return json.predictions
            } catch let error{
                print(error.localizedDescription)
                return []
            }
        } else {
            return []
        }
    }
    
    
}
