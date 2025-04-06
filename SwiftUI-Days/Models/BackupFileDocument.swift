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
    static func makeBackupItem(with item: Item) -> BackupItem {
        .init(title: item.title, details: item.details, timestamp: item.timestamp)
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
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(items)
        return FileWrapper(regularFileWithContents: data)
    }
}

extension BackupFileDocument {
    struct BackupItem: Codable {
        let title: String
        let details: String
        let timestamp: Date
        
        var realItem: Item {
            .init(title: title, details: details, timestamp: timestamp)
        }
    }
}
