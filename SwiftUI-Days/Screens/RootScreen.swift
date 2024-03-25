//
//  RootScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 24.03.2024.
//

import SwiftUI

struct RootScreen: View {
    @State private var tab = Tab.list
    
    var body: some View {
        TabView(selection: $tab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.screen
                    .tabItem { tab.tabItemLabel }
                    .tag(tab)
            }
        }
    }
}

extension RootScreen {
    private enum Tab: CaseIterable {
        case list
        case more
        
        private var localizedTitle: LocalizedStringKey {
            self == .list ? "List" : "More"
        }
        
        private var systemImageName: String {
            self == .list
            ? "list.bullet"
            : "gear"
        }
        
        var tabItemLabel: some View {
            Label(
                localizedTitle,
                systemImage: systemImageName
            )
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

#if DEBUG
#Preview {
    RootScreen()
}
#endif
