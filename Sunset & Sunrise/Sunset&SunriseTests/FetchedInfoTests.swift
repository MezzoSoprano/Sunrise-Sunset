//
//  FetchedInfoTests.swift
//  Sunset&SunriseTests
//
//  Created by Святослав Катола on 3/27/19.
//  Copyright © 2019 mezzoSoprano. All rights reserved.
//

import Foundation
import XCTest

@testable import Sunset___Sunrise

class FetchedInfoTests: XCTestCase {
    
    func testUTCToLocal() {
        
        let dateString = "6:11:50 AM"
        
        let UkraineStringDate = DateToLocalFormatter.UTCToLocal(date: dateString, timeZone: .current)
        let AfricaStringDate = DateToLocalFormatter.UTCToLocal(date: dateString, timeZone: TimeZone(identifier: "Africa/Blantyre")!)
        let TokyoStringDate = DateToLocalFormatter.UTCToLocal(date: dateString, timeZone: TimeZone(identifier: "Asia/Tokyo")!)
        
        XCTAssertTrue(UkraineStringDate=="8:11 AM")
        XCTAssertTrue(AfricaStringDate=="8:11 AM")
        XCTAssertTrue(TokyoStringDate=="3:11 PM")
    }
    
    func testAPIManagerResponse() {
        
        let testManager = APISunriseSunsetManager(sessionConfiguration: URLSessionConfiguration.default)
        
        let stringDate = "2019-03-27"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date = dateFormatter.date(from: stringDate)!
        
        testManager.fetchWithDate(coordinates: Coordinates(latitude: 19.3621397, longitute: -99.1538985), date: date) { (result) in
            
            switch result {
                
            case .Success(let receivedInfo):
                print(receivedInfo)
                XCTAssertTrue(receivedInfo.info?.sunriseDate=="12:34:08 PM")
                XCTAssertTrue(receivedInfo.info?.sunsetDate=="12:49:31 AM")
                
            case .Failure(let error as NSError):
                print(error)
                
            default: break
            }
        }
    }
}
