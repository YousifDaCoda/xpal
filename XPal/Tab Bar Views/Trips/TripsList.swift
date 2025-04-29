//
//  TripList.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/21/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import SwiftUI
import SwiftData

struct TripsList: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Trip>(sortBy: [SortDescriptor(\Trip.name, order: .forward)])) private var listOfAllTripsInDatabase: [Trip]
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
       
    var body: some View {
        NavigationStack {
            List {
                // Search Bar: 2 of 4 --> Use filteredListOfVideos
                ForEach(listOfAllTripsInDatabase) { aTrip in
                    NavigationLink(destination: TripDetails(trip: aTrip)) {
                        TripsItem(trip: aTrip)
                            .alert(isPresented: $showConfirmation) {
                                Alert(title: Text("Delete Confirmation"),
                                      message: Text("Are you sure to permanently delete the trip?"),
                                      primaryButton: .destructive(Text("Delete")) {
                                    /*
                                    'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                     element to be deleted. It is nil if the array is empty. Process it as an optional.
                                    */
                                    if let index = toBeDeleted?.first {
                                        let tripToDelete = listOfAllTripsInDatabase[index]
                                        modelContext.delete(tripToDelete)
                                    }
                                    toBeDeleted = nil
                                }, secondaryButton: .cancel() {
                                    toBeDeleted = nil
                                }
                            )
                        }   // End of alert
                    }   // End of NavigationLink
                }   // End of ForEach
                .onDelete(perform: delete)
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("List of Trips")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddTrip()) {
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

