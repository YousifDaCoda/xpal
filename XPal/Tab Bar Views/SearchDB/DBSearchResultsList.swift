//
//  DBSearchResultsList.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/21/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI

struct DBSearchResultsList: View {
    var body: some View {
        List {
            ForEach(databaseSearchResults) { aFoundTrip in
                NavigationLink(destination: TripDetails(trip: aFoundTrip)) {
                    TripsItem(trip: aFoundTrip)
                }
            }
        }
        .navigationTitle("Database Search Results")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    DBSearchResultsList()
}
