import SwiftUI

struct RootScreen: View {
    @Environment(AppSettings.self) private var appSettings
    @Environment(\.scenePhase) private var scenePhase
    @State private var tab = Tab.list
    @State private var currentDate = Date.now
    @State private var isBlurred = false

    var body: some View {
        TabView(selection: $tab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.screen
                    .tabItem { tab.tabItemLabel }
                    .tag(tab)
            }
        }
        .environment(\.isBlurred, isBlurred)
        .environment(\.currentDate, currentDate)
        .animation(.default, value: currentDate)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                currentDate = .now
            }
            guard appSettings.blurWhenMinimized else { return }
            withAnimation {
                isBlurred = newPhase != .active
            }
        }
    }
}

extension RootScreen {
    private enum Tab: CaseIterable {
        case list
        case more

        private var localizedTitle: String {
            self == .list ? String(localized: .events) : String(localized: .more)
        }

        private var systemImageName: String {
            self == .list
                ? "list.bullet"
                : "gear"
        }

        private var accessibilityId: String {
            switch self {
            case .list: "listTabButton"
            case .more: "moreTabButton"
            }
        }

        var tabItemLabel: some View {
            Label(
                localizedTitle,
                systemImage: systemImageName
            )
            .accessibilityIdentifier(accessibilityId)
        }

        @MainActor @ViewBuilder
        var screen: some View {
            switch self {
            case .list: MainScreen()
            case .more: MoreScreen()
            }
        }
    }
}

#Preview {
    RootScreen()
}
