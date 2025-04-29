//
//  LanguageStruct.swift
//  XPal
//
//  Created by Ryan Pini on 4/1/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import Foundation

struct FlightInfoStruct: Decodable{
    
    var departureAirport: String
    var arrivalAirport: String
    var airline: String
    var boardingTime: String
    var terminal: String
    var date: String
    var latitude: Double
    var longitude: Double
}

