//
//  FlightSearchResultDetails.swift
//  XPal
//
//  Created by Ryan Pini & Osman Balci on 5/5/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

struct FlightSearchResultDetails: View {
    
    // Input Parameter
    let flightStruct: FlightAPIJsonStruct
    
    /*
     @Environment property wrapper is used to obtain the modelContext object reference
     injected into the environment in CitiesApp.swift via .modelContainer.
     modelContext is the workspace where database objects are managed by using
     modelContext.insert(), modelContext.delete() or modelContext.save().
     */
    @Environment(\.modelContext) private var modelContext
    
    
    @State private var showAlertMessage = false
    @State private var showConfirmation = false
    
    var body: some View {
        
        
        return AnyView(
            Form{
                Section(header: Text("Departure Airport")){
                    Text("\(flightStruct.departureAirport)")
                }
                Section(header: Text("Arrival Airport")){
                    Text("\(flightStruct.arrivalAirport)")
                }
                Section(header: Text("Airline Flight Number")){
                    Text("\(flightStruct.airline) Flight \(flightStruct.flightNumber)")
                }
                Section(header: Text("Airline Logo")){
                    
                    //Get flag for given city's country
                    getImageFromUrl(url: flightStruct.airlineLogo, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        // Flag image is obtained from the API with width of 320
                        .frame(minWidth: 200, maxWidth: 200, alignment: .center)
                }
                Section(header: Text("Departure Time")){
                    Text("\(flightStruct.boardingTime)")
                }
                Section(header: Text("Arrival Time")){
                    Text("\(flightStruct.arrivalTime)")
                }
                Section(header: Text("Flight Duration")){
                    Text("\(flightStruct.duration) minutes")
                }
            }
                .navigationTitle("Flight Details")
                .toolbarTitleDisplayMode(.inline)
                .font(.system(size: 14))
                .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                    Button("OK") {}
                }, message: {
                    Text(alertMessage)
                })
        )   // End of AnyView
    }   // End of body var
}

