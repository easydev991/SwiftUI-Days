//
//  MainScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

import SwiftUI
import SwiftData

struct MainScreen: View {
    @Query private var items: [Item]
    @State private var showAddItemSheet = false
    @AppStorage("listSortOrder") private var sortOrder = SortOrder.forward.rawValue
    @State private var searchQuery = ""
    @State private var editItem: Item?

    var body: some View {
        NavigationStack {
            ZStack {
                if items.isEmpty {
                    emptyView.transition(.scale.combined(with: .opacity))
                } else {
                    itemListView
                }
            }
            .animation(.bouncy, value: items.isEmpty)
            .navigationTitle("Events")
        }
        .sheet(isPresented: $showAddItemSheet) {
            NavigationStack {
                EditItemScreen { showAddItemSheet.toggle() }
            }
        }
    }
    
    private var sortButton: some View {
        Menu {
            Picker("Sort Order", selection: $sortOrder) {
                ForEach([SortOrder.forward, .reverse], id: \.self) { order in
                    Text(order.name)
                        .tag(order.rawValue)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
        .accessibilityIdentifier("sortNavButton")
    }
    
    private var addItemButton: some View {
        Button { showAddItemSheet.toggle() } label: {
            Label("Add Item", systemImage: "plus")
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
        .navigationDestination(item: $editItem) {
            EditItemScreen(oldItem: $0) { editItem = nil }
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
            label: { Label("What should we remember?", systemImage: "tray.fill") },
            description: { Text("Create your first item") },
            actions: {
                addItemButton
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.buttonTint)
            }
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("emptyView")
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
