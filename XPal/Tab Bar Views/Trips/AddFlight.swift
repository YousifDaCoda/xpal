//
//  AddTrip.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balcion 4/22/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import SwiftUI
import SwiftData



struct AddFlight: View{
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss

    @Environment(\.modelContext) private var modelContext
    
    var trip: Trip
    
    @State private var departureAirport = ""
    @State private var departureCode = ""
    @State private var arrivalAirport = ""
    @State private var arrivalCode = ""
    @State private var airline = ""
    @State private var boardingTime = ""
    @State private var terminal = ""
    @State private  var date = Date()
    
    @State private var latitudeText = ""
    @State private var longitudeText = ""
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    
    
    @State private var showAlertMessage = false
    
    var body: some View{
        
        return AnyView(
            Form{
                Group{
                    Section(header: Text("Departure Airport")) {
                        TextField("Enter Airport", text: $departureAirport)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section(header: Text("Departure Code")) {
                        TextField("Enter 3 Letter Code", text: $departureCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section(header: Text("Arrival Airport")) {
                        TextField("Enter Airport", text: $arrivalAirport)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section(header: Text("Arrival Code")) {
                        TextField("Enter 3 Letter Code", text: $arrivalCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section(header: Text("Airline")) {
                        TextField("Enter Airline", text: $airline)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section(header: Text("Boarding Time")) {
                        TextField("Enter Boarding Time", text: $boardingTime)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section(header: Text("Terminal")) {
                        TextField("Terminal", text: $terminal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section(header: Text("Date")){
                        
                        DatePicker(
                            selection: $date,
                            displayedComponents: .date // Sets DatePicker to pick a date
                        ){
                            Text("Flight Date")
                        }
                    }
                }
                Group{
                    Section(header: Text("Arrival Airport Location Latitude"), footer: Text("Return on keyboard after entering value.").italic()) {
                        HStack {
                            TextField("0.0", text: $latitudeText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .onSubmit {
                                    if let lat = Double(latitudeText) {
                                        latitude = lat
                                        // Latitude must be a number between -90 and 90
                                        if ((latitude > -90.0) && (latitude < 90.0)) {
                                            // Valid latitude value
                                        } else {
                                            showAlertMessage = true
                                            alertTitle = "Invalid Latitude Value!"
                                            alertMessage = "Valid latitude must be > -90.0 and < 90.0"
                                        }
                                    } else {
                                        showAlertMessage = true
                                        alertTitle = "Invalid Latitude Value!"
                                        alertMessage = "Entered latitude value \(latitude) is not a number."
                                    }
                                }
                            Button(action: {    // Button to clear the text field
                                latitudeText = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                    }
                    Section(header: Text("Arrival Airport Location Longitude"), footer: Text("Return on keyboard after entering value.").italic()) {
                        HStack {
                            TextField("0.0", text: $longitudeText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .onSubmit {
                                    if let lon = Double(longitudeText) {
                                        longitude = lon
                                        // Latitude must be a number between -90 and 90
                                        if ((longitude > -180.0) && (longitude < 180.0)) {
                                            // Valid latitude value
                                        } else {
                                            showAlertMessage = true
                                            alertTitle = "Invalid longitude Value!"
                                            alertMessage = "Valid longitude must be > -180.0 and < 180.0"
                                        }
                                    } else {
                                        showAlertMessage = true
                                        alertTitle = "Invalid longitude Value!"
                                        alertMessage = "Entered longitude value \(longitude) is not a number."
                                    }
                                }
                            Button(action: {    // Button to clear the text field
                                longitudeText = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                    }
                }
            }//End of Form
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if inputDataValidated() {
                            saveNewTripToDatabase()
                            showAlertMessage = true
                            alertTitle = "New Flight Added!"
                            alertMessage = "New flight is successfully added to database."
                        } else {
                            showAlertMessage = true
                            alertTitle = "Missing Input Data!"
                            alertMessage = "All Fields are required.  Ranking default is used if not selected."
                        }
                    }) {
                        Text("Save")
                    }
                }
            }
                .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                      Button("OK") {
                          if alertTitle == "New Flight Added!" {
                              // Dismiss this view and go back to the previous view
                              dismiss()
                          }
                      }
                    }, message: {
                      Text(alertMessage)
                    })
        )
            
            /*
             ---------------------------------------
             MARK: Voice Recording Microphone Tapped
             ---------------------------------------
             */
        
        func inputDataValidated() -> Bool {
            
            return true
        }
        
        func saveNewTripToDatabase() {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.locale = Locale(identifier: "en_US")
            let formattedDate = dateFormatter.string(from: date)
            
            //-----------------------------------------------
            // Instantiate a new Restaurant object and dress it up
            //-----------------------------------------------
            
            
            let newFlight = FlightInfo(departureAirport: departureAirport,
                                       departureCode: departureCode,
                                       arrivalAirport: arrivalAirport,
                                       arrivalCode: arrivalCode,
                                       airline: airline,
                                       boardingTime: boardingTime,
                                       terminal: terminal,
                                       date: formattedDate,
                                       latitude: latitude, longitude: longitude)
            
            // Insert the new Photo object into the database
            modelContext.insert(newFlight)
            trip.flights.append(newFlight)
            
            departureAirport = ""
            departureCode = ""
            arrivalCode = ""
            arrivalAirport = ""
            latitudeText = ""
            longitudeText = ""
            boardingTime = ""
            terminal = ""
            airline = ""
            
        }   // End of function

    }
}



 

