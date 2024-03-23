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
    @State private var sortOrder = SortOrder.forward
    @State private var searchQuery = ""
    @State private var editItem: Item?

    var body: some View {
        NavigationStack {
            ZStack {
                if items.isEmpty {
                    emptyView.transition(.scale)
                } else {
                    itemListView
                }
            }
            .animation(.bouncy, value: items.isEmpty)
            .navigationTitle("Items")
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
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
        .pickerStyle(.inline)
    }
    
    private var addItemButton: some View {
        Button { showAddItemSheet.toggle() } label: {
            Label("Add Item", systemImage: "plus")
        }
    }
    
    private var itemListView: some View {
        ItemListView(
            searchText: searchQuery,
            sortOrder: sortOrder,
            editItem: $editItem
        )
        .navigationDestination(for: Item.self) { ItemScreen(item: $0) }
        .navigationDestination(item: $editItem) {
            EditItemScreen(oldItem: $0) { editItem = nil }
        }
        .searchable(text: $searchQuery, prompt: "Search for items")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                sortButton
            }
            ToolbarItem(placement: .topBarTrailing) {
                addItemButton
            }
        }
    }
    
    private var emptyView: some View {
        ContentUnavailableView(
            label: { Label("No Items", systemImage: "tray.fill") },
            description: { Text("Create your first item") },
            actions: {
                addItemButton
                    .labelStyle(.titleOnly)
                    .buttonStyle(.borderedProminent)
            }
        )
    }
}

extension SortOrder {
    /// A name for the sort order in the user interface.
    var name: String {
        switch self {
        case .forward: "Forward"
        case .reverse: "Reverse"
        }
    }
}

#if DEBUG
#Preview {
    MainScreen()
        .modelContainer(for: Item.self, inMemory: true)
}
#endif
