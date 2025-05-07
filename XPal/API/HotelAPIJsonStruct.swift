//
//  HotelAPIJsonStruct.swift
//  XPal
//
//  Created by Ryan Pini on 4/1/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import Foundation

struct HotelAPIJsonStruct: Hashable{
    
    var name: String
    var description: String
    var checkIn: String
    var checkOut: String
    var latitude: Double
    var longitude: Double
    var image: String
    var link: String
}
