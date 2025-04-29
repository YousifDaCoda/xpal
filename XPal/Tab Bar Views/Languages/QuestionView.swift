//
//  QuestionView.swift
//  XPal
//
//  Created by gunnar on 4/29/25.
//

import SwiftUI

struct QuestionView: View {
    let question: Question
    var answerSelected: (String) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(question.question)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                answerSelected(question.choice1)
            }) {
                Text(question.choice1)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                answerSelected(question.choice2)
            }) {
                Text(question.choice2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
