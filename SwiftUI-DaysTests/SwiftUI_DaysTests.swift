//
//  SwiftUI_DaysTests.swift
//  SwiftUI-DaysTests
//
//  Created by Oleg991 on 10.11.2024.
//

import Foundation
@testable import SwiftUI_Days
import Testing

@Suite("Item tests")
struct SwiftUI_DaysTests {
    private let calendar = Calendar.current
    private let now = Date.now

    /// Тестируем инициализацию объекта Item
    @Test func itemInitialization() throws {
        let title = "Test Title"
        let details = "Test Details"
        let oneDayAgo = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let item = Item(title: title, details: details, timestamp: oneDayAgo)
        #expect(item.title == title)
        #expect(item.details == details)
        #expect(item.timestamp == oneDayAgo)
    }

    /// Тестируем `daysCount`, когда событие произошло только что
    @Test func daysCountWithNoDaysPassed() {
        let item = Item(title: "Recent Event", timestamp: now)
        let result = item.makeDaysCount(to: now)
        #expect(result == 0)
    }

    /// Тестируем `daysCount` для события, произошедшего 1 день назад
    @Test func daysCountWithOneDayPassed() throws {
        let oneDayAgo = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let oneDayOldItem = Item(
            title: "One Day Ago",
            timestamp: oneDayAgo
        )
        let result = oneDayOldItem.makeDaysCount(to: now)
        #expect(result == 1)
    }

    /// Тестируем `daysCount` для события, произошедшего 5 дней назад
    @Test func daysCountWithMultipleDaysPassed() throws {
        let fiveDaysAgo = try #require(calendar.date(byAdding: .day, value: -5, to: now))
        let fiveDaysOldItem = Item(
            title: "Five Days Ago",
            timestamp: fiveDaysAgo
        )
        let result = fiveDaysOldItem.makeDaysCount(to: now)
        #expect(result == 5)
    }

    @Test(arguments: 1 ... 11)
    func daysCountSameDay(hoursAgo: Int) throws {
        let date = try #require(Calendar.current.date(byAdding: .hour, value: -hoursAgo, to: now))
        let item = Item(title: "Recent Event", timestamp: date)
        let result = item.makeDaysCount(to: now)
        #expect(result == 0, "Должно быть 0 дней, так как даты в одном календарном дне")
    }

    @Test(arguments: 12 ... 23)
    func daysCountDifferentDay(hoursAgo: Int) throws {
        let date = try #require(Calendar.current.date(byAdding: .hour, value: -hoursAgo, to: now))
        let item = Item(title: "Yesterday Event", timestamp: date)
        let result = item.makeDaysCount(to: now)
        #expect(result == 1, "Должен быть 1 день, так как даты в разных календарных днях")
    }

    @Test func daysCountAcrossMidnight() throws {
        let todayStart = calendar.startOfDay(for: now)
        let justBeforeMidnight = try #require(calendar.date(byAdding: .minute, value: -1, to: todayStart))
        let justAfterMidnight = try #require(calendar.date(byAdding: .minute, value: 1, to: todayStart))
        let item = Item(title: "Late Event", timestamp: justBeforeMidnight)
        let result = item.makeDaysCount(to: justAfterMidnight)
        #expect(result == 1, "Должен быть 1 день при переходе через полночь")
    }

    @Test func daysCountFutureEvent() throws {
        let futureDate = try #require(calendar.date(byAdding: .day, value: 1, to: now))
        let item = Item(title: "Future Event", timestamp: futureDate)
        let result = item.makeDaysCount(to: now)
        #expect(result <= 0, "Для будущих событий результат должен быть 0 или отрицательным")
    }
}
