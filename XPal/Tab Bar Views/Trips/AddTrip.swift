//
//  AddTrip.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balcion 4/22/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import SwiftUI
import SwiftData



struct AddTrip: View{
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss

    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var location = ""
    @State private var description = ""
    @State private var hotels = [Hotel]()
    @State private var flights = [FlightInfo]()
    
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    
    
    @State private var showAlertMessage = false
    
    var body: some View{
        
        return AnyView(
            Form{
                Group{
                    Section(header: Text("Trip Name")) {
                        TextField("Enter trip name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section(header: Text("Trip Location")) {
                        TextField("Enter trip location", text: $location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section(header: Text("Trip Description"), footer:
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
                }
            }//End of Form
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if inputDataValidated() {
                            saveNewTripToDatabase()
                            showAlertMessage = true
                            alertTitle = "New Trip Added!"
                            alertMessage = "New trip is successfully added to database."
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
                          if alertTitle == "New Trip Added!" {
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
            let newTrip = Trip(name: name,
                               tripDescription: description,
                               flights: [FlightInfo](),
                               location: location,
                               hotels: [Hotel]())
            
            // Insert the new Photo object into the database
            modelContext.insert(newTrip)
            
            name = ""
            location = ""
            description = ""
            
        }   // End of function

    }
}



 

