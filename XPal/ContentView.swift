//
//  ContentView.swift
//  XPal
//
//  Created by Yousif Abuhaija on 4/24/25.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        Text("Empty View")
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            
            Tab("Home", systemImage: "house") {
                EmptyView()
            }
            
            Tab("Trips", systemImage: "list.bullet") {
                TripsList()
            }
            
            Tab("Translate", systemImage: "mappin.and.ellipse") {
                EmptyView()
            }
            
            Tab("Languages", systemImage: "magnifyingglass") {
                LanguagesList()
            }
            
            Tab("Search API", systemImage: "cloud.sun.rain") {
                EmptyView()
            }
            
            Tab("Search DB", systemImage: "cloud.sun.rain") {
                EmptyView()
            }
            
            Tab("Photos", systemImage: "cloud.sun.rain") {
                EmptyView()
            }
            
            Tab("Weather", systemImage: "cloud.sun.rain") {
                EmptyView()
            }
            
            Tab("Puzzle", systemImage: "cloud.sun.rain") {
                EmptyView()
            }
            
            Tab("Settings", systemImage: "gear") {
                EmptyView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}
