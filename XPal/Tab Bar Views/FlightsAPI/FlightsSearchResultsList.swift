//
//  ApiSearchResultsList.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/22/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI

struct FlightSearchResultsList: View {
    var body: some View {
        List {
            ForEach(foundFlightsList, id:\.self) { aFlight in
                NavigationLink(destination: FlightSearchResultDetails(flightStruct: aFlight)) {
                    FlightSearchResultItem(flightStruct: aFlight)
                }
            }
        }
        .font(.system(size: 14))
        .navigationTitle("Flights from \(foundFlightsList[0].departureCode) to \(foundFlightsList[0].arrivalCode)")
        .toolbarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    FlightSearchResultsList()
}
