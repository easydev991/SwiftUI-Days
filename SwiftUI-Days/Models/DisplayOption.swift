//
//  DisplayOption.swift
//  SwiftUI-Days
//
//  Created by Еременко Олег Николаевич on 17.08.2025.
//

import Foundation
import SwiftUI

/// Вариант отображения количества дней до события
enum DisplayOption: String, Codable, CaseIterable, Hashable {
    case day
    case monthDay
    case yearMonthDay

    var unitsStyle: DateComponentsFormatter.UnitsStyle {
        switch self {
        case .day: .full
        case .monthDay: .short
        case .yearMonthDay: .abbreviated
        }
    }

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
