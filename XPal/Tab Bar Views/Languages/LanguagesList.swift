//
//  LanguagesList.swift
//  XPal
//
//  Created by gunnar on 4/29/25.
//


import SwiftUI
import SwiftData

struct LanguagesList: View {
    
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Language>(sortBy: [SortDescriptor(\Language.name, order: .forward)])) private var listOfAllLanguagesInDatabase: [Language]
       
    var body: some View {
        NavigationStack {
            List {
                // Search Bar: 2 of 4 --> Use filteredListOfVideos
                ForEach(listOfAllLanguagesInDatabase) { aLanguage in
                    NavigationLink(destination: LanguageDetails(language: aLanguage)) {
                        LanguageItem(language: aLanguage)
                    }   // End of NavigationLink
                }   // End of ForEach
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("List of Languages")
            .toolbarTitleDisplayMode(.inline)
           
            
        }   // End of NavigationStack
    }
    
   
}

