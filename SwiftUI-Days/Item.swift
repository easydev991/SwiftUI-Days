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
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
