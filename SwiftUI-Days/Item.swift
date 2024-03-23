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
    var details: String
    var timestamp: Date
    
    init(title: String, details: String = "", timestamp: Date = .now) {
        self.title = title
        self.details = details
        self.timestamp = timestamp
    }
    
    /// Количество дней с момента события
    var daysCount: Int {
        Calendar.current.dateComponents(
            [.day],
            from: timestamp,
            to: .now
        ).day ?? 0
    }
}

extension Item {
    static func predicate(searchText: String) -> Predicate<Item> {
        #Predicate { item in
            searchText.isEmpty
            || item.title.contains(searchText)
            || item.details.contains(searchText)
        }
    }
}
