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
    var title = ""
    var details = ""
    var timestamp = Date.now

    init(title: String, details: String = "", timestamp: Date) {
        self.title = title
        self.details = details
        self.timestamp = timestamp
    }

    /// Количество дней с момента события
    func makeDaysCount(to date: Date) -> Int {
        Calendar.current.dateComponents(
            [.day],
            from: timestamp,
            to: date
        ).day ?? 0
    }
    
    var backupItem: BackupFileDocument.BackupItem {
        .init(title: title, details: details, timestamp: timestamp)
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
