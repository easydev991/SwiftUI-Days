import Foundation
import SwiftUI
@testable import SwiftUI_Days
import Testing

@Suite("BackupItem decoding tests")
struct BackupItemDecodingTests {
    // MARK: - iOS Format Tests (seconds since 2001)

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

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let rawItem = try #require(wrapper.items.first)

        #expect(rawItem.title == "Test Event")
        #expect(wrapper.format == .ios)

        let parsedDate = rawItem.parsedTimestamp(format: .ios)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: parsedDate)
        #expect(components.year == 2025)
        #expect(components.month == 4)
        #expect(components.day == 17)
    }

    @Test("iOS backup without format field (defaults to iOS)")
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

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let rawItem = try #require(wrapper.items.first)

        #expect(rawItem.title == "Test Event")
        #expect(wrapper.format == nil)

        let parsedDate = rawItem.parsedTimestamp(format: .ios)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: parsedDate)
        #expect(components.year == 2025)
        #expect(components.month == 4)
        #expect(components.day == 17)
    }

    @Test("iOS timestamp after 2001 (positive seconds)")
    func iosTimestampAfter2001() throws {
        let json = try #require("""
        {
            "format": "ios",
            "items": [
                {
                    "title": "Future Event",
                    "details": "",
                    "timestamp": 766530000,
                    "displayOption": "day"
                }
            ]
        }
        """.data(using: .utf8))

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let rawItem = try #require(wrapper.items.first)

        let parsedDate = rawItem.parsedTimestamp(format: .ios)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: parsedDate)
        #expect(components.year == 2025)
        #expect(components.month == 4)
        #expect(components.day == 17)
    }

    @Test("iOS timestamp before 2001 (negative seconds, e.g. 1945)")
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

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let rawItem = try #require(wrapper.items.first)

        let parsedDate = rawItem.parsedTimestamp(format: .ios)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: parsedDate)
        #expect(components.year == 1945)
        #expect(components.month == 5)
        #expect(components.day == 9)
    }

    // MARK: - Android Format Tests (milliseconds since 1970)

    @Test("Android backup with format field - raw wrapper decoding")
    func androidBackupWithFormatField_raw() throws {
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

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let rawItem = try #require(wrapper.items.first)

        #expect(rawItem.title == "Android Event")
        #expect(rawItem.colorTag != nil)
        #expect(wrapper.format == .android)

        let parsedDate = rawItem.parsedTimestamp(format: .android)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: parsedDate)
        #expect(components.year == 1992)
        #expect(components.month == 3)
        #expect(components.day == 1)
    }

    @Test("Android positive milliseconds (dates after 1970)")
    func androidPositiveMilliseconds() throws {
        let json = try #require("""
        {
            "format": "android",
            "items": [
                {
                    "title": "Y2K",
                    "details": "",
                    "timestamp": 946684800000,
                    "displayOption": "day"
                }
            ]
        }
        """.data(using: .utf8))

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let rawItem = try #require(wrapper.items.first)

        let parsedDate = rawItem.parsedTimestamp(format: .android)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: parsedDate)
        #expect(components.year == 2000)
        #expect(components.month == 1)
        #expect(components.day == 1)
    }

    @Test("Android negative milliseconds (dates before 1970, e.g. 9 May 1945)")
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

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let rawItem = try #require(wrapper.items.first)

        let parsedDate = rawItem.parsedTimestamp(format: .android)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: parsedDate)
        #expect(components.year == 1945)
        #expect(components.month == 5)
        #expect(components.day == 9)
    }

    // MARK: - Backward Compatibility Tests

    @Test("Legacy backup without format field in object")
    func legacyBackupWithoutFormat() throws {
        let json = try #require("""
        {
            "items": [
                {
                    "title": "Legacy Event",
                    "details": "",
                    "timestamp": 766530000,
                    "displayOption": "day"
                }
            ]
        }
        """.data(using: .utf8))

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let rawItem = try #require(wrapper.items.first)

        #expect(wrapper.format == nil)

        let parsedDate = rawItem.parsedTimestamp(format: .ios)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: parsedDate)
        #expect(components.year == 2025)
    }

    @Test("Legacy backup as JSON array (no wrapper object)")
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

        let items = try JSONDecoder().decode([BackupFileDocument.BackupItem].self, from: json)
        let item = try #require(items.first)

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: item.timestamp)
        #expect(components.year == 2025)
    }

    @Test("Mixed timestamps in iOS format")
    func mixedTimestampsInIosFormat() throws {
        let json = try #require("""
        {
            "format": "ios",
            "items": [
                {
                    "title": "1945 Event",
                    "details": "",
                    "timestamp": -1756176000,
                    "displayOption": "day"
                },
                {
                    "title": "2025 Event",
                    "details": "",
                    "timestamp": 766530000,
                    "displayOption": "day"
                }
            ]
        }
        """.data(using: .utf8))

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)

        let calendar = Calendar(identifier: .gregorian)

        let parsedDate1 = wrapper.items[0].parsedTimestamp(format: .ios)
        let components1 = calendar.dateComponents([.year], from: parsedDate1)
        #expect(components1.year == 1945)

        let parsedDate2 = wrapper.items[1].parsedTimestamp(format: .ios)
        let components2 = calendar.dateComponents([.year], from: parsedDate2)
        #expect(components2.year == 2025)
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
            _ = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        }
    }

    // MARK: - Export Tests

    @Test("Export creates correct JSON with format field")
    func export_createsCorrectJsonWithFormatField() {
        let item = BackupFileDocument.BackupItem(
            title: "Test",
            details: "Details",
            timestamp: Date(timeIntervalSinceReferenceDate: 766_530_000),
            colorTag: nil,
            displayOption: .day
        )
        let doc = BackupFileDocument(items: [item], format: .ios)

        let wrapper = doc.exportWrapper()
        #expect(wrapper.format == .ios)
        #expect(wrapper.items.count == 1)
        #expect(wrapper.items.first?.title == "Test")
    }

    @Test("Export uses seconds since reference date")
    func export_usesSecondsSinceReferenceDate() {
        let timestamp: Double = 766_530_000
        let item = BackupFileDocument.BackupItem(
            title: "Test",
            details: "",
            timestamp: Date(timeIntervalSinceReferenceDate: timestamp),
            colorTag: nil,
            displayOption: .day
        )
        let doc = BackupFileDocument(items: [item], format: .ios)

        let wrapper = doc.exportWrapper()
        #expect(wrapper.items.first?.timestamp == timestamp)
    }

    // MARK: - Android Format with Hex Color Tests

    @Test("Android format with hex color and milliseconds")
    func decodeAndroidFormatWithHexColorAndMilliseconds() throws {
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
                }
            ]
        }
        """.data(using: .utf8))

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let rawItem = try #require(wrapper.items.first)

        #expect(rawItem.title == "День рождения")
        #expect(rawItem.colorTag != nil)
        #expect(rawItem.displayOption == .day)

        let expectedDate = Date(timeIntervalSince1970: 699_417_600)
        let parsedDate = rawItem.parsedTimestamp(format: .android)
        #expect(parsedDate == expectedDate)
    }

    @Test("Android format with invalid hex returns nil color")
    func decodeAndroidFormatWithInvalidHexReturnsNilColor() throws {
        let json = try #require("""
        {
            "format": "android",
            "items": [
                {
                    "title": "Test",
                    "details": "",
                    "timestamp": 699417600000,
                    "colorTag": "#GGGGGG",
                    "displayOption": "day"
                }
            ]
        }
        """.data(using: .utf8))

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let item = try #require(wrapper.items.first)

        #expect(item.title == "Test")
        #expect(item.colorTag == nil)
    }

    // MARK: - iOS Format with Base64 Color Tests

    @Test("iOS format with Base64 color and seconds")
    func decodeIOSFormatWithBase64ColorAndSeconds() throws {
        let uiColor = UIColor(red: 1.0, green: 0.34, blue: 0.13, alpha: 1.0)
        let colorData = try NSKeyedArchiver.archivedData(
            withRootObject: uiColor,
            requiringSecureCoding: false
        )
        let base64String = colorData.base64EncodedString()

        let json = try #require("""
        {
            "format": "ios",
            "items": [
                {
                    "title": "iOS Event",
                    "details": "Created on iOS",
                    "timestamp": 699417600,
                    "colorTag": "\(base64String)",
                    "displayOption": "monthDay"
                }
            ]
        }
        """.data(using: .utf8))

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let rawItem = try #require(wrapper.items.first)

        #expect(rawItem.title == "iOS Event")
        #expect(rawItem.colorTag != nil)
        #expect(rawItem.displayOption == .monthDay)

        let expectedDate = Date(timeIntervalSinceReferenceDate: 699_417_600)
        let parsedDate = rawItem.parsedTimestamp(format: .ios)
        #expect(parsedDate == expectedDate)
    }

    // MARK: - Edge Cases

    @Test("Decode with nil colorTag")
    func decodeWithNilColorTag() throws {
        let json = try #require("""
        {
            "format": "ios",
            "items": [
                {
                    "title": "No Color",
                    "details": "",
                    "timestamp": 699417600
                }
            ]
        }
        """.data(using: .utf8))

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let item = try #require(wrapper.items.first)

        #expect(item.title == "No Color")
        #expect(item.colorTag == nil)
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

        let wrapper = try JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: json)
        let rawItem = try #require(wrapper.items.first)

        #expect(rawItem.title == "Event without details")
        #expect(rawItem.details == "")
    }
}
