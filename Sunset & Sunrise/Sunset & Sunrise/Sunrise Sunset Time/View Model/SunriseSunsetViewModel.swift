//
//  SunriseSunsetViewModel.swift
//  Sunset & Sunrise
//
//  Created by Святослав Катола on 4/2/19.
//  Copyright © 2019 mezzoSoprano. All rights reserved.
//

import Foundation

final class SunriseSunsetViewModel {
    
    let info: SunriseSunsetInfo?
    let place: Place
    
    var sunriseLocalTime: String = "?"
    var sunsetLocalTime: String = "?"
    var twilightBeginLocalTime: String = "?"
    var twilightEndLocalTime: String = "?"
    var dayLength: String = "?"
    var locationName: String = "?"
    
    
    init(info: SunriseSunsetInfo?, place: Place) {
        
        self.info = info
        self.place = place
        
        if let timeZone = place.timeZone, let locationName = place.name, let currInfo = info {
            self.sunriseLocalTime = "🌅 " + DateToLocalFormatter.UTCToLocal(date: currInfo.sunriseDate ?? "?", timeZone: timeZone )
            self.sunsetLocalTime = "🌅 " + DateToLocalFormatter.UTCToLocal(date: currInfo.sunsetDate ?? "?", timeZone: timeZone )
            self.twilightEndLocalTime = "🌘 " + DateToLocalFormatter.UTCToLocal(date: currInfo.twilightEndDate ?? "?", timeZone: timeZone )
            self.twilightBeginLocalTime = "🌖 " + DateToLocalFormatter.UTCToLocal(date: currInfo.twilightBeginDate ?? "?", timeZone: timeZone )
            self.dayLength = "🌞 " + (currInfo.dayLength ?? "?")
            self.locationName = locationName
        }
    }
}
