/*
**********************************************************
*   Statement of Compliance with the Stated Honor Code   *
**********************************************************
I hereby declare on my honor and I affirm that
 
 (1) I have not given or received any unauthorized help on this assignment, and
 (2) All work is my own in this assignment.
 
I am hereby writing my name as my signature to declare that the above statements are true:
   
      Ravon Kahleik Henson
 
**********************************************************
 */

import SwiftUI
import SwiftData

@main
struct XPalApp: App {
    
    @Environment(\.modelContext) var modelContext
    
    init() {
        //createTripsDatabase()
    }
    
    @AppStorage("darkMode") private var darkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
    }
}
