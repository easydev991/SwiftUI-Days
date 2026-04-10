import Foundation
@testable import SwiftUI_Days
import Testing

private final class MockAnalyticsProvider: AnalyticsProvider {
    private(set) var events: [AnalyticsEvent] = []

    func log(event: AnalyticsEvent) {
        events.append(event)
    }

    func reset() {
        events = []
    }
}

@Suite("AnalyticsService tests")
struct AnalyticsServiceTests {
    @Test
    func logCallsAllProviders() {
        let provider1 = MockAnalyticsProvider()
        let provider2 = MockAnalyticsProvider()
        let service = AnalyticsService(providers: [provider1, provider2])

        let event = AnalyticsEvent.userAction(action: .delete)
        service.log(event)

        #expect(provider1.events.count == 1)
        #expect(provider2.events.count == 1)
    }

    @Test
    func logWithEmptyProvidersDoesNotCrash() {
        let service = AnalyticsService(providers: [])
        let event = AnalyticsEvent.userAction(action: .delete)
        service.log(event)
    }

    @Test
    func screenViewEventIsLogged() {
        let provider = MockAnalyticsProvider()
        let service = AnalyticsService(providers: [provider])

        let event = AnalyticsEvent.screenView(screen: .main)
        service.log(event)

        #expect(provider.events.count == 1)
        if case let .screenView(screen) = provider.events[0] {
            #expect(screen == .main)
        }
    }

    @Test
    func userActionEventIsLogged() {
        let provider = MockAnalyticsProvider()
        let service = AnalyticsService(providers: [provider])

        let event = AnalyticsEvent.userAction(action: .delete)
        service.log(event)

        #expect(provider.events.count == 1)
        if case let .userAction(action) = provider.events[0] {
            #expect(action.name == "delete")
        }
    }

    @Test
    func iconSelectedEventIsLoggedWithIconName() {
        let provider = MockAnalyticsProvider()
        let service = AnalyticsService(providers: [provider])

        let event = AnalyticsEvent.userAction(action: .iconSelected(iconName: "AppIcon42"))
        service.log(event)

        #expect(provider.events.count == 1)
        if case let .userAction(.iconSelected(iconName)) = provider.events[0] {
            #expect(iconName == "AppIcon42")
        }
    }

    @Test
    func appErrorEventIsLogged() {
        let provider = MockAnalyticsProvider()
        let service = AnalyticsService(providers: [provider])

        let error = NSError(domain: "TestError", code: 42, userInfo: nil)
        let event = AnalyticsEvent.appError(kind: .setIcon, error: error)
        service.log(event)

        #expect(provider.events.count == 1)
        if case let .appError(kind, loggedError) = provider.events[0] {
            #expect(kind == .setIcon)
            #expect(loggedError as NSError == error)
        }
    }

    @Test
    func multipleEventsAreLoggedInOrder() {
        let provider = MockAnalyticsProvider()
        let service = AnalyticsService(providers: [provider])

        service.log(.screenView(screen: .main))
        service.log(.userAction(action: .delete))
        service.log(.userAction(action: .iconSelected(iconName: "TestIcon")))

        #expect(provider.events.count == 3)
    }
}

@Suite("NoopAnalyticsProvider tests")
struct NoopAnalyticsProviderTests {
    @Test
    func doesNotCrashOnScreenView() {
        let provider = NoopAnalyticsProvider()
        provider.log(event: .screenView(screen: .main))
    }

    @Test
    func doesNotCrashOnUserAction() {
        let provider = NoopAnalyticsProvider()
        provider.log(event: .userAction(action: .delete))
    }

    @Test
    func doesNotCrashOnIconSelected() {
        let provider = NoopAnalyticsProvider()
        provider.log(event: .userAction(action: .iconSelected(iconName: "AnyIcon")))
    }

    @Test
    func doesNotCrashOnAppError() {
        let provider = NoopAnalyticsProvider()
        let error = NSError(domain: "TestError", code: 0, userInfo: nil)
        provider.log(event: .appError(kind: .createBackup, error: error))
    }
}

@Suite("AnalyticsEvent tests")
struct AnalyticsEventTests {
    @Test
    func userActionNames() {
        #expect(AnalyticsEvent.UserAction.delete.name == "delete")
        #expect(AnalyticsEvent.UserAction.sort.name == "sort")
        #expect(AnalyticsEvent.UserAction.itemSaved.name == "item_saved")
        #expect(AnalyticsEvent.UserAction.create.name == "create")
        #expect(AnalyticsEvent.UserAction.edit.name == "edit")
    }

    @Test
    func iconSelectedName() {
        #expect(AnalyticsEvent.UserAction.iconSelected(iconName: "Any").name == "icon_selected")
    }

    @Test
    func appScreenRawValues() {
        #expect(AnalyticsEvent.AppScreen.root.rawValue == "root")
        #expect(AnalyticsEvent.AppScreen.main.rawValue == "main")
        #expect(AnalyticsEvent.AppScreen.item.rawValue == "item")
        #expect(AnalyticsEvent.AppScreen.more.rawValue == "more")
        #expect(AnalyticsEvent.AppScreen.themeIcon.rawValue == "theme_icon")
        #expect(AnalyticsEvent.AppScreen.appData.rawValue == "app_data")
        #expect(AnalyticsEvent.AppScreen.privacy.rawValue == "privacy")
    }

    @Test
    func appErrorKindRawValues() {
        #expect(AnalyticsEvent.AppErrorKind.setIcon.rawValue == "set_icon")
        #expect(AnalyticsEvent.AppErrorKind.createBackup.rawValue == "create_backup")
        #expect(AnalyticsEvent.AppErrorKind.restoreBackup.rawValue == "restore_backup")
        #expect(AnalyticsEvent.AppErrorKind.deleteAllData.rawValue == "delete_all_data")
    }
}
