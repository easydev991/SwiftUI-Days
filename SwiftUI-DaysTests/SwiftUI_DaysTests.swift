//
//  SwiftUI_DaysTests.swift
//  SwiftUI-DaysTests
//
//  Created by Oleg991 on 10.11.2024.
//

import Testing
import Foundation
@testable import SwiftUI_Days

@Suite("Item tests")
struct SwiftUI_DaysTests {
    /// Тестируем инициализацию объекта Item
    @Test func itemInitialization() {
        let title = "Test Title"
        let details = "Test Details"
        let oneDayAgo = Date(timeIntervalSinceNow: -86400)
        let item = Item(title: title, details: details, timestamp: oneDayAgo)
        #expect(item.title == title)
        #expect(item.details == details)
        #expect(item.timestamp == oneDayAgo)
    }

    /// Тестируем `daysCount`, когда событие произошло только что
    @Test func daysCountWithNoDaysPassed() {
        let item = Item(title: "Recent Event", timestamp: .now)
        let result = item.makeDaysCount(to: .now)
        #expect(result == 0)
    }

    /// Тестируем `daysCount` для события, произошедшего 1 день назад
    @Test func daysCountWithOneDayPassed() {
        let oneDayOldItem = Item(
            title: "One Day Ago",
            timestamp: Date(timeIntervalSinceNow: -86400)
        )
        let result = oneDayOldItem.makeDaysCount(to: .now)
        #expect(result == 1)
    }

    /// Тестируем `daysCount` для события, произошедшего 5 дней назад
    @Test func daysCountWithMultipleDaysPassed() {
        let fiveDaysOldItem = Item(
            title: "Five Days Ago",
            timestamp: Date(timeIntervalSinceNow: -432000)
        )
        let result = fiveDaysOldItem.makeDaysCount(to: .now)
        #expect(result == 5)
    }
}
