//
//  BackupFileDocument.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 06.04.2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct BackupFileDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    static var writableContentTypes: [UTType] { [.json] }
    static func toBackupItem(item: Item) -> BackupItem {
        .init(
            title: item.title,
            details: item.details,
            timestamp: item.timestamp,
            colorTag: item.colorTag
        )
    }

    let items: [BackupItem]

    init(items: [BackupItem]) {
        self.items = items
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        items = try JSONDecoder().decode([BackupItem].self, from: data)
    }

    func fileWrapper(configuration _: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(items)
        return FileWrapper(regularFileWithContents: data)
    }
}

extension BackupFileDocument {
    struct BackupItem: Codable, Hashable {
        let title: String
        let details: String
        let timestamp: Date
        let colorTag: Color?

        var realItem: Item {
            .init(
                title: title,
                details: details,
                timestamp: timestamp,
                colorTag: colorTag
            )
        }

        private enum CodingKeys: String, CodingKey {
            case title, details, timestamp, colorTag
        }

        init(title: String, details: String, timestamp: Date, colorTag: Color? = nil) {
            self.title = title
            self.details = details
            self.timestamp = timestamp
            self.colorTag = colorTag
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decode(String.self, forKey: .title)
            details = try container.decode(String.self, forKey: .details)
            timestamp = try container.decode(Date.self, forKey: .timestamp)
            // Для обратной совместимости со старыми резервными копиями
            if let colorData = try container.decodeIfPresent(Data.self, forKey: .colorTag) {
                colorTag = try NSKeyedUnarchiver.unarchivedObject(
                    ofClass: UIColor.self,
                    from: colorData
                ).map(Color.init)
            } else {
                colorTag = nil
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(title, forKey: .title)
            try container.encode(details, forKey: .details)
            try container.encode(timestamp, forKey: .timestamp)
            if let colorTag {
                let uiColor = UIColor(colorTag)
                let colorData = try NSKeyedArchiver.archivedData(
                    withRootObject: uiColor,
                    requiringSecureCoding: false
                )
                try container.encode(colorData, forKey: .colorTag)
            }
        }
    }
}
