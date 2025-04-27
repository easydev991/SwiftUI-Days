//
//  ItemListView.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 23.03.2024.
//

import SwiftUI
import SwiftData

extension MainScreen {
    struct ListView: View {
        @Environment(\.currentDate) private var currentDate
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
                        makeItemView(item)
                    }
                    .swipeActions {
                        DaysDeleteButton {
                            modelContext.delete(item)
                        }
                        DaysEditButton { editItem = item }
                    }
                }
            }
            .listStyle(.plain)
            .animation(.default, value: items)
            .overlay { emptySearchViewIfNeeded }
        }
        
        private func makeItemView(_ item: Item) -> some View {
            HStack(spacing: 12) {
                Text(item.title)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(item.makeDaysCount(to: currentDate)) days")
                    .contentTransition(.numericText())
                    .containerRelativeFrame(.horizontal, alignment: .trailing) { length, _ in
                        length * 0.3
                    }
            }
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
}

#if DEBUG
#Preview {
    NavigationStack {
        MainScreen.ListView(editItem: .constant(nil))
            .modelContainer(PreviewModelContainer.make(with: Item.makeList()))
    }
}
#endif
