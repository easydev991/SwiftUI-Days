//
//  Item.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Item {
    private static let calendar = Calendar.current
    var title = ""
    var details = ""
    var timestamp = Date.now
    var colorTagData: Data?

    init(title: String, details: String = "", timestamp: Date, colorTag: Color? = nil) {
        self.title = title
        self.details = details
        self.timestamp = timestamp
        colorTagData = colorTag.flatMap { color in
            try? NSKeyedArchiver.archivedData(
                withRootObject: UIColor(color),
                requiringSecureCoding: false
            )
        }
    }

    /// Количество дней с момента события
    func makeDaysCount(to date: Date) -> Int {
        let startDate = Self.calendar.startOfDay(for: timestamp)
        let endDate = Self.calendar.startOfDay(for: date)
        let daysCount = Self.calendar.dateComponents([.day], from: startDate, to: endDate).day
        return daysCount ?? 0
    }

    var colorTag: Color? {
        get {
            guard let colorTagData,
                  let uiColor = try? NSKeyedUnarchiver.unarchivedObject(
                    ofClass: UIColor.self,
                    from: colorTagData
                  )
            else { return nil }
            return Color(uiColor: uiColor)
        }
        set {
            colorTagData = newValue.flatMap { color in
                try? NSKeyedArchiver.archivedData(
                    withRootObject: UIColor(color),
                    requiringSecureCoding: false
                )
            }
        }
    }

    var backupItem: BackupFileDocument.BackupItem {
        .init(
            title: title,
            details: details,
            timestamp: timestamp,
            colorTag: colorTag
        )
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
