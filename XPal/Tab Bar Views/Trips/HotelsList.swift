//
//  TripList.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/21/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import SwiftUI
import SwiftData

struct HotelsList: View {
    
    var hotelList: [Hotel]
    var trip: Trip
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
       
    var body: some View {
        NavigationStack {
            List {
                // Search Bar: 2 of 4 --> Use filteredListOfVideos
                ForEach(hotelList) { aHotel in
                    NavigationLink(destination: HotelDetails(hotel: aHotel)) {
                        HotelItem(hotel: aHotel)
                    }   // End of NavigationLink
                }   // End of ForEach
                .onDelete(perform: delete)
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("List of Hotels")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddHotel(trip: trip)) {
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

