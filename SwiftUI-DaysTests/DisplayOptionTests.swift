//
//  DisplayOptionTests.swift
//  SwiftUI-DaysTests
//
//  Created by Oleg991 on 17.08.2025.
//

import Foundation
import SwiftUI
@testable import SwiftUI_Days
import Testing

@Suite("DisplayOption tests")
struct DisplayOptionTests {
    @Test func displayOptionUnitsStyle() {
        #expect(DisplayOption.day.unitsStyle == .full)
        #expect(DisplayOption.monthDay.unitsStyle == .short)
        #expect(DisplayOption.yearMonthDay.unitsStyle == .abbreviated)
    }

    @Test func displayOptionAllowedUnits() {
        #expect(DisplayOption.day.allowedUnits == [.day])
        #expect(DisplayOption.monthDay.allowedUnits == [.month, .day])
        #expect(DisplayOption.yearMonthDay.allowedUnits == [.year, .month, .day])
    }
    
    /// Тестируем localizedTitle для каждого случая
    @Test func displayOptionLocalizedTitle() {
        let dayTitle = DisplayOption.day.localizedTitle
        let monthDayTitle = DisplayOption.monthDay.localizedTitle
        let yearMonthDayTitle = DisplayOption.yearMonthDay.localizedTitle
        #expect(dayTitle == LocalizedStringKey("Days only"))
        #expect(monthDayTitle == LocalizedStringKey("Months and days"))
        #expect(yearMonthDayTitle == LocalizedStringKey("Years, months and days"))
    }
}
