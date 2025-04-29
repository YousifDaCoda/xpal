//
//  TripDetails.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/21/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import SwiftUI
import MapKit

fileprivate var mapCenterCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct HotelDetails: View {
    
    var hotel: Hotel
    
    @State private var selectedMapStyleIndex = 0
    var mapStyles = ["Standard", "Satellite", "Hybrid", "Globe"]
    
    var body: some View {
        
        mapCenterCoordinate = CLLocationCoordinate2D(latitude: hotel.latitude, longitude: hotel.longitude)
        
        return AnyView(
            Form{
            
                Section(header: Text("Hotel Title")){
                    
                    Text("\(hotel.name)")
                }
                Section(header: Text("Hotel Location")){
                    
                    Text("\(hotel.location)")
                }
                Section(header: Text("Hotel Overview")){
                    
                    Text("\(hotel.hotelDescription)")
                }
                Section(header: Text("Check In")){
                    
                    Text("\(hotel.checkIn)")
                }
                Section(header: Text("Check Out")){
                    
                    Text("\(hotel.checkOut)")
                }
                Section(header: Text("Select Map Style"), footer: Text("Hotel Map Provided by Apple Maps").italic()) {
                    
                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0 ..< mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    NavigationLink(destination: HotelLocationOnMap(hotel: hotel, mapStyleIndex: selectedMapStyleIndex)) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                                .foregroundStyle(.blue)
                            Text("Show Hotel Location on Map")
                                .font(.system(size: 16))
                                .foregroundStyle(.blue)
                        }
                    }
                }
        })

        .font(.system(size: 14))
        .navigationTitle("Hotel Details")
        .toolbarTitleDisplayMode(.inline)
    }

}


struct HotelLocationOnMap: View {
    
    // Input Parameters
    let hotel: Hotel
    let mapStyleIndex: Int
    
    @State private var mapCameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            // mapCenterCoordinate is a fileprivate var
            center: mapCenterCoordinate,
            // 1 degree = 69 miles. 30 degrees = 2,070 miles
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    var body: some View {
        
        var mapStyle: MapStyle = .standard
        
        switch mapStyleIndex {
        case 0:
            mapStyle = MapStyle.standard
        case 1:
            mapStyle = MapStyle.imagery     // Satellite
        case 2:
            mapStyle = MapStyle.hybrid
        case 3:
            mapStyle = MapStyle.hybrid(elevation: .realistic)   // Globe
        default:
            print("Map style is out of range!")
        }
        
        return AnyView(
            Map(position: $mapCameraPosition) {
                Marker(hotel.name, coordinate: mapCenterCoordinate)
            }
            .mapStyle(mapStyle)
            .navigationTitle(hotel.name)
            .toolbarTitleDisplayMode(.inline)
        )
    }
}
