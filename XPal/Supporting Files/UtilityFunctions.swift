//
//  UtilityFunctions.swift
//  Videos
//
//  Created by Ryan Pini & Osman Balci on 4/1/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI
import AVFoundation

// Global constant
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

/*
***********************************************
MARK: Decode JSON file into an Array of Structs
***********************************************
*/
public func decodeJsonFileIntoArrayOfStructs<T: Decodable>(fullFilename: String, fileLocation: String, as type: T.Type = T.self) -> T {
    
    /*
     T.self defines the struct type T into which each JSON object will be decoded.
        exampleStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "exampleFile.json", fileLocation: "Main Bundle")
     or
        exampleStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "exampleFile.json", fileLocation: "Document Directory")
     The left hand side of the equation defines the struct type T into which JSON objects will be decoded.
     
     This function returns an array of structs of type T representing the JSON objects in the input JSON file.
     In Swift, an Array stores values of the same type in an ordered list. Therefore, the structs will keep their order.
     */
    
    var jsonFileData: Data?
    var jsonFileUrl: URL?
    var arrayOfStructs: T?
    
    if fileLocation == "Main Bundle" {
        // Obtain URL of the JSON file in main bundle
        let urlOfJsonFileInMainBundle: URL? = Bundle.main.url(forResource: fullFilename, withExtension: nil)
        
        if let mainBundleUrl = urlOfJsonFileInMainBundle {
            jsonFileUrl = mainBundleUrl
        } else {
            print("JSON file \(fullFilename) does not exist in main bundle!")
        }
    } else {
        // Obtain URL of the JSON file in document directory on user's device
        let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent(fullFilename)
        
        if let docDirectoryUrl = urlOfJsonFileInDocumentDirectory {
            jsonFileUrl = docDirectoryUrl
        } else {
            print("JSON file \(fullFilename) does not exist in document directory!")
        }
    }
    
    do {
        jsonFileData = try Data(contentsOf: jsonFileUrl!)
    } catch {
        print("Unable to obtain JSON file \(fullFilename) content!")
    }
    
    do {
        // Instantiate an object from the JSONDecoder class
        let decoder = JSONDecoder()
        
        // Use the decoder object to decode JSON objects into an array of structs of type T
        arrayOfStructs = try decoder.decode(T.self, from: jsonFileData!)
    } catch {
        print("Unable to decode JSON file \(fullFilename) because your Struct attribute names do not exactly match the JSON file attribute names!")
    }
    
    // Return the array of structs of type T
    return arrayOfStructs!
}


public func getImageFromUrl(url: String, defaultFilename: String) -> Image {
    /*
     If getting image from URL fails, Image file with given defaultFilename
     (e.g., "ImageUnavailable") in Assets.xcassets will be returned.
     */
    var imageObtainedFromUrl = Image(defaultFilename)
 
    let headers = [
        "accept": "image/jpg, image/jpeg, image/png",
        "cache-control": "cache",
        "connection": "keep-alive",
    ]
 
    // Convert given URL string into URL struct
    guard let imageUrl = URL(string: url) else {
        return Image(defaultFilename)
    }
 
    let request = NSMutableURLRequest(url: imageUrl,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 30.0)
 
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
 
    /*
     Create a semaphore to control getting and processing image data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
 
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
        URLSession is established and the image file from the URL is set to be fetched
        in an asynchronous manner. After the file is fetched, data, response, error
        are returned as the input parameter values of this Completion Handler Closure.
        */
 
        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
 
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            semaphore.signal()
            return
        }
 
        // Unwrap Optional 'data' to see if it has a value
        guard let imageDataFromUrl = data else {
            semaphore.signal()
            return
        }
 
        // Convert fetched imageDataFromUrl into UIImage object
        let uiImage = UIImage(data: imageDataFromUrl)
 
        // Unwrap Optional uiImage to see if it has a value
        if let imageObtained = uiImage {
            // UIImage is successfully obtained. Convert it to SwiftUI Image.
            imageObtainedFromUrl = Image(uiImage: imageObtained)
        }
 
        semaphore.signal()
    }).resume()
 
    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.
 
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 30 seconds expires.
    */
 
    _ = semaphore.wait(timeout: .now() + 30)
 
    return imageObtainedFromUrl
}

public func formatTimestamp(timestamp: String) -> String {

    /*
     ISO 8601 Timestamp comes from the API in different formats after seconds:
         2023-01-20T15:58:17Z
         2023-01-19T15:00:11+00:00
         2023-01-15T18:53:26.2988181Z

     This function converts it to the formet: 2023-01-20
     */
    if !timestamp.contains("T") { return "Invalid Timestamp" }

    let inputDateFormatter = DateFormatter()
    inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"

    var sortableDateAndTime = ""
    if let dateFromStringInInputFormat = inputDateFormatter.date(from: timestamp) {

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"

        sortableDateAndTime = outputDateFormatter.string(from: dateFromStringInInputFormat)
    }

    return sortableDateAndTime

}

/*
***********************************
MARK: Format YouTube Video Duration
***********************************
*/
public func formatYouTubeVideoDuration(inputDuration: String) -> String {

    /*
     inputDuration is in the ISO 8601 format, e.g., "PT5H16M20S"
     PT stands for Period of Time, H = hours, M = minutes, S = seconds
     */
    let convertedInputDuration = inputDuration.replacingOccurrences(of: "PT", with: "").replacingOccurrences(of: "H", with:":").replacingOccurrences(of: "M", with: ":").replacingOccurrences(of: "S", with: "")
    // convertedInputDuration = "5:16:20"
    let components = convertedInputDuration.components(separatedBy: ":")
    var duration = ""
    for aComponent in components {
        duration = duration.count > 0 ? duration + ":" : duration
        if aComponent.count < 2 {
            duration += "0" + aComponent
            continue
        }
        duration += aComponent
    }
    // duration = 05:16:20
    return duration

}

 

