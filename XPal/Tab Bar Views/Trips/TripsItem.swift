//
//  TripItems.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/21/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import SwiftUI

struct TripsItem: View {
    
    // Input Parameter
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading){
            Text(trip.name)
                .font(.system(size: 20))
                .fontWeight(.bold)
            Text(trip.location)
                .font(.system(size: 14))
        }
    }
}
