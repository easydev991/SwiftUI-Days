//
//  ItemListView.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 23.03.2024.
//

import SwiftUI
import SwiftData

struct ItemListView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding private var editItem: Item?
    @Query private var items: [Item]
    
    init(
        searchText: String = "",
        sortOrder: SortOrder = .forward,
        editItem: Binding<Item?>
    ) {
        _items = Query(
            filter: Item.predicate(searchText: searchText),
            sort: \.timestamp,
            order: sortOrder
        )
        _editItem = editItem
    }
    
    var body: some View {
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
        .listStyle(.plain)
        .overlay { emptySearchViewIfNeeded }
    }
    
    private var emptySearchViewIfNeeded: some View {
        ZStack {
            if items.isEmpty {
                ContentUnavailableView.search
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.bouncy, value: items.isEmpty)
    }
}

#Preview {
    ItemListView(editItem: .constant(nil))
}
