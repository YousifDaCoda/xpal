//
//  LanguageCountryData.swift
//  XPal
//
//  Created by gunnar on 5/7/25.
//

import Foundation

struct LanguageCountryData: Identifiable {
    var id: UUID = UUID()
    var languageName: String
    var countryCount: Int
}
