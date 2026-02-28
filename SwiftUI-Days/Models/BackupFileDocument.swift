import SwiftUI
import UniformTypeIdentifiers

struct BackupFileDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.json]
    }

    static var writableContentTypes: [UTType] {
        [.json]
    }

    static func toBackupItem(item: Item) -> BackupItem {
        .init(
            title: item.title,
            details: item.details,
            timestamp: item.timestamp,
            colorTag: item.colorTag,
            displayOption: item.displayOption
        )
    }

    let items: [BackupItem]
    let format: BackupFormat

    init(items: [BackupItem], format: BackupFormat = .ios) {
        self.items = items
        self.format = format
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }

        let importer = try BackupImporter(data: data)
        items = importer.items
        format = importer.format
    }

    func fileWrapper(configuration _: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let wrapper = exportWrapper()
        let data = try encoder.encode(wrapper)
        return FileWrapper(regularFileWithContents: data)
    }

    func exportWrapper() -> BackupWrapper {
        let rawItems = items.map { item -> RawBackupItem in
            RawBackupItem(
                title: item.title,
                details: item.details,
                timestamp: item.timestamp.timeIntervalSinceReferenceDate,
                colorTag: item.colorTag,
                displayOption: item.displayOption
            )
        }
        return BackupWrapper(format: .ios, items: rawItems)
    }
}

extension BackupFileDocument {
    struct BackupWrapper: Codable {
        let format: BackupFormat?
        let items: [RawBackupItem]
    }

    struct RawBackupItem: Codable {
        let title: String
        let details: String?
        let timestamp: Double
        let colorTag: Color?
        let displayOption: DisplayOption?

        func parsedTimestamp(format: BackupFormat) -> Date {
            switch format {
            case .ios:
                Date(timeIntervalSinceReferenceDate: timestamp)
            case .android:
                Date(timeIntervalSince1970: timestamp / 1000)
            }
        }

        var parsedColorTag: Color? {
            colorTag
        }

        private enum CodingKeys: String, CodingKey {
            case title, details, timestamp, colorTag, displayOption
        }

        init(
            title: String,
            details: String? = nil,
            timestamp: Double,
            colorTag: Color? = nil,
            displayOption: DisplayOption? = .day
        ) {
            self.title = title
            self.details = details
            self.timestamp = timestamp
            self.colorTag = colorTag
            self.displayOption = displayOption
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decode(String.self, forKey: .title)
            details = try container.decodeIfPresent(String.self, forKey: .details) ?? ""
            timestamp = try container.decode(Double.self, forKey: .timestamp)

            if let colorData = try? container.decode(Data.self, forKey: .colorTag) {
                colorTag = try? NSKeyedUnarchiver.unarchivedObject(
                    ofClass: UIColor.self,
                    from: colorData
                ).map(Color.init)
            } else if let hexString = try? container.decode(String.self, forKey: .colorTag) {
                colorTag = Color(hex: hexString)
            } else {
                colorTag = nil
            }

            displayOption = try container.decodeIfPresent(DisplayOption.self, forKey: .displayOption) ?? .day
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
            try container.encodeIfPresent(displayOption, forKey: .displayOption)
        }
    }

    struct BackupItem: Codable, Hashable {
        let title: String
        let details: String?
        let timestamp: Date
        let colorTag: Color?
        let displayOption: DisplayOption?

        var realItem: Item {
            .init(
                title: title,
                details: details ?? "",
                timestamp: timestamp,
                colorTag: colorTag,
                displayOption: displayOption
            )
        }

        private enum CodingKeys: String, CodingKey {
            case title, details, timestamp, colorTag, displayOption
        }

        init(
            title: String,
            details: String? = nil,
            timestamp: Date,
            colorTag: Color? = nil,
            displayOption: DisplayOption? = .day
        ) {
            self.title = title
            self.details = details
            self.timestamp = timestamp
            self.colorTag = colorTag
            self.displayOption = displayOption
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decode(String.self, forKey: .title)
            details = try container.decodeIfPresent(String.self, forKey: .details)

            let rawTimestamp = try container.decode(Double.self, forKey: .timestamp)
            timestamp = Date(timeIntervalSinceReferenceDate: rawTimestamp)

            if let colorData = try? container.decode(Data.self, forKey: .colorTag) {
                colorTag = try? NSKeyedUnarchiver.unarchivedObject(
                    ofClass: UIColor.self,
                    from: colorData
                ).map(Color.init)
            } else if let hexString = try? container.decode(String.self, forKey: .colorTag) {
                colorTag = Color(hex: hexString)
            } else {
                colorTag = nil
            }

            displayOption = try container.decodeIfPresent(DisplayOption.self, forKey: .displayOption) ?? .day
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
            try container.encodeIfPresent(displayOption, forKey: .displayOption)
        }
    }
}
