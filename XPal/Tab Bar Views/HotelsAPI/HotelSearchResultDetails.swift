//
//  HotelSearchResultDetails.swift
//  XPal
//
//  Created by Ryan Pini & Osman Balci on 5/5/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData
import MapKit

fileprivate var mapCenterCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct HotelSearchResultDetails: View {
    
    // Input Parameter
    let hotelStruct: HotelAPIJsonStruct
    
    @State private var selectedMapStyleIndex = 0
    var mapStyles = ["Standard", "Satellite", "Hybrid", "Globe"]
    
    /*
     @Environment property wrapper is used to obtain the modelContext object reference
     injected into the environment in CitiesApp.swift via .modelContainer.
     modelContext is the workspace where database objects are managed by using
     modelContext.insert(), modelContext.delete() or modelContext.save().
     */
    @Environment(\.modelContext) private var modelContext
    
    
    @State private var showAlertMessage = false
    @State private var showConfirmation = false
    
    var body: some View {
        
        mapCenterCoordinate = CLLocationCoordinate2D(latitude: hotelStruct.latitude, longitude: hotelStruct.longitude)
        
        return AnyView(
            Form{
                Section(header: Text("Hotel Name")){
                    Text("\(hotelStruct.name)")
                }
                Section(header: Text("Hotel Description")){
                    Text("\(hotelStruct.description)")
                }
                Section(header: Text("Check In")){
                    Text("\(hotelStruct.checkIn)")
                }
                Section(header: Text("Check Out")){
                    Text("\(hotelStruct.checkOut)")
                }
                Section(header: Text("Hotel Image")){
                    
                    //Get flag for given city's country
                    getImageFromUrl(url: hotelStruct.image, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        // Flag image is obtained from the API with width of 320
                        .frame(minWidth: 200, maxWidth: 200, alignment: .center)
                }
                Section(header: Text("Link to Hotel Website")){
                    Link(destination: URL(string: hotelStruct.link)!) {
                        HStack {
                            Image(systemName: "globe")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Website")
                                .font(.system(size: 16))
                        }
                    }
                }
                Section(header: Text("Select Map Style"), footer: Text("Hotel Map Provided by Apple Maps").italic()) {
                    
                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0 ..< mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    NavigationLink(destination: ApiHotelLocationOnMap(hotel: hotelStruct, mapStyleIndex: selectedMapStyleIndex)) {
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
            }
                .navigationTitle("Flight Details")
                .toolbarTitleDisplayMode(.inline)
                .font(.system(size: 14))
                .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                    Button("OK") {}
                }, message: {
                    Text(alertMessage)
                })
        )   // End of AnyView
    }   // End of body var
}

struct ApiHotelLocationOnMap: View {
    
    // Input Parameters
    let hotel: HotelAPIJsonStruct
    let mapStyleIndex: Int
    
    @State private var mapCameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            // mapCenterCoordinate is a fileprivate var
            center: mapCenterCoordinate,
            // 1 degree = 69 miles. 30 degrees = 2,070 miles
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
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

