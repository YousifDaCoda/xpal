//
//  DatabaseSearch.swift
//  TravelAid
//
//  Created by Ryan Pini & Osman Balci on 4/21/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

// Global variable to hold database search results
var databaseSearchResults = [Trip]()

public func conductDatabaseSearch() {
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer
    
    do {
        // Create a database container to manage Country objects
        modelContainer = try ModelContainer(for: Language.self, Trip.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context (workspace) where database objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    // Initialize the global variable to hold the database search results
    databaseSearchResults = [Trip]()
    
    // Declare searchPredicate as a local variable
    var searchPredicate: Predicate<Trip>?
    
    //-------------------------------------------
    // 1️⃣ Define the Search Criterion (Predicate)
    //-------------------------------------------
    
    switch searchCategory {
    case "Name":
        searchPredicate = #Predicate<Trip> {
            $0.name.localizedStandardContains(searchQuery)
        }

    case "Location":
        searchPredicate = #Predicate<Trip> {
            $0.location.localizedStandardContains(searchQuery)
        }

    case "Overview":
        searchPredicate = #Predicate<Trip> {
            $0.tripDescription.localizedStandardContains(searchQuery)
        }
    default:
        fatalError("Search category is out of range!")
    }
    
    //-------------------------------
    // 2️⃣ Define the Fetch Descriptor
    //-------------------------------
    
    let fetchDescriptor = FetchDescriptor<Trip>(
        predicate: searchPredicate,
        sortBy: [SortDescriptor(\Trip.name, order: .forward)]
    )
    
    //-----------------------------
    // 3️⃣ Execute the Fetch Request
    //-----------------------------
    
    do {
        databaseSearchResults = try modelContext.fetch(fetchDescriptor)
    } catch {
        fatalError("Unable to fetch data from the database!")
    }
    
    //-------------------------------
    // Reset Global Search Parameters
    //-------------------------------
    searchCategory = ""
    searchQuery = ""
    selectedRating = -1.0
    
}

