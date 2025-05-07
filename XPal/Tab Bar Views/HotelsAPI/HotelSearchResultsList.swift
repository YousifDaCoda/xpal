//
//  ApiSearchResultsList.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/22/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI

struct HotelSearchResultsList: View {
    var body: some View {
        List {
            ForEach(foundHotelsList, id:\.self) { aHotel in
                NavigationLink(destination: HotelSearchResultDetails(hotelStruct: aHotel)) {
                    HotelSearchResultItem(hotelStruct: aHotel)
                }
            }
        }
        .font(.system(size: 14))
        .navigationTitle("Hotels Found")
        .toolbarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    FlightSearchResultsList()
}
