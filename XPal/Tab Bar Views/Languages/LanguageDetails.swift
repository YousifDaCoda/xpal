//
//  LanguageDetails.swift
//  XPal
//
//  Created by gunnar on 4/29/25.
//

import SwiftUI

struct LanguageDetails: View {
    let language: Language
    
    var body: some View {
        
       
        
        return AnyView(
            Form{
            
                Section(header: Text("Language Name")){
                    
                    Text(language.name)
                }
                Section(header: Text("Origin Country")){
                    
                    Text(language.originCountry)
                }
                Section(header: Text("Countries Spoken In")){
                    
                    Text("\(language.countriesSpoken)")
                }
                Section(header: Text("Take Quiz")){
                    
                    NavigationLink(destination: LanguageQuiz(language: language)){
                        HStack{
                            
                            Text("\(language.name) quiz")
                                .foregroundStyle(.blue)
                        }
                    }
                }
                
                Section(header: Text("Quiz High Score")){
                    
                    NavigationLink(destination: LanguageQuizHighScore(language: language)){
                        HStack{
                            
                            Text("\(language.name) quiz high score")
                                .foregroundStyle(.blue)
                        }
                    }
                }
                
                
        })

        .font(.system(size: 14))
        .navigationTitle("Back")
        .toolbarTitleDisplayMode(.inline)
    }

}
