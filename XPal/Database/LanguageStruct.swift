//
//  LanguageStruct.swift
//  XPal
//
//  Created by Ryan Pini on 4/1/25.
//  Copyright © 2025 Ryan Pini. All rights reserved.
//

import Foundation

struct LanguageStruct: Decodable{
    
    var name: String
    var originCountry: String
    var countriesSpoken: Int
    var commonPhrases: [String: String]
}

