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
    @State private var appSettings = AppSettings()
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
                .environment(appSettings)
                .preferredColorScheme(appSettings.appTheme.colorScheme)
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func prepareForUITestIfNeeded() {
        if ProcessInfo.processInfo.arguments.contains("UITest") {
            UIView.setAnimationsEnabled(false)
        }
    }
}
