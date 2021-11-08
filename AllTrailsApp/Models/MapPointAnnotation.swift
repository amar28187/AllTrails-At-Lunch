//
//  MapPointAnnotation.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/7/21.
//

import Foundation
import MapKit

class MapPointAnnotation: MKPointAnnotation {
    var name: String?
    var imageURL: String?
    var priceText: String?
    var rating: Int?
    var reviewCount: String?
    var photoReference: String?
    
    override init() {
        super.init()
    }
}
