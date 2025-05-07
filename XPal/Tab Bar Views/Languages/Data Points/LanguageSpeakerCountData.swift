//
//  LanguageSpeakerCountData.swift
//  XPal
//
//  Created by gunnar on 5/7/25.
//

import Foundation

struct LanguageSpeakersData: Identifiable {
    var id = UUID()
    var languageName: String
    var numberOfSpeakers: Int
}
