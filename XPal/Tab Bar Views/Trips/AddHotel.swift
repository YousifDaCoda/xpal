//
//  AddTrip.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balcion 4/22/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import SwiftUI
import SwiftData



struct AddHotel: View{
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss

    @Environment(\.modelContext) private var modelContext
    
    var trip: Trip
    
    @State private var name = ""
    @State private var location = ""
    @State private var description = ""
    @State private var checkIn = ""
    @State private var checkOut = ""

    
    @State private var latitudeText = ""
    @State private var longitudeText = ""
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    
    
    @State private var showAlertMessage = false
    
    var body: some View{
        
        return AnyView(
            Form{
                Group{
                    Section(header: Text("Hotel Name")) {
                        TextField("Enter trip name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section(header: Text("Hotel Location")) {
                        TextField("Enter trip location", text: $location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section(header: Text("Hotel Description"), footer:
                                HStack {
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Image(systemName: "keyboard")
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                        
                        Button(action: {    // Button to clear the text editor content
                            description = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                    ) {
                        TextEditor(text: $description)
                            .frame(height: 100)
                            .font(.custom("Helvetica", size: 14))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    Section(header: Text("Check In Time")) {
                        TextField("Enter Check In Time as X:XX AM/PM", text: $checkIn)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section(header: Text("Check Out Time")) {
                        TextField("Enter Check Out Time as X:XX AM/PM", text: $checkOut)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                }
                Group{
                    Section(header: Text("Hotel Location Latitude"), footer: Text("Return on keyboard after entering value.").italic()) {
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
                    Section(header: Text("Hotel Location Longitude"), footer: Text("Return on keyboard after entering value.").italic()) {
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
                            alertTitle = "New Hotel Added!"
                            alertMessage = "New hotel is successfully added to database."
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
                          if alertTitle == "New Hotel Added!" {
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
            
            //-----------------------------------------------
            // Instantiate a new Restaurant object and dress it up
            //-----------------------------------------------
            let newHotel = Hotel(name: name,
                                 hotelDescription: description,
                                 location: location,
                                 checkIn: checkIn,
                                 checkOut: checkOut,
                                 latitude: latitude,
                                 longitude: longitude)
            
            // Insert the new Photo object into the database
            modelContext.insert(newHotel)
            trip.hotels.append(newHotel)
            
            name = ""
            location = ""
            description = ""
            latitudeText = ""
            longitudeText = ""
            checkIn = ""
            checkOut = ""
            
        }   // End of function

    }
}



 

