import Foundation
@testable import SwiftUI_Days
import Testing

@Suite("BackupImporter tests")
struct BackupImporterTests {
    // MARK: - iOS Format Tests

    @Test("iOS backup with explicit format field")
    func iosBackupWithFormatField() throws {
        let json = try #require("""
        {
            "format": "ios",
            "items": [
                {
                    "title": "Test Event",
                    "details": "Details",
                    "timestamp": 766530000,
                    "displayOption": "day"
                }
            ]
        }
        """.data(using: .utf8))

        let importer = try BackupImporter(data: json)

        #expect(importer.format == .ios)
        #expect(importer.items.count == 1)

        let item = try #require(importer.items.first)
        #expect(item.title == "Test Event")

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: item.timestamp)
        #expect(components.year == 2025)
        #expect(components.month == 4)
        #expect(components.day == 17)
    }

    @Test("iOS backup without format field defaults to iOS")
    func iosBackupWithoutFormatField() throws {
        let json = try #require("""
        {
            "items": [
                {
                    "title": "Test Event",
                    "details": "Details",
                    "timestamp": 766530000,
                    "displayOption": "day"
                }
            ]
        }
        """.data(using: .utf8))

        let importer = try BackupImporter(data: json)

        #expect(importer.format == .ios)

        let item = try #require(importer.items.first)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: item.timestamp)
        #expect(components.year == 2025)
    }

    @Test("iOS timestamp before 2001 (negative seconds)")
    func iosTimestampBefore2001() throws {
        let json = try #require("""
        {
            "format": "ios",
            "items": [
                {
                    "title": "Victory Day",
                    "details": "9 May 1945",
                    "timestamp": -1756176000,
                    "displayOption": "day"
                }
            ]
        }
        """.data(using: .utf8))

        let importer = try BackupImporter(data: json)
        let item = try #require(importer.items.first)

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: item.timestamp)
        #expect(components.year == 1945)
        #expect(components.month == 5)
        #expect(components.day == 9)
    }

    // MARK: - Android Format Tests

    @Test("Android backup with format field")
    func androidBackupWithFormatField() throws {
        let json = try #require("""
        {
            "format": "android",
            "items": [
                {
                    "title": "Android Event",
                    "details": "From Android",
                    "timestamp": 699417600000,
                    "colorTag": "#FF5722",
                    "displayOption": "day"
                }
            ]
        }
        """.data(using: .utf8))

        let importer = try BackupImporter(data: json)

        #expect(importer.format == .android)
        #expect(importer.items.count == 1)

        let item = try #require(importer.items.first)
        #expect(item.title == "Android Event")
        #expect(item.colorTag != nil)

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: item.timestamp)
        #expect(components.year == 1992)
        #expect(components.month == 3)
        #expect(components.day == 1)
    }

    @Test("Android negative milliseconds (dates before 1970)")
    func androidNegativeMilliseconds() throws {
        let json = try #require("""
        {
            "format": "android",
            "items": [
                {
                    "title": "Victory Day",
                    "details": "9 May 1945",
                    "timestamp": -777868800000,
                    "displayOption": "day"
                }
            ]
        }
        """.data(using: .utf8))

        let importer = try BackupImporter(data: json)
        let item = try #require(importer.items.first)

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: item.timestamp)
        #expect(components.year == 1945)
        #expect(components.month == 5)
        #expect(components.day == 9)
    }

    // MARK: - Legacy Format Tests

    @Test("Legacy backup as JSON array (no wrapper)")
    func legacyBackupAsJsonArray() throws {
        let json = try #require("""
        [
            {
                "title": "Legacy Array Event",
                "details": "",
                "timestamp": 766530000,
                "displayOption": "day"
            }
        ]
        """.data(using: .utf8))

        let importer = try BackupImporter(data: json)

        #expect(importer.format == .ios)
        #expect(importer.items.count == 1)

        let item = try #require(importer.items.first)
        #expect(item.title == "Legacy Array Event")

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: item.timestamp)
        #expect(components.year == 2025)
    }

    // MARK: - Error Handling Tests

    @Test("Invalid format value throws error")
    func invalidFormatValue_throwsError() throws {
        let json = try #require("""
        {
            "format": "unknown",
            "items": []
        }
        """.data(using: .utf8))

        #expect(throws: (any Error).self) {
            _ = try BackupImporter(data: json)
        }
    }

    @Test("Invalid JSON throws error")
    func invalidJson_throwsError() throws {
        let json = try #require("not a valid json".data(using: .utf8))

        #expect(throws: (any Error).self) {
            _ = try BackupImporter(data: json)
        }
    }

    // MARK: - Android Nullable Fields Tests

    @Test("Android format with null details falls back to empty string")
    func androidDetailsNull_fallbackToEmptyString() throws {
        let json = try #require("""
        {
            "format": "android",
            "items": [
                {
                    "title": "Event without details",
                    "details": null,
                    "timestamp": 699417600000,
                    "displayOption": "day"
                }
            ]
        }
        """.data(using: .utf8))

        let importer = try BackupImporter(data: json)
        let item = try #require(importer.items.first)

        #expect(item.details == "")
    }

    // MARK: - Integration Tests

    @Test("Import real Android backup file")
    func importRealAndroidBackupFile() throws {
        let json = try #require("""
        {
            "format": "android",
            "items": [
                {
                    "title": "День рождения",
                    "details": "Мой день рождения",
                    "timestamp": 699417600000,
                    "colorTag": "#FF5722",
                    "displayOption": "day"
                },
                {
                    "title": "Новый год 2025",
                    "details": "Празднование Нового года",
                    "timestamp": 1735689600000,
                    "colorTag": "#4CAF50",
                    "displayOption": "monthDay"
                },
                {
                    "title": "День победы",
                    "details": "9 мая 1945 года",
                    "timestamp": -777868800000,
                    "colorTag": "#2196F3",
                    "displayOption": "yearMonthDay"
                },
                {
                    "title": "Встреча с друзьями",
                    "details": "",
                    "timestamp": 1704067200000,
                    "colorTag": "#9C27B0",
                    "displayOption": "day"
                },
                {
                    "title": "Без цвета",
                    "details": "Событие без цветового тега",
                    "timestamp": 1609459200000,
                    "colorTag": null,
                    "displayOption": "day"
                },
                {
                    "title": "Без описания",
                    "details": null,
                    "timestamp": 1500000000000,
                    "colorTag": "#F44336",
                    "displayOption": "day"
                },
                {
                    "title": "Синий",
                    "details": "Тест синего цвета",
                    "timestamp": 1400000000000,
                    "colorTag": "#2196F3",
                    "displayOption": "day"
                },
                {
                    "title": "Зелёный",
                    "details": "Тест зелёного цвета",
                    "timestamp": 1300000000000,
                    "colorTag": "#4CAF50",
                    "displayOption": "day"
                }
            ]
        }
        """.data(using: .utf8))

        let importer = try BackupImporter(data: json)

        #expect(importer.format == .android)
        #expect(importer.items.count == 8)

        let item = try #require(importer.items.first)
        #expect(item.title == "День рождения")
        #expect(item.details == "Мой день рождения")

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: item.timestamp)
        #expect(components.year == 1992)
        #expect(components.month == 3)
        #expect(components.day == 1)
    }
}
