//
//  CurrentSunriseSunsetInfo.swift
//  Sunset & Sunrise
//
//  Created by Святослав Катола on 3/25/19.
//  Copyright © 2019 mezzoSoprano. All rights reserved.
//

import Foundation

struct SunriseSunset: Codable {
    let info: SunriseSunsetInfo?
    
    private enum CodingKeys: String, CodingKey {
        case info = "results"
    }
}

struct SunriseSunsetInfo: Codable {
    var sunriseDate: String?
    var sunsetDate: String?
    var twilightBeginDate: String?
    var twilightEndDate: String?
    var dayLength: String?
    
    private enum CodingKeys: String, CodingKey {
        case sunriseDate = "sunrise"
        case sunsetDate = "sunset"
        case twilightBeginDate = "civil_twilight_begin"
        case twilightEndDate = "civil_twilight_end"
        case dayLength = "day_length"
    }
}
