//
//  HotelStruct.swift
//  XPal
//
//  Created by Ryan Pini on 4/1/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import Foundation

struct HotelStruct: Decodable{
    
    var name: String
    var description: String
    var location: String
    var checkIn: String
    var checkOut: String
    var latitude: Double
    var longitude: Double
}

