import SwiftData
import SwiftUI

struct MainScreen: View {
    @Environment(\.analyticsService) private var analytics
    @Environment(\.isBlurred) private var isBlurred
    @Environment(AppSettings.self) private var appSettings
    @Query private var items: [Item]
    @State private var sheetItem: SheetItem?
    @AppStorage(DefaultsKey.listSortOrder.rawValue) private var sortOrder = SortOrder.forward.rawValue
    @State private var searchQuery = ""
    @State private var editItem: Item?
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if items.isEmpty {
                    emptyView.transition(.scale.combined(with: .opacity))
                } else {
                    itemListView
                }
            }
            .animation(.bouncy, value: items.isEmpty)
            .toolbar(path.isEmpty ? .automatic : .hidden, for: .tabBar)
            .navigationTitle(.events)
        }
        .applyBlur(if: isBlurred)
        .sheet(item: $sheetItem) { item in
            switch item {
            case .addItem:
                NavigationStack {
                    ScrollView {
                        EditItemScreen { sheetItem = nil }
                    }
                    .scrollBounceBehavior(.basedOnSize)
                }
            case let .colorFilter(availableColors, selectedColorHex):
                ColorTagFilterSheet(
                    availableColors: availableColors,
                    selectedColorHex: selectedColorHex
                ) { updatedColorHex in
                    appSettings.mainScreenColorTagFilterHex = updatedColorHex
                }
            }
        }
        .onAppear { normalizeColorFilterIfNeeded() }
        .onChange(of: filterState.availableColorTags) { _, _ in
            normalizeColorFilterIfNeeded()
        }
        .trackScreen(.main)
    }
}

private extension MainScreen {
    enum SheetItem: Identifiable {
        case addItem
        case colorFilter(availableColors: [String], selectedColorHex: String?)

        var id: String {
            switch self {
            case .addItem: "addItem"
            case .colorFilter: "colorFilter"
            }
        }
    }

    var sortButton: some View {
        Menu {
            Picker(.sortOrder, selection: $sortOrder) {
                ForEach([SortOrder.forward, .reverse], id: \.self) { order in
                    Text(order.name)
                        .tag(order.rawValue)
                }
            }
            .onChange(of: sortOrder) { _, _ in
                analytics.log(.userAction(action: .sort))
            }
        } label: {
            Label(.sort, systemImage: "arrow.up.arrow.down")
        }
        .accessibilityIdentifier("sortNavButton")
    }

    var addItemButton: some View {
        Button {
            analytics.log(.userAction(action: .create))
            sheetItem = .addItem
        } label: {
            Label(.addItem, systemImage: "plus")
        }
        .accessibilityIdentifier("addItemButton")
    }

    var filterButton: some View {
        Button {
            analytics.log(.userAction(action: .openFilter))
            sheetItem = .colorFilter(
                availableColors: filterState.availableColorTags,
                selectedColorHex: filterState.selectedColorFilterHex
            )
        } label: {
            Label(.filter, systemImage: "line.3.horizontal.decrease")
                .symbolVariant(
                    filterState.selectedColorFilterHex == nil
                        ? .circle
                        : .circle.fill
                )
        }
        .accessibilityIdentifier("filterNavButton")
    }

    var filterState: MainScreenFilterState {
        MainScreenFilterState(
            items: items,
            searchQuery: searchQuery,
            selectedColorFilterHex: appSettings.mainScreenColorTagFilterHex,
            sortOrder: .init(rawValue: sortOrder) ?? .forward
        )
    }

    var itemListView: some View {
        ListView(
            items: filterState.visibleItems,
            searchText: searchQuery,
            editItem: $editItem
        )
        .navigationDestination(for: Item.self) { ItemScreen(item: $0) }
        .navigationDestination(item: $editItem) { oldItem in
            ScrollView {
                EditItemScreen(oldItem: oldItem) { editItem = nil }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .automatic))
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                if items.count > 1 {
                    sortButton
                }
                if filterState.isFilterButtonVisible {
                    filterButton
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                addItemButton
            }
        }
    }

    var emptyView: some View {
        ContentUnavailableView(
            label: { Label(.whatShouldWeRemember, systemImage: "tray.fill") },
            description: { Text(.createYourFirstItem) },
            actions: {
                addItemButton
                    .daysButtonStyle()
            }
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("emptyView")
    }

    func normalizeColorFilterIfNeeded() {
        let selectedColorHex = appSettings.mainScreenColorTagFilterHex
        let normalizedColorHex = filterState.selectedColorFilterHex
        guard selectedColorHex != normalizedColorHex else { return }
        appSettings.mainScreenColorTagFilterHex = normalizedColorHex
    }
}

#if DEBUG
#Preview("Пусто") {
    MainScreen()
        .modelContainer(for: Item.self, inMemory: true)
}

#Preview("Список") {
    MainScreen()
        .modelContainer(PreviewModelContainer.make(with: Item.makeList()))
}
#endif
