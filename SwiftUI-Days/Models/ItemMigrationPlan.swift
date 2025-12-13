import Foundation
import OSLog
import SwiftData

private let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: String(describing: ItemMigrationPlan.self)
)

enum ItemMigrationPlan: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [
        ItemSchemaV1.self,
        ItemSchemaV2.self,
        ItemSchemaV3.self
    ]

    static let stages: [MigrationStage] = [
        migrateV1toV2,
        migrateV2toV3
    ]

    /// Миграция от версии 1 к версии 2 (добавление colorTagData)
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: ItemSchemaV1.self,
        toVersion: ItemSchemaV2.self,
        willMigrate: { _ in },
        didMigrate: { context in
            do {
                let fetchDescriptor = FetchDescriptor<ItemSchemaV2.Item>()
                let items = try context.fetch(fetchDescriptor)
                items.forEach { $0.colorTagData = nil }
                try context.save()
            } catch {
                logger.error("Ошибка миграции V1->V2: \(error.localizedDescription)")
            }
        }
    )

    /// Миграция от версии 2 к версии 3 (добавление displayOption)
    static let migrateV2toV3 = MigrationStage.custom(
        fromVersion: ItemSchemaV2.self,
        toVersion: ItemSchemaV3.self,
        willMigrate: { _ in },
        didMigrate: { context in
            do {
                let fetchDescriptor = FetchDescriptor<ItemSchemaV3.Item>()
                let items = try context.fetch(fetchDescriptor)
                items.forEach { $0.displayOption = nil }
                try context.save()
            } catch {
                logger.error("Ошибка миграции V2->V3: \(error.localizedDescription)")
            }
        }
    )
}
