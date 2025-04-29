//
//  DatabaseClasses.swift
//  XPal
//
//  Created by Ryan Pini & Osman Balci on 4/1/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

@Model
final class Language{
    
    var name: String
    var originCountry: String
    var countriesSpoken: Int
    var commonPhrases: [String: String]
    
    init(name: String, originCountry: String, countriesSpoken: Int, commonPhrases: [String : String]) {
        self.name = name
        self.originCountry = originCountry
        self.countriesSpoken = countriesSpoken
        self.commonPhrases = commonPhrases
    }
}

@Model
final class Trip {
    
    var name: String
    var tripDescription: String
    var flights: [FlightInfo]
    var locations: [String]
    var hotels: [Hotel]
    
    init(name: String, tripDescription: String, flights: [FlightInfo], locations: [String], hotels: [Hotel]) {
        
        self.name = name
        self.tripDescription = tripDescription
        self.flights = flights
        self.locations = locations
        self.hotels = hotels
    }
}

@Model
final class FlightInfo{
    
    
    var departureAirport: String
    var arrivalAirport: String
    var airline: String
    var boardingTime: String
    var terminal: String
    var date: String
    var latitude: Double
    var longitude: Double
    
    init(departureAirport: String, arrivalAirport: String, airline: String, boardingTime: String, terminal: String, date: String, latitude: Double, longitude: Double) {
        
        self.departureAirport = departureAirport
        self.arrivalAirport = arrivalAirport
        self.airline = airline
        self.boardingTime = boardingTime
        self.terminal = terminal
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
    }
}

@Model
final class Hotel{
    
    var name: String
    var hotelDescription: String
    var location: String
    var checkIn: String
    var checkOut: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, hotelDescription: String, location: String, checkIn: String, checkOut: String, latitude: Double, longitude: Double) {
        
        self.name = name
        self.hotelDescription = hotelDescription
        self.location = location
        self.checkIn = checkIn
        self.checkOut = checkOut
        self.latitude = latitude
        self.longitude = longitude
    }
}
