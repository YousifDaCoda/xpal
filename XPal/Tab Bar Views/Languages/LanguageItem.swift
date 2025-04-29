//
//  LanguageItem.swift
//  XPal
//
//  Created by gunnar on 4/29/25.
//

import SwiftUI

struct LanguageItem: View {
    let language: Language
    var body: some View {
        VStack(alignment: .leading){
            Text(language.name)
                .font(.system(size: 20))
                .fontWeight(.bold)
            
        }
    }
}
