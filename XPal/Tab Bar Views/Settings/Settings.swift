//
//  Settings.swift
//  XPal
//
//  Created by Ravon Henson on 5/8/25.
//

import SwiftUI

struct Settings: View {
    @AppStorage("darkMode") private var darkMode = false;
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dark Mode Setting")) {
                    Toggle("Dark Mode", isOn: $darkMode)
                }
                .navigationTitle("Settings")
            }
        }
    }
}
