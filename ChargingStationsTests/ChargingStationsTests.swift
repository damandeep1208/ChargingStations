//
//  ChargingStationsTests.swift
//  ChargingStationsTests
//
//  Created by Damandeep Kaur on 2/10/23.
//

import XCTest
@testable import ChargingStations

class ChargingStationsTests: XCTestCase {

    func testChargingPoints() {
        let station = Station()
        XCTAssertEqual(station.chargingPoints, "0 Charging Points")
        station.numberOfPoints = 1
        XCTAssertEqual(station.chargingPoints, "1 Charging Point")
        station.numberOfPoints = 5
        XCTAssertEqual(station.chargingPoints, "5 Charging Points")
    }
    
    func testDistanceIfNoRoute() {
        // create the expectation
        let exp = expectation(description: "getting distance")
        
        let station = Station()
        let address = AddressInfo()
        station.address = address
        var result = ""
        // call my asynchronous method
        HomeDetailViewModel(station: station).getDistance { (distance) in
            result = distance
            // when it finishes, mark my expectation as being fulfilled
            exp.fulfill()
        }
        
        // wait three seconds for all outstanding expectations to be fulfilled
           waitForExpectations(timeout: 10)
        
        // our expectation has been fulfilled, so we can check the result is correct
            XCTAssertEqual(result, "-")
    }

    
    func testDistanceIfRouteExists() {
        // create the expectation
        let exp = expectation(description: "getting distance")
        
        let station = Station()
        let address = AddressInfo()
        address.latitude = 52.626
        address.longitude = 13.515
        station.address = address
        var result = ""
        // call my asynchronous method
        HomeDetailViewModel(station: station).getDistance { (distance) in
            result = distance
            // when it finishes, mark my expectation as being fulfilled
            exp.fulfill()
        }
        
        // wait three seconds for all outstanding expectations to be fulfilled
           waitForExpectations(timeout: 10)
        
        // our expectation has been fulfilled, so we can check the result is correct
            XCTAssertNotEqual(result, "-")
    }

}
