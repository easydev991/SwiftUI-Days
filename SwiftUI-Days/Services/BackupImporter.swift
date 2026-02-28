import Foundation

struct BackupImporter {
    let items: [BackupFileDocument.BackupItem]
    let format: BackupFormat

    init(data: Data) throws {
        if let wrapper = try? JSONDecoder().decode(BackupFileDocument.BackupWrapper.self, from: data) {
            let detectedFormat = wrapper.format ?? .ios
            format = detectedFormat
            items = wrapper.items.map { rawItem in
                BackupFileDocument.BackupItem(
                    title: rawItem.title,
                    details: rawItem.details,
                    timestamp: rawItem.parsedTimestamp(format: detectedFormat),
                    colorTag: rawItem.parsedColorTag,
                    displayOption: rawItem.displayOption ?? .day
                )
            }
        } else {
            format = .ios
            items = try JSONDecoder().decode([BackupFileDocument.BackupItem].self, from: data)
        }
    }
}
