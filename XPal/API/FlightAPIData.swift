//
//  FlightAPIData.swift
//  XPal
//
//  Created by Ryan Pini & Osman Balci on 3/3/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import Foundation

var foundFlightsList = [FlightAPIJsonStruct]()

public func getFoundFlightsFromApi(query: [String]) {
    
    let apiUrlString = "https://serpapi.com/search.json?engine=google_flights&departure_id=\(query[0])&arrival_id=\(query[1])&outbound_date=\(query[2])&type=2&stops=1&api_key=\(mySerpApiKey)"
    
    foundFlightsList = [FlightAPIJsonStruct]()
    /*
     ***************************************************
     *   Fetch JSON Data from the API Asynchronously   *
     ***************************************************
     */
    var jsonDataFromApi: Data
    
    // cityApiHeaders is defined in Globals.swift
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: [:], apiUrl: apiUrlString, timeout: 10.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return      // foundCitiesList will be empty
    }
    
    do{
        
        /*
         Foundation framework’s JSONSerialization class is used to convert JSON data
         into Swift data types such as Dictionary, Array, String, Int, Double or Bool.
         */
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
        
        var otherFlightsDictionary = [String: Any]()
        
        if let jsonDictionary = jsonResponse as? [String: Any] {
            otherFlightsDictionary = jsonDictionary
        } else {
            return  
        }
        
        var flightsJsonArray: [Any] = []
        if let jsonArray = otherFlightsDictionary["other_flights"] as? [Any] {
            flightsJsonArray = jsonArray
        } else {
            return  
        }
        

        
        
        for flightJsonObject in flightsJsonArray{
            
            var flightsDataDictionary = [String: Any]()
            
            if let jObject = flightJsonObject as? [String: Any] {
                flightsDataDictionary = jObject
            } else {
                continue
            }
            var flightsDictionary = [[String: Any]]()
            if let jObject = flightsDataDictionary["flights"] as? [[String: Any]] {
                flightsDictionary = jObject
            } else {
                return
            }
            var departureDictionary = [String: Any]()
            
            if let jObject = flightsDictionary[0]["departure_airport"] as? [String: Any] {
                departureDictionary = jObject
            } else {
                return
            }
            

            /*
             "departure_airport": {
                         "name": "String - Departure airport name",
                         "id": "String - Departure airport code",
                         "time": "String - Departure time"
                       }
             */
            
            var departureName = ""
            var departure_id = ""
            var boarding_time = ""
            
            
            // Goes through each part of the JSON data and checks if there exists a value
            // If a value exists, then it is saved in the variable to be added to the struct, if not, we skip onto the next object
            if let dName = departureDictionary["name"] as? String {
                departureName = dName
            } else{
                continue
            }
            if let dId = departureDictionary["id"] as? String {
                departure_id = dId
            } else{
                continue
            }
            if let time = departureDictionary["time"] as? String {
                boarding_time = time
            } else{
                continue
            }
            
            var arrivalDictionary = [String: Any]()
            
            if let jObject = flightsDictionary[0]["arrival_airport"] as? [String: Any] {
                arrivalDictionary = jObject
            } else {
                continue
            }
            /*
             "arrivalairport": {
                         "name": "String - Departure airport name",
                         "id": "String - Departure airport code",
                         "time": "String - Departure time"
                       }
             */
            
            var arrivalName = ""
            var arrival_id = ""
            var arrival_time = ""
            
            
            // Goes through each part of the JSON data and checks if there exists a value
            // If a value exists, then it is saved in the variable to be added to the struct, if not, we skip onto the next object
            if let aName = arrivalDictionary["name"] as? String {
                arrivalName = aName
            } else{
                continue
            }
            if let aId = arrivalDictionary["id"] as? String {
                arrival_id = aId
            } else{
                continue
            }
            if let time = arrivalDictionary["time"] as? String {
                arrival_time = time
            } else{
                continue
            }
            
            var airline = ""
            if let line = flightsDictionary[0]["airline"] as? String {
                airline = line
            } else{
                continue
            }
            var airlineLogo = ""
            if let logo = flightsDictionary[0]["airline_logo"] as? String {
                airlineLogo = logo
            } else{
                continue
            }
            var duration = -1
            if let d = flightsDictionary[0]["duration"] as? Int {
                duration = d
            } else{
                continue
            }
            var flightNum = ""
            if let num = flightsDictionary[0]["flight_number"] as? String {
                flightNum = num
            } else{
                continue
            }
            
            
            
            
            
            //Creates the city object
            let flightFound = FlightAPIJsonStruct(departureAirport: departureName,
                                                  departureCode: departure_id,
                                                  arrivalAirport: arrivalName,
                                                  arrivalCode: arrival_id,
                                                  airline: airline,
                                                  airlineLogo: airlineLogo,
                                                  boardingTime: boarding_time,
                                                  arrivalTime: arrival_time,
                                                  duration: duration,
                                                  flightNumber: flightNum)
            
            foundFlightsList.append(flightFound)
            
        }
        
    }
    catch{
        return //List will be empty
    }

}
