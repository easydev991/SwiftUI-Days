//
//  SwiftUI_DaysApp.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

import SwiftUI
import SwiftData

@main
struct SwiftUI_DaysApp: App {
    private let sharedModelContainer: ModelContainer
    
    init() {
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Не смогли создать ModelContainer: \(error)")
        }
        prepareForUITestIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            RootScreen()
                .dynamicTypeSize(...DynamicTypeSize.accessibility2)
        }
        .modelContainer(sharedModelContainer)
    }
    
    @MainActor private func prepareForUITestIfNeeded() {
        if ProcessInfo.processInfo.arguments.contains("UITest") {
            UIView.setAnimationsEnabled(false)
        }
    }
}
