//
//  SearchFlights.swift
//  XPal
//
//  Created by Ryan Pini & Osman Balci on 5/5/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI

struct SearchFlights: View {
    
    @State private var departureFieldValue = ""
    @State private var arrivalFieldValue = ""
    @State private var date = Date()
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: "airplane.departure")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Image(systemName: "airplane.arrival")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)

                        Spacer()
                    }
                }
                Section(header: Text("Enter IATA Code for Departure Airport")) {
                    HStack {
                        TextField("Enter Code", text: $departureFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        
                        // Button to clear the text field
                        Button(action: {
                            departureFieldValue = ""
                            showAlertMessage = false
                            searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        
                    }   // End of HStack
                }
                Section(header: Text("Enter IATA Code for Arrival Airport")) {
                    HStack {
                        TextField("Enter Code", text: $arrivalFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        
                        // Button to clear the text field
                        Button(action: {
                            arrivalFieldValue = ""
                            showAlertMessage = false
                            searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        
                    }   // End of HStack
                }
                Section(header: Text("Date")){
                    
                    DatePicker(
                        selection: $date,
                        displayedComponents: .date // Sets DatePicker to pick a date
                    ){
                        Text("Flight Date")
                    }
                }
                Section(header: Text("Search for Flights")) {
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
                    Section(header: Text("Show Flights Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Show Flights Found")
                                    .font(.system(size: 16))
                            }
                        }
                    }
                }
            }
                      // End of Form
                .navigationTitle("Search for Flights")
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
            let formattedDate = dateFormatter.string(from: date)
            let queries = [departureFieldValue.uppercased(), arrivalFieldValue.uppercased(), formattedDate]
            
            
            // Public function getFoundCountriesFromApi is given in CountryApiData.swift
            getFoundFlightsFromApi(query: queries)
        }
        
        /*
         -------------------------
         MARK: Show Search Results
         -------------------------
         */
        
        var showSearchResults: AnyView {
            
            // Global array foundCountriesList is given in CountryApiData.swift
            if foundFlightsList.isEmpty {
                return AnyView(
                    NotFound(message: "No Flights Found!\n\nThe entered queries did not return any flights from the API! Please enter other search queries.")
                )
            }
            
            // Fix
            return AnyView(FlightSearchResultsList())
            
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

