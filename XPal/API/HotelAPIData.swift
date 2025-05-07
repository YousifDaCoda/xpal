//
//  HotelAPIData.swift
//  XPal
//
//  Created by Ryan Pini & Osman Balci on 3/3/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import Foundation

var foundHotelsList = [HotelAPIJsonStruct]()

public func getFoundHotelsFromApi(query: [String]) {
    
    let apiUrlString = "https://serpapi.com/search.json?engine=google_hotels&q=\(query[0])&check_in_date=\(query[1])&check_out_date=\(query[2])&api_key=\(mySerpApiKey)"
    
    foundHotelsList = [HotelAPIJsonStruct]()
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
        
        var topDictionary = [String: Any]()
        
        if let jsonDictionary = jsonResponse as? [String: Any] {
            topDictionary = jsonDictionary
        } else {
            return
        }
        
        var propertiesArray: [Any] = []
        if let jsonArray = topDictionary["properties"] as? [Any] {
            propertiesArray = jsonArray
        } else {
            return
        }
        

        
        
        for hotelJsonObject in propertiesArray{
            
            var hotelDictionary = [String: Any]()
            
            if let jObject = hotelJsonObject as? [String: Any] {
                hotelDictionary = jObject
            } else {
                continue
            }
            
            var name = ""
            var description = ""
            var checkIn = ""
            var checkOut = ""
            var link = ""
            
            if let jObject = hotelDictionary["name"] as? String {
                name = jObject
            } else {
                return
            }
            if let jObject = hotelDictionary["description"] as? String {
                description = jObject
            } else {
                description = "No Description Provided"
            }
            if let jObject = hotelDictionary["check_in_time"] as? String {
                checkIn = jObject
            } else {
                return
            }
            if let jObject = hotelDictionary["check_out_time"] as? String {
                checkOut = jObject
            } else {
                return
            }
            if let jObject = hotelDictionary["link"] as? String {
                link = jObject
            } else {
                return
            }
            
            var latitude = 0.0
            var longitude = 0.1
            var gpsDictionary: [String: Any] = [String: Any]()
            if let jObject = hotelDictionary["gps_coordinates"] as? [String: Any] {
                gpsDictionary = jObject
            } else {
                continue
            }
            
            if let jObject = gpsDictionary["latitude"] as? Double {
                latitude = jObject
            } else {
                return
            }
            if let jObject = gpsDictionary["longitude"] as? Double {
                longitude = jObject
            } else {
                return
            }
            
            var imageUrl = ""
            var imageDictionary: [[String: Any]] = [[String: Any]]()
            if let jObject = hotelDictionary["images"] as? [[String: Any]] {
                imageDictionary = jObject
            } else {
                continue
            }
            
            if let jObject = imageDictionary[0]["original_image"] as? String {
                imageUrl = jObject
            } else {
                return
            }
            
            
            
            
            //Creates the city object
            let hotelFound = HotelAPIJsonStruct(name: name,
                                                description: description,
                                                checkIn: checkIn,
                                                checkOut: checkOut,
                                                latitude: latitude,
                                                longitude: longitude,
                                                image: imageUrl,
                                                link: link)
            
            foundHotelsList.append(hotelFound)
            
        }
        
    }
    catch{
        return //List will be empty
    }

}
