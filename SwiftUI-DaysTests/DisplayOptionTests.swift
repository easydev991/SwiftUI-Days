import Foundation
import SwiftUI
@testable import SwiftUI_Days
import Testing

@Suite("DisplayOption tests")
struct DisplayOptionTests {
    @Test("allowedUnits: проверка корректных единиц для каждого DisplayOption")
    func displayOptionAllowedUnits() {
        #expect(DisplayOption.day.allowedUnits == [.day])
        #expect(DisplayOption.monthDay.allowedUnits == [.month, .day])
        #expect(DisplayOption.yearMonthDay.allowedUnits == [.year, .month, .day])
    }

    @Test("localizedTitle: проверка локализованных заголовков")
    func displayOptionLocalizedTitle() {
        let dayTitle = DisplayOption.day.localizedTitle
        let monthDayTitle = DisplayOption.monthDay.localizedTitle
        let yearMonthDayTitle = DisplayOption.yearMonthDay.localizedTitle
        #expect(dayTitle == LocalizedStringKey("Days only"))
        #expect(monthDayTitle == LocalizedStringKey("Months and days"))
        #expect(yearMonthDayTitle == LocalizedStringKey("Years, months and days"))
    }

    @Test(".day: вне зависимости от значений всегда .full", arguments: allCombos)
    func unitsStyle_day_alwaysFull(years: Int, months: Int, days: Int) {
        let style = DisplayOption.day.unitsStyle(years: years, months: months, days: days)
        #expect(style == .full)
    }

    @Test(".monthDay: .short, если есть месяцы и дни одновременно", arguments: monthDayShortCombos)
    func unitsStyle_monthDay_short_whenMonthsAndDays(years: Int, months: Int, days: Int) {
        let style = DisplayOption.monthDay.unitsStyle(years: years, months: months, days: days)
        #expect(style == .short)
    }

    @Test(".monthDay: .full в остальных случаях", arguments: monthDayFullCombos)
    func unitsStyle_monthDay_full_otherwise(years: Int, months: Int, days: Int) {
        let style = DisplayOption.monthDay.unitsStyle(years: years, months: months, days: days)
        #expect(style == .full)
    }

    @Test(".yearMonthDay: .abbreviated когда все три значения", arguments: ymdAbbreviatedCombos)
    func unitsStyle_yearMonthDay_abbreviated_whenAll(years: Int, months: Int, days: Int) {
        let style = DisplayOption.yearMonthDay.unitsStyle(years: years, months: months, days: days)
        #expect(style == .abbreviated)
    }

    @Test(".yearMonthDay: .short когда два значения", arguments: ymdShortCombos)
    func unitsStyle_yearMonthDay_short_whenTwo(years: Int, months: Int, days: Int) {
        let style = DisplayOption.yearMonthDay.unitsStyle(years: years, months: months, days: days)
        #expect(style == .short)
    }

    @Test(".yearMonthDay: .full когда ноль или одно значение", arguments: ymdFullCombos)
    func unitsStyle_yearMonthDay_full_whenZeroOrOne(years: Int, months: Int, days: Int) {
        let style = DisplayOption.yearMonthDay.unitsStyle(years: years, months: months, days: days)
        #expect(style == .full)
    }

    // MARK: - Параметры для тестов

    /// Набор общих комбо для проверки .day (всегда .full)
    static let allCombos: [(years: Int, months: Int, days: Int)] = [
        (0, 0, 0), (1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0), (1, 0, 1), (0, 1, 1), (1, 1, 1),
        (-1, 0, 0), (0, -1, 0), (0, 0, -1), (-1, -1, 0), (-1, 0, -1), (0, -1, -1), (-1, -1, -1),
    ]

    /// Для .monthDay -> .short, когда одновременно есть месяцы и дни (годы не важны)
    static let monthDayShortCombos: [(years: Int, months: Int, days: Int)] = [
        (0, 1, 1), (1, 1, 1), (-1, 1, 1), (1, -1, 1), (1, 1, -1),
    ]

    /// Для .monthDay -> .full в остальных случаях (нет одновременных месяцев и дней)
    static let monthDayFullCombos: [(years: Int, months: Int, days: Int)] = [
        (0, 0, 0), (1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 0, 1), (-1, 1, 0), (1, 0, 0),
    ]

    /// Для .yearMonthDay
    static let ymdAbbreviatedCombos: [(years: Int, months: Int, days: Int)] = [
        (1, 1, 1), (-1, 1, 1), (1, -1, 1), (1, 1, -1), (-1, -1, -1),
    ]

    static let ymdShortCombos: [(years: Int, months: Int, days: Int)] = [
        (1, 1, 0), (1, 0, 1), (0, 1, 1), (-1, 1, 0), (1, -1, 0), (1, 0, -1), (0, -1, 1),
    ]

    static let ymdFullCombos: [(years: Int, months: Int, days: Int)] = [
        (1, 0, 0), (0, 1, 0), (0, 0, 1), (0, 0, 0), (-1, 0, 0), (0, -1, 0), (0, 0, -1),
    ]
}
