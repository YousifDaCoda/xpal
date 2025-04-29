//
//  TripDetails.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/21/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import SwiftUI

struct TripDetails: View {
    
    var trip: Trip
    
    @State private var selectedMapStyleIndex = 0
    
    var body: some View {
        
        return AnyView(
            Form{
            
                Section(header: Text("Trip Title")){
                    
                    Text("\(trip.name)")
                }
                Section(header: Text("Trip Location")){
                    
                    Text("\(trip.location)")
                }
                Section(header: Text("Trip Overview")){
                    
                    Text("\(trip.tripDescription)")
                }
                Section(header: Text("Trip Hotels")){
                    
                    NavigationLink(destination: HotelsList(hotelList: trip.hotels, trip: trip)){
                        HStack{
                            Image(systemName: "building.fill")
                                .foregroundStyle(.blue)
                            Text("Hotels from Trip")
                                .foregroundStyle(.blue)
                        }
                    }
                }
                Section(header: Text("Trip Flights")){
                    
                    NavigationLink(destination: FlightsList(flightList: trip.flights, trip: trip)){
                        HStack{
                            Image(systemName: "airplane.departure")
                                .foregroundStyle(.blue)
                            Image(systemName: "airplane.arrival")
                                .foregroundStyle(.blue)
                            Text("Flights for Trip")
                                .foregroundStyle(.blue)
                        }
                    }
                }
        })

        .font(.system(size: 14))
        .navigationTitle("Trip Details")
        .toolbarTitleDisplayMode(.inline)
    }

}
