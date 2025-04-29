//
//  LanguageQuizHighScore.swift
//  XPal
//
//  Created by gunnar on 4/29/25.
//

import SwiftUI

struct LanguageQuizHighScore: View {
    let language: Language

    var body: some View {
        VStack {
            Text("Current \(language.name) highscore:")
            Text("\(getHighScore(language: language.name))%")
        }
    }
}


func getHighScore(language: String) -> String {
    switch language.lowercased() {
    case "english":
        return englishHighScore["english"] ?? "0.0"
    case "arabic":
        return arabicHighScore["arabic"] ?? "0.0"
    case "french":
        return frenchHighScore["french"] ?? "0.0"
    case "russian":
        return russianHighScore["russian"] ?? "0.0"
    case "chinese":
        return chineseHighScore["chinese"] ?? "0.0"
    case "spanish":
        return spanishHighScore["spanish"] ?? "0.0"
    default:
        return "0.0"
        
    }
}

