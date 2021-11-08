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
    
    func test4() {
        let predictions = Utils.fetchPredictions(fromFile: "AutoCompleteResponse")
        XCTAssert(predictions.count > 0)
    }
    
    func test5() {
        let predictions = Utils.fetchPredictions(fromFile: "QueryAutoCompleteResponse")
        XCTAssert(predictions.count > 0)
    }
}
