//
//  PreviewModelContainer.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 24.03.2024.
//

import SwiftData

enum PreviewModelContainer {
    @MainActor
    static func make(with items: [Item]) -> ModelContainer {
        let container = try! ModelContainer(
            for: Item.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        items.forEach(container.mainContext.insert)
        return container
    }
}
