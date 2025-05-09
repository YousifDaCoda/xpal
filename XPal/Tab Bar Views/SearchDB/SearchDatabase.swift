//
//  SearchDatabase.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/21/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

// Global Search Parameters
var searchCategory = ""
var searchQuery = ""
var selectedRating = -1.1

struct SearchDatabase: View {
    
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    
    
    let searchCategories = ["Name", "Location", "Overview"]
    
    
    @State private var selectedCategoryIndex = 0
    @State private var selectedRatingIndex = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("SearchDatabase")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
                Section(header: Text("Select Search Category")) {
                    Picker("", selection: $selectedCategoryIndex) {
                        ForEach(0 ..< searchCategories.count, id: \.self) {
                            Text(searchCategories[$0])
                        }
                    }
                }
                Section(header: Text("Search \(searchCategories[selectedCategoryIndex])")) {
                    HStack {
                        TextField("Enter Search Query", text: $searchFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        
                        // Button to clear the text field
                        Button(action: {
                            searchFieldValue = ""
                            searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Search Database")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchDB()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                    }
                }
                if searchCompleted {
                    Section(header: Text("List Trips Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundStyle(.blue)
                                Text("List Trips Found")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
                if selectedCategoryIndex == 6 && searchCompleted == true{
                    
                    Section(){
                        HStack{
                            Spacer()
                            Button(action: {
                                searchCompleted = false
                                selectedRating = -1.1
                            }) {
                                Text("Clear")
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            Spacer()
                        }
                        
                    }
                }
                
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Search Database")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
            
        }   // End of NavigationStack
    }   // End of body var
    
    /*
     ---------------------
     MARK: Search Database
     ---------------------
     */
    func searchDB() {
        
        searchCategory = searchCategories[selectedCategoryIndex]
        
        // Public function conductDatabaseSearch is given in DatabaseSearch.swift
        conductDatabaseSearch()
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        
        // Global array databaseSearchResults is given in DatabaseSearch.swift
        if databaseSearchResults.isEmpty {
            return AnyView(
                NotFound(message: "Database Search Produced No Results!\n\nThe database did not return any value for the given search query!")
            )
        }
        
        return AnyView(DBSearchResultsList())
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {

        switch selectedCategoryIndex {
        case 0,1,2:
            // Remove spaces, if any, at the beginning and at the end of the entered search query string
            let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if (queryTrimmed.isEmpty) {
                alertTitle = "Empty Query"
                alertMessage = "Please enter a search query!"
                return false
            }
            searchQuery = queryTrimmed
            
        default:
            print("Selected Index is out of range")
        }
        
        return true
    }
    
}


#Preview {
    SearchDatabase()
}
