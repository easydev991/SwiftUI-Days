@testable import SwiftUI_Days
import Testing
import UIKit

@Suite("Тесты QuickActionService")
@MainActor
struct QuickActionServiceTests {
    private let service = QuickActionService()

    @Test("Запрос потребляется ровно один раз")
    func requestIsConsumedOnlyOnce() {
        service.requestAddItem()
        #expect(service.consumeAddItemRequest())
        #expect(!service.consumeAddItemRequest())
    }

    @Test("Новый запрос снова становится потребляемым")
    func newRequestIsConsumableAgain() {
        service.requestAddItem()
        #expect(service.consumeAddItemRequest())
        service.requestAddItem()
        #expect(service.consumeAddItemRequest())
    }

    @Test("Без запроса consume возвращает false")
    func consumeWithoutRequestReturnsFalse() {
        #expect(!service.consumeAddItemRequest())
    }

    @Test("Счётчик запросов растёт монотонно")
    func requestCountGrowsMonotonically() {
        let initialCount = service.requestCount
        service.requestAddItem()
        service.requestAddItem()
        service.requestAddItem()
        #expect(service.requestCount == initialCount + 3)
    }

    @Test("Распознанный quick action создаёт запрос")
    func handleRecognizedShortcut() {
        let item = UIApplicationShortcutItem(
            type: QuickActionType.addItemIdentifier,
            localizedTitle: "Add Item",
            localizedSubtitle: nil,
            icon: nil,
            userInfo: nil
        )
        #expect(service.handle(item))
        #expect(service.requestCount == 1)
        #expect(service.consumeAddItemRequest())
    }

    @Test("Неизвестный quick action игнорируется")
    func handleUnknownShortcut() {
        let item = UIApplicationShortcutItem(
            type: "com.oleg991.SwiftUI-Days.unknown",
            localizedTitle: "Unknown",
            localizedSubtitle: nil,
            icon: nil,
            userInfo: nil
        )
        #expect(!service.handle(item))
        #expect(service.requestCount == 0)
        #expect(!service.consumeAddItemRequest())
    }

    @Test("Отсутствующий quick action игнорируется")
    func handleMissingShortcut() {
        #expect(!service.handle(nil))
        #expect(service.requestCount == 0)
    }
}
