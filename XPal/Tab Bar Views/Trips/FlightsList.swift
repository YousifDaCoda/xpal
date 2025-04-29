//
//  TripList.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/21/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import SwiftUI
import SwiftData

struct FlightsList: View {
    
    var flightList: [FlightInfo]
    var trip: Trip
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
       
    var body: some View {
        NavigationStack {
            List {
                // Search Bar: 2 of 4 --> Use filteredListOfVideos
                ForEach(flightList) { aFlight in
                    NavigationLink(destination: FlightDetails(flight: aFlight)) {
                        FlightItem(flight: aFlight)
                    }   // End of NavigationLink
                }   // End of ForEach
                .onDelete(perform: delete)
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("List of Flights")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddFlight(trip: trip)) {
                        Image(systemName: "plus")
                    }
                }
            }   // End of toolbar
            
        }   // End of NavigationStack
    }
    
    /*
     ---------------------------
     MARK: Delete Selected Trip
     ---------------------------
     */
    private func delete(offsets: IndexSet) {
        toBeDeleted = offsets
        showConfirmation = true
    }
}

#Preview {
    TripsList()
}

