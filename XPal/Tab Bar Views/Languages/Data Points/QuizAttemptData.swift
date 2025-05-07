//
//  QuizAttemptData.swift
//  XPal
//
//  Created by gunnar on 5/7/25.
//

import Foundation

struct LabeledAttempt: Identifiable {
    let id = UUID()
    let label: String
    let score: Double
}
