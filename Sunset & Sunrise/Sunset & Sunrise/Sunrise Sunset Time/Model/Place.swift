//
//  Place.swift
//  Sunset & Sunrise
//
//  Created by Святослав Катола on 4/3/19.
//  Copyright © 2019 mezzoSoprano. All rights reserved.
//

import Foundation

class Place {
    var name: String?
    var timeZone: TimeZone?
    
    init(name: String?, timeZone: TimeZone?) {
        self.name = name
        self.timeZone = timeZone
    }
}
