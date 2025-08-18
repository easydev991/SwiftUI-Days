import Foundation
import SwiftUI
@testable import SwiftUI_Days
import Testing

@Suite("DisplayOption tests")
struct DisplayOptionTests {
    @Test func displayOptionAllowedUnits() {
        #expect(DisplayOption.day.allowedUnits == [.day])
        #expect(DisplayOption.monthDay.allowedUnits == [.month, .day])
        #expect(DisplayOption.yearMonthDay.allowedUnits == [.year, .month, .day])
    }

    @Test func displayOptionLocalizedTitle() {
        let dayTitle = DisplayOption.day.localizedTitle
        let monthDayTitle = DisplayOption.monthDay.localizedTitle
        let yearMonthDayTitle = DisplayOption.yearMonthDay.localizedTitle
        #expect(dayTitle == LocalizedStringKey("Days only"))
        #expect(monthDayTitle == LocalizedStringKey("Months and days"))
        #expect(yearMonthDayTitle == LocalizedStringKey("Years, months and days"))
    }

    @Test(arguments: abbreviatedTestCases)
    func makeUnitsStyleAbbreviated(years: Int, months: Int, days: Int) throws {
        let style = DisplayOption.makeUnitsStyle(years: years, months: months, days: days)
        #expect(style == .abbreviated)
    }

    @Test(arguments: shortTestCases)
    func makeUnitsStyleShort(years: Int, months: Int, days: Int) throws {
        let style = DisplayOption.makeUnitsStyle(years: years, months: months, days: days)
        #expect(style == .short)
    }

    @Test(arguments: fullTestCases)
    func makeUnitsStyleFull(years: Int, months: Int, days: Int) throws {
        let style = DisplayOption.makeUnitsStyle(years: years, months: months, days: days)
        #expect(style == .full)
    }

    // MARK: - Параметры для тестов

    /// Все три компонента ненулевые
    static let abbreviatedTestCases: [(years: Int, months: Int, days: Int)] = [
        (1, 1, 1), // положительные значения
        (-1, 1, 1), // отрицательный год
        (1, -1, 1), // отрицательный месяц
        (1, 1, -1), // отрицательный день
        (-1, -1, -1), // все отрицательные
    ]

    /// Два компонента ненулевые
    static let shortTestCases: [(years: Int, months: Int, days: Int)] = [
        (1, 1, 0), // годы и месяцы
        (1, 0, 1), // годы и дни
        (0, 1, 1), // месяцы и дни
        (-1, 1, 0), // отрицательный год и месяц
        (1, -1, 0), // год и отрицательный месяц
        (1, 0, -1), // год и отрицательный день
        (0, -1, 1), // отрицательный месяц и день
    ]

    /// Один или ноль компонентов ненулевые
    static let fullTestCases: [(years: Int, months: Int, days: Int)] = [
        (1, 0, 0), // только годы
        (0, 1, 0), // только месяцы
        (0, 0, 1), // только дни
        (0, 0, 0), // все нули
        (-1, 0, 0), // только отрицательный год
        (0, -1, 0), // только отрицательный месяц
        (0, 0, -1), // только отрицательный день
    ]
}
