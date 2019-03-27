//
//  APISunriseSunsetManager.swift
//  Sunset & Sunrise
//
//  Created by Святослав Катола on 3/25/19.
//  Copyright © 2019 mezzoSoprano. All rights reserved.
//

import Foundation

struct Coordinates {
    
    let latitude: Double
    let longitute: Double
}

enum SunriseSunsetTypeURL: FinalURLPoint {
    
    case Current(coordinates: Coordinates)
    case WithDate(coordinates: Coordinates, date: Date)
    
    var baseURL: URL {
        return URL(string: "https://api.sunrise-sunset.org/")!
    }
    
    var path: String {
        switch self {
        case .Current(let coordinates):
            return "json?lat=\(coordinates.latitude)&lng=\(coordinates.longitute)"
        case .WithDate(let coordinates, let date):
            let strDateFormatted = date.description.split(separator: " ")[0]
            return "json?lat=\(coordinates.latitude)&lng=\(coordinates.longitute)&date=\(strDateFormatted)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}

final class APISunriseSunsetManager: APIManager {
    
    let sessionConfiguration: URLSessionConfiguration
    
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    } ()
    
    init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    func fetchCurrentInfoWith(coordinates: Coordinates, completionHandler: @escaping (APIResult<SunriseSunset>) -> Void) {
        
        let request = SunriseSunsetTypeURL.Current(coordinates: coordinates).request
        
        fetch(request: request, parse: { (json) -> SunriseSunset? in
            do {
                
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let models = try decoder.decode(SunriseSunset.self, from: json) //Decode JSON Response Data
                return models
                
            } catch let parsingError {
                
                print("Error", parsingError)
                return nil
            }
        }, completionHandler: completionHandler)
    }
    
    func fetchWithDate(coordinates: Coordinates, date: Date, completionHandler: @escaping (APIResult<SunriseSunset>) -> Void) {
        let request = SunriseSunsetTypeURL.WithDate(coordinates: coordinates, date: date).request
        
        fetch(request: request, parse: { (json) -> SunriseSunset? in
            do {
                
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let models = try decoder.decode(SunriseSunset.self, from: json) //Decode JSON Response Data
                return models
                
            } catch let parsingError {
                
                print("Error", parsingError)
                return nil
            }
        }, completionHandler: completionHandler)
    }
}
