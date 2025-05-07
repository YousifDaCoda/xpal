//
//  FlightAPIJsonStruct.swift
//  XPal
//
//  Created by Ryan Pini on 5/6/25.
//

import Foundation

struct FlightAPIJsonStruct: Hashable{
    
    var departureAirport: String
    var departureCode: String
    var arrivalAirport: String
    var arrivalCode: String
    var airline: String
    var airlineLogo: String
    var boardingTime: String
    var arrivalTime: String
    var duration: Int
    var flightNumber: String
}

