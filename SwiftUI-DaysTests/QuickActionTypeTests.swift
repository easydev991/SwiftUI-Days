import Foundation
@testable import SwiftUI_Days
import Testing

@Suite("Тесты QuickActionType")
struct QuickActionTypeTests {
    @Test("Известный тип shortcut-а маппится в addItem")
    func knownShortcutTypeMapsToAddItem() throws {
        let type = try #require(QuickActionType(shortcutType: "com.oleg991.SwiftUI-Days.addItem"))
        #expect(type == .addItem)
    }

    @Test("Идентификатор типа shortcut-а закреплён")
    func addItemIdentifierIsStable() {
        #expect(QuickActionType.addItemIdentifier == "com.oleg991.SwiftUI-Days.addItem")
    }

    @Test("Статический shortcut в Info.plist использует закреплённый идентификатор типа")
    func staticShortcutTypeMatchesPlist() throws {
        let shortcutItems = try #require(
            Bundle.main.object(forInfoDictionaryKey: "UIApplicationShortcutItems") as? [[String: Any]]
        )
        let shortcut = try #require(shortcutItems.first)
        let type = try #require(shortcut["UIApplicationShortcutItemType"] as? String)
        #expect(type == QuickActionType.addItemIdentifier)
    }

    @Test("Неизвестный тип shortcut-а отбрасывается", arguments: [
        "",
        "addItem",
        "com.oleg991.SwiftUI-Days.unknown"
    ])
    func unknownShortcutTypeIsDiscarded(shortcutType: String) {
        #expect(QuickActionType(shortcutType: shortcutType) == nil)
    }
}
