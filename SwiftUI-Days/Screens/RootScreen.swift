import SwiftUI

struct RootScreen: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var tab = Tab.list
    @State private var currentDate = Date.now

    var body: some View {
        TabView(selection: $tab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.screen
                    .tabItem { tab.tabItemLabel }
                    .tag(tab)
            }
        }
        .environment(\.currentDate, currentDate)
        .animation(.default, value: currentDate)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                currentDate = .now
            }
        }
    }
}

extension RootScreen {
    private enum Tab: CaseIterable {
        case list
        case more

        private var localizedTitle: LocalizedStringKey {
            self == .list ? "Events" : "More"
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
