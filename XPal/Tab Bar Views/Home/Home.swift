//
//  Home.swift
//  XPal
//
//  Created by Ravon Henson on 5/8/25.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Image("Welcome")
                    .padding()
                
                Image("XPalHomeScreen")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    .padding(.horizontal, 10)
                
                Text("XPal - Your go-to stop for your expat needs")
                    .font(.system(size: 14, weight: .light, design: .serif))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                
                Text("Powered by")
                    .font(.system(size: 18, weight: .light, design: .serif))
                    .italic()
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                Link(destination: URL(string: "https://serpapi.com")!) {
                    HStack {
                        Image(systemName: "gear")
                            .imageScale(.large)
                        Text("SerpAPI")
                    }
                }
                
                Link(destination: URL(string: "https://cloud.google.com/apis/docs/overview")!) {
                    HStack {
                        Image(systemName: "cloud")
                            .imageScale(.large)
                        Text("Google Cloud")
                    }
                }

            }
        }
    }
}


