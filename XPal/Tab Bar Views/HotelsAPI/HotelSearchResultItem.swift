//
//  HotelSearchResultItem.swift
//  XPal
//
//  Created by Ryan Pini & Osman Balci on 3/3/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI

struct HotelSearchResultItem: View {
    
    // Input Parameter
    let hotelStruct: HotelAPIJsonStruct
    
    var body: some View {
        
        HStack {
            
            //Gets flag image for a given city's country
            getImageFromUrl(url: hotelStruct.image, defaultFilename: "ImageUnavailble")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75)
            
            VStack(alignment: .leading) {
                Text(hotelStruct.name)
                Text("Check In: \(hotelStruct.checkIn) | Check Out: \(hotelStruct.checkOut)")
            }
            .font(.system(size: 14))
        }
    }
}

