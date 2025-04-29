//
//  TripStruct.swift
//  XPal
//
//  Created by Ryan Pini on 4/1/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import Foundation

struct TripStruct: Decodable{
    
    var name: String
    var description: String
    var flights: [FlightInfoStruct]
    var location: String
    var hotels: [HotelStruct]
}

