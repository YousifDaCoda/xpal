//
//  LanguageDetails.swift
//  XPal
//
//  Created by gunnar on 4/29/25.
//

import SwiftUI
import Charts

struct LanguageDetails: View {
    @Bindable var language: Language

    var labeledAttempts: [LabeledAttempt] {
        let all = (language.quizAttempts ?? [])
            .sorted(by: { $0.date > $1.date })
            .prefix(7)
            .reversed()

        return all.enumerated().map { index, attempt in
            LabeledAttempt(label: "Attempt \(index + 1)", score: attempt.score)
        }
    }
    
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
                
                Section(header: Text("Recent Quiz Performance")) {
                    if labeledAttempts.isEmpty {
                        Text("No quiz attempts yet.")
                            .foregroundColor(.secondary)
                    } else {
                        Chart(labeledAttempts) { attempt in
                            BarMark(
                                x: .value("Attempt", attempt.label),
                                y: .value("Score", attempt.score)
                            )
                            .foregroundStyle(Color.blue)
                            
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                        .chartXAxis {
                            AxisMarks(values: labeledAttempts.map { $0.label })
                        }
                        .chartYScale(domain: 0...100)
                        .frame(height: 250)

                    }
                }
                
                
        })

        .font(.system(size: 14))
        .navigationTitle("Back")
        .toolbarTitleDisplayMode(.inline)
    }

}
