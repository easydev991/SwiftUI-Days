//
//  SwiftUI_DaysTests.swift
//  SwiftUI-DaysTests
//
//  Created by Oleg991 on 10.11.2024.
//

import Foundation
import SwiftUI
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
        #expect(item.colorTag == nil)
        #expect(item.displayOption == .day)
    }

    /// Тестируем инициализацию объекта Item с цветовым тегом
    @Test func itemInitializationWithColorTag() throws {
        let title = "Test Title"
        let details = "Test Details"
        let oneDayAgo = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let colorTag = Color.red
        let item = Item(title: title, details: details, timestamp: oneDayAgo, colorTag: colorTag)
        #expect(item.title == title)
        #expect(item.details == details)
        #expect(item.timestamp == oneDayAgo)
        #expect(item.colorTag != nil)
        #expect(item.displayOption == .day)
    }

    /// Тестируем инициализацию объекта Item с displayOption
    @Test(arguments: DisplayOption.allCases)
    func itemInitializationWithDisplayOption(displayOption: DisplayOption) throws {
        let title = "Test Title"
        let details = "Test Details"
        let oneDayAgo = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let item = Item(title: title, details: details, timestamp: oneDayAgo, displayOption: displayOption)
        #expect(item.title == title)
        #expect(item.details == details)
        #expect(item.timestamp == oneDayAgo)
        #expect(item.colorTag == nil)
        #expect(item.displayOption == displayOption)
    }

    /// Тестируем инициализацию объекта Item с colorTag и displayOption
    @Test(arguments: DisplayOption.allCases)
    func itemInitializationWithColorTagAndDisplayOption(displayOption: DisplayOption) throws {
        let title = "Test Title"
        let details = "Test Details"
        let oneDayAgo = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let colorTag = Color.blue
        let item = Item(title: title, details: details, timestamp: oneDayAgo, colorTag: colorTag, displayOption: displayOption)
        #expect(item.title == title)
        #expect(item.details == details)
        #expect(item.timestamp == oneDayAgo)
        #expect(item.colorTag != nil)
        #expect(item.displayOption == displayOption)
    }

    /// Тестируем backupItem с цветовым тегом
    @Test func backupItemWithColorTag() throws {
        let title = "Test Title"
        let details = "Test Details"
        let oneDayAgo = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let colorTag = Color.blue
        let item = Item(title: title, details: details, timestamp: oneDayAgo, colorTag: colorTag)
        let backupItem = item.backupItem
        #expect(backupItem.title == title)
        #expect(backupItem.details == details)
        #expect(backupItem.timestamp == oneDayAgo)
        #expect(backupItem.colorTag != nil)
    }

    /// Тестируем backupItem без цветового тега
    @Test func backupItemWithoutColorTag() throws {
        let title = "Test Title"
        let details = "Test Details"
        let oneDayAgo = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let item = Item(title: title, details: details, timestamp: oneDayAgo)
        let backupItem = item.backupItem
        #expect(backupItem.title == title)
        #expect(backupItem.details == details)
        #expect(backupItem.timestamp == oneDayAgo)
        #expect(backupItem.colorTag == nil)
        #expect(backupItem.displayOption == .day)
    }

    /// Тестируем backupItem с displayOption
    @Test(arguments: DisplayOption.allCases)
    func backupItemWithDisplayOption(displayOption: DisplayOption) throws {
        let title = "Test Title"
        let details = "Test Details"
        let oneDayAgo = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let item = Item(title: title, details: details, timestamp: oneDayAgo, displayOption: displayOption)
        let backupItem = item.backupItem
        #expect(backupItem.title == title)
        #expect(backupItem.details == details)
        #expect(backupItem.timestamp == oneDayAgo)
        #expect(backupItem.colorTag == nil)
        #expect(backupItem.displayOption == displayOption)
    }

    /// Тестируем backupItem с displayOption и colorTag
    @Test(arguments: DisplayOption.allCases)
    func backupItemWithDisplayOptionAndColorTag(displayOption: DisplayOption) throws {
        let title = "Test Title"
        let details = "Test Details"
        let oneDayAgo = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let colorTag = Color.green
        let item = Item(title: title, details: details, timestamp: oneDayAgo, colorTag: colorTag, displayOption: displayOption)
        let backupItem = item.backupItem
        #expect(backupItem.title == title)
        #expect(backupItem.details == details)
        #expect(backupItem.timestamp == oneDayAgo)
        #expect(backupItem.colorTag != nil)
        #expect(backupItem.displayOption == displayOption)
    }

    /// Тестируем backupItem с nil displayOption
    @Test func backupItemWithNilDisplayOption() throws {
        let title = "Test Title"
        let details = "Test Details"
        let oneDayAgo = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let item = Item(title: title, details: details, timestamp: oneDayAgo, displayOption: nil)
        let backupItem = item.backupItem
        #expect(backupItem.title == title)
        #expect(backupItem.details == details)
        #expect(backupItem.timestamp == oneDayAgo)
        #expect(backupItem.colorTag == nil)
        #expect(backupItem.displayOption == nil)
    }

    /// Тестируем `daysCount` для события, произошедшего 1 день назад
    @Test func daysCountWithOneDayPassed() throws {
        let oneDayAgo = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let oneDayOldItem = Item(
            title: "One Day Ago",
            timestamp: oneDayAgo
        )
        let result = oneDayOldItem.makeDaysCount(to: now)
        #expect(result == "1 день")
    }

    /// Тестируем `daysCount` для события, произошедшего 5 дней назад
    @Test func daysCountWithMultipleDaysPassed() throws {
        let fiveDaysAgo = try #require(calendar.date(byAdding: .day, value: -5, to: now))
        let fiveDaysOldItem = Item(
            title: "Five Days Ago",
            timestamp: fiveDaysAgo
        )
        let result = fiveDaysOldItem.makeDaysCount(to: now)
        #expect(result == "5 дней")
    }

    @Test(arguments: 0 ... 11)
    func daysCountSameDay(hoursAgo: Int) throws {
        let date = try #require(Calendar.current.date(byAdding: .hour, value: -hoursAgo, to: now))
        let item = Item(title: "Recent Event", timestamp: date)
        let result = item.makeDaysCount(to: now)
        #expect(result == "Сегодня", "Должно быть 'Сегодня', так как даты в одном календарном дне")
    }

    @Test(arguments: 12 ... 23)
    func daysCountYesterday(hoursAgo: Int) throws {
        // Создаем событие, которое точно произошло вчера
        let yesterday = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let date = try #require(calendar.date(byAdding: .hour, value: -hoursAgo, to: yesterday))
        let item = Item(title: "Yesterday Event", timestamp: date)
        let result = item.makeDaysCount(to: now)
        let containsPossibleNumber = [1, 2].contains { number in
            result.contains("\(number)")
        }
        #expect(containsPossibleNumber, "Результат должен содержать одно из возможных чисел, т.к. событие произошло либо вчера, либо позавчера")
    }

    @Test func daysCountAcrossMidnight() throws {
        let todayStart = calendar.startOfDay(for: now)
        let justBeforeMidnight = try #require(calendar.date(byAdding: .minute, value: -1, to: todayStart))
        let justAfterMidnight = try #require(calendar.date(byAdding: .minute, value: 1, to: todayStart))
        let item = Item(title: "Late Event", timestamp: justBeforeMidnight)
        let result = item.makeDaysCount(to: justAfterMidnight)
        #expect(result == "1 день", "Должен быть '1 день' при переходе через полночь")
    }

    @Test func daysCountFutureEvent() throws {
        let futureDate = try #require(calendar.date(byAdding: .day, value: 1, to: now))
        let item = Item(title: "Future Event", timestamp: futureDate)
        let result = item.makeDaysCount(to: now)
        #expect(result == "-1 день", "Для будущих событий результат должен быть '-1 день'")
    }
}
