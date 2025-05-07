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

            ForEach([question.choice1, question.choice2, question.choice3, question.choice4], id: \.self) { choice in
                Button(action: {
                    answerSelected(choice)
                }) {
                    Text(choice)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}
