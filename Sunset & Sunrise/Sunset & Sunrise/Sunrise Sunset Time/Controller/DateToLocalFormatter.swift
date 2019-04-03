//
//  DateToLocalFormatter.swift
//  Sunset & Sunrise
//
//  Created by Святослав Катола on 3/27/19.
//  Copyright © 2019 mezzoSoprano. All rights reserved.
//

import Foundation

class DateToLocalFormatter {
    
    //converting UTC time to local time string
    static func UTCToLocal(date: String, timeZone: TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss a "
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: dt!)
    }
}
