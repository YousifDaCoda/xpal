//
//  TripItems.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/21/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import SwiftUI

struct HotelItem: View {
    
    // Input Parameter
    let hotel: Hotel
    
    var body: some View {
        VStack(alignment: .leading){
            Text(hotel.name)
                .font(.system(size: 20))
                .fontWeight(.bold)
            Text(hotel.location)
                .font(.system(size: 14))
        }
    }
}
