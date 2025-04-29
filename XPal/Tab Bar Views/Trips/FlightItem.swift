//
//  TripItems.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/21/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import SwiftUI

struct FlightItem: View {
    
    // Input Parameter
    let flight: FlightInfo
    
    var body: some View {
        VStack(alignment: .leading){
            Text("\(flight.departureCode) to \(flight.arrivalCode)")
                .font(.system(size: 20))
                .fontWeight(.bold)
            Text("\(flight.date) at \(flight.boardingTime)")
                .font(.system(size: 14))
        }
    }
}
