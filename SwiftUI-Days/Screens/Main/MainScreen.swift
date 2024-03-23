//
//  MainScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

import SwiftUI
import SwiftData

struct MainScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showAddItemSheet = false
    @State private var editItem: Item?

    var body: some View {
        NavigationStack {
            ZStack {
                if items.isEmpty {
                    emptyView
                        .transition(.scale)
                } else {
                    itemList
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                addItemButton
                            }
                        }
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
    
    private var addItemButton: some View {
        Button { showAddItemSheet.toggle() } label: {
            Label("Add Item", systemImage: "plus")
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
    
    private var itemList: some View {
        List {
            ForEach(items) { item in
                NavigationLink(value: item) {
                    ListItemView(item: item)
                }
                .swipeActions {
                    DaysDeleteButton { modelContext.delete(item) }
                    DaysEditButton { editItem = item }
                }
            }
        }
        .navigationDestination(for: Item.self) { ItemScreen(item: $0) }
        .navigationDestination(item: $editItem) {
            EditItemScreen(oldItem: $0) { editItem = nil }
        }
        .listStyle(.plain)
    }
}

#if DEBUG
#Preview {
    MainScreen()
        .modelContainer(for: Item.self, inMemory: true)
}
#endif
