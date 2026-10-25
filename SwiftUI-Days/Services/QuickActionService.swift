import Foundation
import Observation
import UIKit

/// Сервис доставки запроса на добавление записи из quick action.
@MainActor
@Observable
final class QuickActionService {
    static let shared = QuickActionService()

    /// Монотонный счётчик запросов: подписчики всегда видят факт запроса.
    private(set) var requestCount = 0
    /// Запрос ещё не потреблён.
    private var isPending = false

    func requestAddItem() {
        requestCount += 1; isPending = true
    }

    /// Возвращает true ровно один раз на каждый запрос.
    func consumeAddItemRequest() -> Bool {
        guard isPending else { return false }
        isPending = false
        return true
    }

    /// Единственная точка маппинга системного shortcut в доменное действие.
    /// Возвращает true, если событие распознано и обработано.
    @discardableResult
    func handle(_ shortcutItem: UIApplicationShortcutItem?) -> Bool {
        guard let shortcutItem, let type = QuickActionType(shortcutType: shortcutItem.type) else { return false }
        switch type {
        case .addItem:
            requestAddItem()
            return true
        }
    }
}
