import SwiftData
import SwiftUI

@main
struct SwiftUI_DaysApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var appSettings = AppSettings()
    private let analyticsService: AnalyticsService
    private let sharedModelContainer: ModelContainer

    #if DEBUG
    init() {
        if ProcessInfo.processInfo.arguments.contains("UITest") {
            UIView.setAnimationsEnabled(false)
            analyticsService = AnalyticsService(providers: [NoopAnalyticsProvider()])
            sharedModelContainer = PreviewModelContainer.make(
                with: Item.makeDemoList(isEnglish: Locale.current.identifier == "en-US")
            )
        } else {
            analyticsService = AnalyticsService(providers: [FirebaseAnalyticsProvider()])
            let schema = Schema([Item.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            do {
                sharedModelContainer = try ModelContainer(
                    for: schema,
                    migrationPlan: ItemMigrationPlan.self,
                    configurations: [modelConfiguration]
                )
            } catch {
                fatalError("Не смогли создать ModelContainer: \(error)")
            }
        }
    }
    #else
    init() {
        analyticsService = AnalyticsService(providers: [FirebaseAnalyticsProvider()])
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            sharedModelContainer = try ModelContainer(
                for: schema,
                migrationPlan: ItemMigrationPlan.self,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Не смогли создать ModelContainer: \(error)")
        }
    }
    #endif

    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environment(appSettings)
                .environment(\.analyticsService, analyticsService)
                .preferredColorScheme(appSettings.appTheme.colorScheme)
        }
        .modelContainer(sharedModelContainer)
    }
}
