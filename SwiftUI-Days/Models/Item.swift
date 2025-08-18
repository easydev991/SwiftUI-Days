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
    var displayOption: DisplayOption?

    init(
        title: String,
        details: String = "",
        timestamp: Date,
        colorTag: Color? = nil,
        displayOption: DisplayOption? = .day
    ) {
        self.title = title
        self.details = details
        self.timestamp = timestamp
        self.displayOption = displayOption
        colorTagData = colorTag.flatMap { color in
            try? NSKeyedArchiver.archivedData(
                withRootObject: UIColor(color),
                requiringSecureCoding: false
            )
        }
    }

    /// Количество дней с момента события
    func makeDaysCount(to date: Date) -> String {
        let startDate = Self.calendar.startOfDay(for: timestamp)
        let endDate = Self.calendar.startOfDay(for: date)
        let components = Self.calendar.dateComponents([.year, .month, .day], from: startDate, to: endDate)
        let yearsCount = components.year ?? 0
        let monthsCount = components.month ?? 0
        let daysCount = components.day ?? 0
        let todayString = NSLocalizedString("Today", comment: "Today")
        guard yearsCount != 0 || monthsCount != 0 || daysCount != 0 else {
            return todayString
        }
        let formatter = DateComponentsFormatter()
        let option = displayOption ?? .day
        formatter.allowedUnits = option.allowedUnits
        formatter.unitsStyle = option.unitsStyle(
            years: yearsCount,
            months: monthsCount,
            days: daysCount
        )
        return formatter.string(from: startDate, to: endDate) ?? todayString
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
            colorTag: colorTag,
            displayOption: displayOption
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
