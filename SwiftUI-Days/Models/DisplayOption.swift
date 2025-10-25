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
    var localizedTitle: String {
        switch self {
        case .day: String(localized: .daysOnly)
        case .monthDay: String(localized: .monthsAndDays)
        case .yearMonthDay: String(localized: .yearsMonthsAndDays)
        }
    }
}

extension DisplayOption {
    func unitsStyle(
        years: Int,
        months: Int,
        days: Int
    ) -> DateComponentsFormatter.UnitsStyle {
        switch self {
        case .day:
            return .full
        case .monthDay:
            let hasMonths = months != 0
            let hasDays = days != 0
            return (hasMonths && hasDays) ? .short : .full
        case .yearMonthDay:
            let hasYears = years != 0
            let hasMonths = months != 0
            let hasDays = days != 0
            switch (hasYears, hasMonths, hasDays) {
            case (true, true, true):
                return .abbreviated
            case (true, true, false), (true, false, true), (false, true, true):
                return .short
            default:
                return .full
            }
        }
    }
}
