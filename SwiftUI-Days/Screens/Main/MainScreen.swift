import SwiftData
import SwiftUI

struct MainScreen: View {
    @Query private var items: [Item]
    @State private var showAddItemSheet = false
    @AppStorage("listSortOrder") private var sortOrder = SortOrder.forward.rawValue
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
        .sheet(isPresented: $showAddItemSheet) {
            NavigationStack {
                ScrollView {
                    EditItemScreen { showAddItemSheet.toggle() }
                }
                .scrollBounceBehavior(.basedOnSize)
            }
        }
    }

    private var sortButton: some View {
        Menu {
            Picker(.sortOrder, selection: $sortOrder) {
                ForEach([SortOrder.forward, .reverse], id: \.self) { order in
                    Text(order.name)
                        .tag(order.rawValue)
                }
            }
        } label: {
            Label(.sort, systemImage: "arrow.up.arrow.down")
        }
        .accessibilityIdentifier("sortNavButton")
    }

    private var addItemButton: some View {
        Button { showAddItemSheet.toggle() } label: {
            Label(.addItem, systemImage: "plus")
        }
        .accessibilityIdentifier("addItemButton")
    }

    private var itemListView: some View {
        ListView(
            searchText: searchQuery,
            sortOrder: .init(rawValue: sortOrder) ?? .forward,
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
            if items.count > 1 {
                ToolbarItem(placement: .topBarLeading) {
                    sortButton
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                addItemButton
            }
        }
    }

    private var emptyView: some View {
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
}

#Preview("Пусто") {
    MainScreen()
        .modelContainer(for: Item.self, inMemory: true)
}

#if DEBUG
#Preview("Список") {
    MainScreen()
        .modelContainer(PreviewModelContainer.make(with: Item.makeList()))
}
#endif
