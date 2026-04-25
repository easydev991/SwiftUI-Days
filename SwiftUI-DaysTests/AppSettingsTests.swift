import Foundation
@testable import SwiftUI_Days
import Testing

@Suite("Тесты AppSettings")
struct AppSettingsTests {
    @Test("Сохраняет фильтр colorTag в defaults")
    func saveMainScreenColorTagFilter() throws {
        let (defaults, domainName) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: domainName) }

        let settings = AppSettings(defaults: defaults)
        settings.mainScreenColorTagFilterHex = "#11223344"

        #expect(
            defaults.string(forKey: DefaultsKey.mainScreenColorTagFilterHex.rawValue) == "#11223344"
        )
        #expect(settings.mainScreenColorTagFilterHex == "#11223344")
    }

    @Test("Сбрасывает фильтр colorTag в nil")
    func resetMainScreenColorTagFilterToNil() throws {
        let (defaults, domainName) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: domainName) }

        let settings = AppSettings(defaults: defaults)
        settings.mainScreenColorTagFilterHex = "#AABBCCDD"
        settings.mainScreenColorTagFilterHex = nil

        #expect(settings.mainScreenColorTagFilterHex == nil)
        #expect(defaults.object(forKey: DefaultsKey.mainScreenColorTagFilterHex.rawValue) == nil)
    }

    @Test("Восстанавливает фильтр colorTag после повторной инициализации")
    func restoreMainScreenColorTagFilterAfterReinit() throws {
        let (defaults, domainName) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: domainName) }

        var settings = AppSettings(defaults: defaults)
        settings.mainScreenColorTagFilterHex = "#123456FF"

        settings = AppSettings(defaults: defaults)

        #expect(settings.mainScreenColorTagFilterHex == "#123456FF")
    }

    @Test("Не влияет на существующие настройки")
    func doesNotBreakExistingSettings() throws {
        let (defaults, domainName) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: domainName) }

        let settings = AppSettings(defaults: defaults)
        settings.appTheme = .dark
        settings.blurWhenMinimized = true
        settings.mainScreenColorTagFilterHex = "#00112233"

        #expect(settings.appTheme == .dark)
        #expect(settings.blurWhenMinimized)
    }
}

private extension AppSettingsTests {
    func makeDefaults() throws -> (defaults: UserDefaults, domainName: String) {
        let domainName = "AppSettingsTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: domainName))
        defaults.removePersistentDomain(forName: domainName)
        return (defaults, domainName)
    }
}
