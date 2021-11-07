//
//  AllTrailsParsingTests.swift
//  AllTrailsAppTests
//
//  Created by Amar Makana on 11/6/21.
//

import XCTest
@testable import AllTrailsApp

class AllTrailsParsingTests: XCTestCase {

    func test1() {
        XCTAssertNotNil(Utils.fetchPlaces(fromFile: "NearbySearchResponse"))
    }
    
    func test2() {
        XCTAssertNotNil(Utils.fetchPlaces(fromFile: "TextSearchAPIResponse"))
    }
    
    func test3() {
        XCTAssertNotNil(Utils.fetchPlaces(fromFile: "ValidNearbyPlacesResponse"))
    }
}
