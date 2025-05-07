//
//  DatabaseClasses.swift
//  XPal
//
//  Created by Ryan Pini & Osman Balci on 4/1/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData
import Foundation

@Model
final class Language {
    var name: String
    var originCountry: String
    var countriesSpoken: Int
    var numberOfSpeakers: Int
    
    @Relationship(deleteRule: .cascade)
    var categories: [LanguageCategory]?
    
    @Relationship(deleteRule: .cascade)
    var quizAttempts: [QuizAttempt]?
    
    init(name: String, originCountry: String, countriesSpoken: Int, numberOfSpeakers: Int, categories: [LanguageCategory]? = nil, quizAttempts: [QuizAttempt]? = nil) {
        self.name = name
        self.originCountry = originCountry
        self.countriesSpoken = countriesSpoken
        self.numberOfSpeakers = numberOfSpeakers
        self.categories = categories
        self.quizAttempts = quizAttempts
        
    }
}

@Model
final class LanguageCategory {
    var categoryName: String
    
    @Relationship(deleteRule: .cascade)
    var phrases: [Phrase]?
    
    init(categoryName: String, phrases: [Phrase]? = nil) {
        self.categoryName = categoryName
        self.phrases = phrases
    }
}

@Model
final class Phrase {
    var english: String
    var translation: String

    init(english: String, translation: String) {
        self.english = english
        self.translation = translation
    }
}


@Model
final class QuizAttempt {
    var date: Date
    var score: Double  

    @Relationship var language: Language

    init(date: Date, score: Double, language: Language) {
        self.date = date
        self.score = score
        self.language = language
    }
}

@Model
final class Trip {
    
    var name: String
    var tripDescription: String
    var flights: [FlightInfo]
    var location: String
    var hotels: [Hotel]
    
    init(name: String, tripDescription: String, flights: [FlightInfo], location: String, hotels: [Hotel]) {
        
        self.name = name
        self.tripDescription = tripDescription
        self.flights = flights
        self.location = location
        self.hotels = hotels
    }
}

@Model
final class FlightInfo{
    
    
    var departureAirport: String
    var departureCode: String
    var arrivalAirport: String
    var arrivalCode: String
    var airline: String
    var boardingTime: String
    var terminal: String
    var date: String
    var latitude: Double
    var longitude: Double
    
    init(departureAirport: String, departureCode: String, arrivalAirport: String, arrivalCode: String, airline: String, boardingTime: String, terminal: String, date: String, latitude: Double, longitude: Double) {
        
        self.departureAirport = departureAirport
        self.departureCode = departureCode
        self.arrivalAirport = arrivalAirport
        self.arrivalCode = arrivalCode
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
