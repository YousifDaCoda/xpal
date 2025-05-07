//
//  SearchHotels.swift
//  XPal
//
//  Created by Ryan Pini & Osman Balci on 5/5/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI

struct SearchHotels: View {
    
    @State private var locationFieldValue = ""
    @State private var checkInDate = Date()
    @State private var checkOutDate = Date()
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: "building.2.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                            .foregroundStyle(.blue)
                        Spacer()
                    }
                }
                Section(header: Text("Enter Location for Hotel")) {
                    HStack {
                        TextField("Enter Search Query", text: $locationFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        
                        // Button to clear the text field
                        Button(action: {
                            locationFieldValue = ""
                            showAlertMessage = false
                            searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        
                    }   // End of HStack
                }
                Section(header: Text("Check In Date")){
                    
                    DatePicker(
                        selection: $checkInDate,
                        displayedComponents: .date // Sets DatePicker to pick a date
                    ){
                        Text("Check In Date")
                    }
                }
                Section(header: Text("Check Out Date")){
                    
                    DatePicker(
                        selection: $checkOutDate,
                        displayedComponents: .date // Sets DatePicker to pick a date
                    ){
                        Text("Check Out Date")
                    }
                }
                Section(header: Text("Search for Hotels")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchApi()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Missing Input Data!"
                                alertMessage = "Please enter a search query!"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                    }   // End of HStack
                }
                
                if searchCompleted {
                    Section(header: Text("Show Hotels Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Show Hotels Found")
                                    .font(.system(size: 16))
                            }
                        }
                    }
                }
            }
                      // End of Form
                .navigationTitle("Search for Hotels")
                .toolbarTitleDisplayMode(.inline)
                .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                    Button("OK") {}
                }, message: {
                    Text(alertMessage)
                })
                
        }   // End of NavigationStack
    }   // End of body var
        
        /*
         ----------------
         MARK: Search API
         ----------------
         */
        func searchApi(){
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedCheckInDate = dateFormatter.string(from: checkInDate)
            let formattedCheckOutDate = dateFormatter.string(from: checkOutDate)
            let searchQuery = locationFieldValue.replacingOccurrences(of: " ", with: "+")
            let queries = [searchQuery, formattedCheckInDate, formattedCheckOutDate]
            
           
            // Public function getFoundCountriesFromApi is given in CountryApiData.swift
            getFoundHotelsFromApi(query: queries)
        }
        
        /*
         -------------------------
         MARK: Show Search Results
         -------------------------
         */
        
        var showSearchResults: AnyView {
            
            // Global array foundCountriesList is given in CountryApiData.swift
            if foundHotelsList.isEmpty {
                return AnyView(
                    NotFound(message: "No Hotels Found!\n\nThe entered queries did not return any hotels from the API! Please enter other search queries.")
                )
            }
            
            // Fix
            return AnyView(HotelSearchResultsList())
            
        }
        
        /*
         ---------------------------
         MARK: Input Data Validation
         ---------------------------
         */
        func inputDataValidated() -> Bool {
            
            return true
        }
        
    }

