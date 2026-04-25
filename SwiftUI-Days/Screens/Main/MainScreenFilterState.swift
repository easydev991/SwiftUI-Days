import Foundation
import SwiftData

struct MainScreenFilterState {
    let availableColorTags: [String]
    let selectedColorFilterHex: String?
    let visibleItems: [Item]

    var itemsCountForFilterButton: Int {
        visibleItems.count
    }

    var isFilterButtonVisible: Bool {
        !availableColorTags.isEmpty
            && (itemsCountForFilterButton >= 2 || selectedColorFilterHex != nil)
    }

    init(
        items: [Item],
        searchQuery: String,
        selectedColorFilterHex: String?,
        sortOrder: SortOrder
    ) {
        let sortedItems = Self.sortedItems(items, order: sortOrder)
        let indexedItems = sortedItems.map { (item: $0, colorHex: $0.colorTag?.hexRGBA) }
        availableColorTags = Self.makeAvailableColorTags(from: indexedItems)
        let normalizedSelectedColorHex = Self.normalizedSelectedColorHex(
            selectedColorFilterHex,
            availableColorTags: availableColorTags
        )
        self.selectedColorFilterHex = normalizedSelectedColorHex
        let searchFilteredItems = Self.filterBySearch(indexedItems, query: searchQuery)
        visibleItems = Self.filterByColor(
            searchFilteredItems,
            selectedColorHex: normalizedSelectedColorHex
        )
    }
}

private extension MainScreenFilterState {
    static func sortedItems(
        _ items: [Item],
        order: SortOrder
    ) -> [Item] {
        switch order {
        case .forward:
            items.sorted { $0.timestamp < $1.timestamp }
        case .reverse:
            items.sorted { $0.timestamp > $1.timestamp }
        @unknown default:
            items.sorted { $0.timestamp < $1.timestamp }
        }
    }

    static func makeAvailableColorTags(
        from indexedItems: [(item: Item, colorHex: String?)]
    ) -> [String] {
        var seen = Set<String>()
        return indexedItems.compactMap(\.colorHex).filter { colorHex in
            seen.insert(colorHex).inserted
        }
    }

    static func normalizedSelectedColorHex(
        _ selectedColorHex: String?,
        availableColorTags: [String]
    ) -> String? {
        guard let selectedColorHex else { return nil }
        return availableColorTags.contains(selectedColorHex) ? selectedColorHex : nil
    }

    static func filterBySearch(
        _ indexedItems: [(item: Item, colorHex: String?)],
        query: String
    ) -> [(item: Item, colorHex: String?)] {
        guard !query.isEmpty else { return indexedItems }
        return indexedItems.filter { pair in
            pair.item.title.contains(query) || pair.item.details.contains(query)
        }
    }

    static func filterByColor(
        _ indexedItems: [(item: Item, colorHex: String?)],
        selectedColorHex: String?
    ) -> [Item] {
        guard let selectedColorHex else { return indexedItems.map(\.item) }
        return indexedItems
            .filter { $0.colorHex == selectedColorHex }
            .map(\.item)
    }
}
