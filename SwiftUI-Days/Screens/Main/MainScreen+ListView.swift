import SwiftData
import SwiftUI

extension MainScreen {
    struct ListView: View {
        @Environment(\.analyticsService) private var analytics
        @Environment(\.currentDate) private var currentDate
        @Environment(\.modelContext) private var modelContext
        @Binding private var editItem: Item?
        private let items: [Item]
        private let searchText: String

        init(
            items: [Item],
            searchText: String = "",
            editItem: Binding<Item?>
        ) {
            self.items = items
            self.searchText = searchText
            _editItem = editItem
        }

        var body: some View {
            List {
                ForEach(items) { item in
                    let content = ListItemView.Content(item: item, currentDate: currentDate)
                    NavigationLink(value: item) {
                        ListItemView(content: content)
                    }
                    .swipeActions {
                        DaysDeleteButton {
                            analytics.log(.userAction(action: .delete))
                            modelContext.delete(item)
                        }
                        DaysEditButton {
                            analytics.log(.userAction(action: .edit))
                            editItem = item
                        }
                    }
                }
            }
            .listStyle(.plain)
            .animation(.default, value: items.count)
            .overlay { emptySearchViewIfNeeded }
        }

        private var emptySearchViewIfNeeded: some View {
            ZStack {
                if items.isEmpty, !searchText.isEmpty {
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
        MainScreen.ListView(
            items: Item.makeList(),
            editItem: .constant(nil)
        )
        .modelContainer(PreviewModelContainer.make(with: Item.makeList()))
    }
}
#endif
