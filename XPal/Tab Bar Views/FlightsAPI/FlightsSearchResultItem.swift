//
//  FlightsSearchResultItem.swift
//  XPal
//
//  Created by Ryan Pini & Osman Balci on 3/3/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI

struct FlightSearchResultItem: View {
    
    // Input Parameter
    let flightStruct: FlightAPIJsonStruct
    
    var body: some View {
        
        HStack {
            
            //Gets flag image for a given city's country
            getImageFromUrl(url: flightStruct.airlineLogo, defaultFilename: "ImageUnavailble")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75)
            
            VStack(alignment: .leading) {
                Text("\(flightStruct.airline) Flight \(flightStruct.flightNumber)")
                Text("\(flightStruct.departureCode) to \(flightStruct.arrivalCode)")
                Text("Depart: \(flightStruct.boardingTime)\nArrive \(flightStruct.arrivalTime)")
            }
            .font(.system(size: 14))
        }
    }
}

