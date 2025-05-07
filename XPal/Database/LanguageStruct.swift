//
//  LanguageStruct.swift
//  XPal
//
//  Created by Ryan Pini on 4/1/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import Foundation

struct LanguageStruct: Decodable {
    var name: String
    var originCountry: String
    var countriesSpoken: Int
    var numberOfSpeakers: Int
    var categories: [LanguageCategoryStruct]
    var quizAttempts: [QuizAttemptStruct]?
}

struct LanguageCategoryStruct: Decodable {
    var categoryName: String
    var phrases: [PhraseStruct]
}

struct PhraseStruct: Decodable {
    var english: String
    var translation: String
}

struct QuizAttemptStruct: Decodable {
    var date: Date
    var score: Double
}
