import Foundation

/// Тип быстрого действия домашнего экрана.
///
/// Маппит системный тип shortcut-а в доменное действие;
/// неизвестные типы отбрасываются.
enum QuickActionType: Equatable {
    /// Добавление новой записи
    case addItem

    /// Идентификатор типа shortcut-а для системного quick action
    static let addItemIdentifier: String = "com.oleg991.SwiftUI-Days.addItem"

    /// Создаёт доменное действие по типу shortcut-а
    /// - Parameter shortcutType: строковый тип, пришедший из UIKit
    /// - Returns: `nil`, если тип не распознан
    init?(shortcutType: String) {
        guard shortcutType == Self.addItemIdentifier else { return nil }
        self = .addItem
    }
}
