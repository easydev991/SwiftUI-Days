//
//  Item.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var title: String
    var details: String?
    var timestamp: Date
    
    init(title: String, details: String? = nil, timestamp: Date) {
        self.title = title
        self.details = details
        self.timestamp = timestamp
    }
}
