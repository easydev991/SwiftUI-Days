import Foundation
import SwiftData
import SwiftUI

/// Версия 1: Исходная схема (без `colorTagData` и `displayOption`)
///
/// Соответствует релизу приложения 1.0
enum ItemSchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Item.self]
    }

    @Model
    final class Item {
        var title = ""
        var details = ""
        var timestamp = Date.now

        init(title: String, details: String = "", timestamp: Date) {
            self.title = title
            self.details = details
            self.timestamp = timestamp
        }
    }
}

/// Версия 2: Схема с `colorTagData`
///
/// Соответствует релизу приложения 1.5
enum ItemSchemaV2: VersionedSchema {
    static let versionIdentifier = Schema.Version(2, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Item.self]
    }

    @Model
    final class Item {
        var title = ""
        var details = ""
        var timestamp = Date.now
        var colorTagData: Data?

        init(
            title: String,
            details: String = "",
            timestamp: Date,
            colorTag: Color? = nil
        ) {
            self.title = title
            self.details = details
            self.timestamp = timestamp
            colorTagData = colorTag.flatMap { color in
                try? NSKeyedArchiver.archivedData(
                    withRootObject: UIColor(color),
                    requiringSecureCoding: false
                )
            }
        }
    }
}

/// Версия 3: Текущая схема с `colorTagData` и `displayOption`
///
/// Соответствует релизу приложения 1.6
enum ItemSchemaV3: VersionedSchema {
    static let versionIdentifier = Schema.Version(3, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Item.self]
    }

    @Model
    final class Item {
        var title = ""
        var details = ""
        var timestamp = Date.now
        var colorTagData: Data?
        var displayOption: DisplayOption?

        init(
            title: String,
            details: String = "",
            timestamp: Date,
            colorTag: Color? = nil,
            displayOption: DisplayOption? = .day
        ) {
            self.title = title
            self.details = details
            self.timestamp = timestamp
            self.displayOption = displayOption
            colorTagData = colorTag.flatMap { color in
                try? NSKeyedArchiver.archivedData(
                    withRootObject: UIColor(color),
                    requiringSecureCoding: false
                )
            }
        }
    }
}
