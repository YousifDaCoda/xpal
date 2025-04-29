//
//  DatabaseCreation.swift
//  Videos
//
//  Created by Ryan Pini & Osman Balci on 4/1/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

public func createDatabase() {
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer
    
    do {
        // Create a database container to manage the Photo and Video objects
        modelContainer = try ModelContainer(for: Language.self, Trip.self, FlightInfo.self, Hotel.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context where the Photo and Video objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    /*
     --------------------------------------------------------------------
     |   Check to see if the database has already been created or not   |
     --------------------------------------------------------------------
     */
    let languageFetchDescriptor = FetchDescriptor<Language>()
    var listOfAllLanguagesInDatabase = [Language]()
    
    let hotelFetchDescriptor = FetchDescriptor<Hotel>()
    var listOfAllHotelsInDatabase = [Hotel]()
    
    let flightInfoFetchDescriptor = FetchDescriptor<FlightInfo>()
    var listOfAllFlightInfosInDatabase = [FlightInfo]()
    
    let tripFetchDescriptor = FetchDescriptor<Trip>()
    var listOfAllTripsInDatabase = [Trip]()
    
    do {
        // Obtain all of the Language objects from the database
        listOfAllLanguagesInDatabase = try modelContext.fetch(languageFetchDescriptor)
    } catch {
        fatalError("Unable to fetch Language objects from the database")
    }
    do {
        // Obtain all of the Language objects from the database
        listOfAllHotelsInDatabase = try modelContext.fetch(hotelFetchDescriptor)
    } catch {
        fatalError("Unable to fetch Hotel objects from the database")
    }
    do {
        // Obtain all of the Language objects from the database
        listOfAllFlightInfosInDatabase = try modelContext.fetch(flightInfoFetchDescriptor)
    } catch {
        fatalError("Unable to fetch FlightInfo objects from the database")
    }
    do {
        // Obtain all of the Language objects from the database
        listOfAllTripsInDatabase = try modelContext.fetch(tripFetchDescriptor)
    } catch {
        fatalError("Unable to fetch Trip objects from the database")
    }
    
    if !listOfAllLanguagesInDatabase.isEmpty && !listOfAllHotelsInDatabase.isEmpty && !listOfAllFlightInfosInDatabase.isEmpty && !listOfAllTripsInDatabase.isEmpty{
        print("Database has already been created!")
        return
    }
    
    print("Database will be created!")
    
    /*
     ----------------------------------------------------------
     | *** The app is being launched for the first time ***   |
     |   Database needs to be created and populated with      |
     |   the initial content given in the JSON files.         |
     ----------------------------------------------------------
     */
    
    /*
     ******************************************************
     *   Create and Populate the Photos in the Database   *
     ******************************************************
     */
    var languageStructList = [LanguageStruct]()
    languageStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "DBLanguageInitialContent.json", fileLocation: "Main Bundle")
    
    for aLanguage in languageStructList {


        // Instantiate a new Photo object and dress it up
        let newLanguage = Language(name: aLanguage.name,
                                   originCountry: aLanguage.originCountry,
                                   countriesSpoken: aLanguage.countriesSpoken,
                                   commonPhrases: aLanguage.commonPhrases)
        
        // Insert the new Photo object into the database
        modelContext.insert(newLanguage)
        
    }   // End of the for loop
    
    var hotelStructList = [HotelStruct]()
    hotelStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "DBHotelInitialContent.json", fileLocation: "Main Bundle")
    
    for aHotel in hotelStructList {
        
        let newHotel = Hotel(name: aHotel.name,
                             hotelDescription: aHotel.description,
                             location: aHotel.location,
                             checkIn: aHotel.checkIn,
                             checkOut: aHotel.checkOut,
                             latitutde: aHotel.latitutde,
                             longitude: aHotel.location)
        modelContext.insert(newHotel)
        
    }
    
    var flightInfoStructList = [FlightInfoStruct]()
    flightInfoStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "DBHotelInitialContent.json", fileLocation: "Main Bundle")
    
    for aFlight in flightInfoStructList {
        
        let newFlight = FlightInfo(departureAirport: aFlight.departureAirport,
                                   arrivalAirport: aFlight.arrivalAirport,
                                   airline: aFlight.airline,
                                   boardingTime: aFlight.boardingTime,
                                   terminal: aFlight.terminal,
                                   time: aFlight.time,
                                   latitude: aFlight.latitude,
                                   longitude: aFlight.longitude)
        modelContext.insert(newFlight)
        
    }
    
    var tripStructList = [TripStruct]()
    tripStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "DBHotelInitialContent.json", fileLocation: "Main Bundle")
    
    for aTrip in tripStructList {
        
        let newTrip = Trip(name: aTrip.name,
                           tripDescription: aTrip.description,
                           flights: aTrip.flights,
                           locations: aTrip.locations,
                           hotels: aTrip.hotels)
        modelContext.insert(newTrip)
        
    }
    
    
    print("Database is successfully created!")
}

