//
//  ContentView.swift
//  XPal
//
//  Created by Yousif Abuhaija on 4/24/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            MainView()
        } else {
            ZStack {
                Color.blue.edgesIgnoringSafeArea(.all)
                
                // Title at the top
                VStack {
                    Text("XPal")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    Spacer()
                }
                
                // Background clouds moving from right to left
                VStack {
                    Spacer()
                    ZStack {
                        ForEach(0..<6, id: \.self) { index in
                            CloudView(startingOffset: CGFloat(index * 250))
                        }
                        
                        // Stationary plane
                        Image(systemName: "airplane")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 90, height: 90)
                            .foregroundColor(.white)
                            .offset(y: 0)
                    }
                    .padding(.bottom, 50) // Pushes the whole animation up a bit
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
struct CloudView: View {
    @State private var offsetX: CGFloat
    let startingOffset: CGFloat
    
    init(startingOffset: CGFloat) {
        self.startingOffset = startingOffset
        self._offsetX = State(initialValue: startingOffset)
    }
    
    var body: some View {
        Image(systemName: "cloud.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 120)
            .foregroundColor(.white)
            .offset(x: offsetX, y: CGFloat.random(in: -150...150))
            .onAppear {
                withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
                    offsetX = -UIScreen.main.bounds.width - 200
                }
            }
    }
}

struct MainView: View {
    var body: some View {
        TabView {
            
            Tab("Home", systemImage: "house") {
                Home()
            }
            
            Tab("Trips", systemImage: "airplane") {
                TripsList()
            }
            
            Tab("Translate", systemImage: "globe") {
                Translate()
            }
            
            Tab("Languages", systemImage: "book.circle.fill") {
                LanguagesList()
            }
            
            Tab("Settings", systemImage: "gear") {
                Settings()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}
