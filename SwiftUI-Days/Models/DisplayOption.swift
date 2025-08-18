import Foundation
import SwiftUI

/// Вариант отображения количества дней до события
enum DisplayOption: String, Codable, CaseIterable, Hashable {
    case day
    case monthDay
    case yearMonthDay

    var allowedUnits: NSCalendar.Unit {
        switch self {
        case .day: [.day]
        case .monthDay: [.month, .day]
        case .yearMonthDay: [.year, .month, .day]
        }
    }

    /// Локализованное название формата отображения
    var localizedTitle: LocalizedStringKey {
        switch self {
        case .day: "Days only"
        case .monthDay: "Months and days"
        case .yearMonthDay: "Years, months and days"
        }
    }
}

extension DisplayOption {
    static func makeUnitsStyle(
        years: Int,
        months: Int,
        days: Int
    ) -> DateComponentsFormatter.UnitsStyle {
        let hasYears = years != 0
        let hasMonths = months != 0
        let hasDays = days != 0
        return switch (hasYears, hasMonths, hasDays) {
        case (true, true, true): .abbreviated
        case (true, true, false), (true, false, true), (false, true, true): .short
        default: .full
        }
    }
}
