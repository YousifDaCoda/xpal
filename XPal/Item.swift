//
//  Item.swift
//  XPal
//
//  Created by Yousif Abuhaija on 4/24/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
