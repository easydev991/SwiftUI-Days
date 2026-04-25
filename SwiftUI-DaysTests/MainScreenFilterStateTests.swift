import Foundation
import SwiftData
import SwiftUI
@testable import SwiftUI_Days
import Testing

@Suite("Тесты MainScreenFilterState")
struct MainScreenFilterStateTests {
    @Test("availableColorTags считается из полного набора, без учёта поиска")
    func availableColorTagsFromAllItems() {
        let items = [
            makeItem(title: "Alpha", details: "Milk", timestamp: .init(timeIntervalSince1970: 1), colorHex: "#FF0000FF"),
            makeItem(title: "Beta", details: "Tea", timestamp: .init(timeIntervalSince1970: 2), colorHex: "#00FF00FF"),
            makeItem(title: "Gamma", details: "Milk", timestamp: .init(timeIntervalSince1970: 3), colorHex: nil)
        ]

        let state = MainScreenFilterState(
            items: items,
            searchQuery: "Milk",
            selectedColorFilterHex: nil,
            sortOrder: .forward
        )

        #expect(state.availableColorTags == ["#FF0000FF", "#00FF00FF"])
    }

    @Test("visibleItems фильтруется по search AND color")
    func visibleItemsWithSearchAndColorFilter() throws {
        let items = [
            makeItem(title: "Milk 1", details: "red", timestamp: .init(timeIntervalSince1970: 1), colorHex: "#FF0000FF"),
            makeItem(title: "Milk 2", details: "blue", timestamp: .init(timeIntervalSince1970: 2), colorHex: "#0000FFFF"),
            makeItem(title: "Bread", details: "red", timestamp: .init(timeIntervalSince1970: 3), colorHex: "#FF0000FF")
        ]

        let state = MainScreenFilterState(
            items: items,
            searchQuery: "Milk",
            selectedColorFilterHex: "#FF0000FF",
            sortOrder: .forward
        )

        #expect(state.visibleItems.count == 1)
        let firstVisibleItem = try #require(state.visibleItems.first)
        #expect(firstVisibleItem.title == "Milk 1")
    }

    @Test("itemsCountForFilterButton равен количеству visibleItems")
    func itemsCountMatchesVisibleItemsCount() {
        let items = [
            makeItem(title: "One", timestamp: .init(timeIntervalSince1970: 1), colorHex: "#FF0000FF"),
            makeItem(title: "Two", timestamp: .init(timeIntervalSince1970: 2), colorHex: "#FF0000FF")
        ]

        let state = MainScreenFilterState(
            items: items,
            searchQuery: "",
            selectedColorFilterHex: "#FF0000FF",
            sortOrder: .forward
        )

        #expect(state.itemsCountForFilterButton == state.visibleItems.count)
        #expect(state.itemsCountForFilterButton == 2)
    }

    @Test("Невалидный selectedColorFilterHex сбрасывается автоматически")
    func invalidSelectedColorResetsToNil() {
        let items = [
            makeItem(title: "One", timestamp: .init(timeIntervalSince1970: 1), colorHex: "#FF0000FF"),
            makeItem(title: "Two", timestamp: .init(timeIntervalSince1970: 2), colorHex: "#00FF00FF")
        ]

        let state = MainScreenFilterState(
            items: items,
            searchQuery: "",
            selectedColorFilterHex: "#0000FFFF",
            sortOrder: .forward
        )

        #expect(state.selectedColorFilterHex == nil)
        #expect(state.visibleItems.count == 2)
    }

    @Test("При пустом списке фильтр сбрасывается в nil")
    func selectedColorResetsWhenItemsAreEmpty() {
        let state = MainScreenFilterState(
            items: [],
            searchQuery: "",
            selectedColorFilterHex: "#FF0000FF",
            sortOrder: .forward
        )

        #expect(state.availableColorTags.isEmpty)
        #expect(state.selectedColorFilterHex == nil)
        #expect(state.visibleItems.isEmpty)
        #expect(state.itemsCountForFilterButton == 0)
        #expect(!state.isFilterButtonVisible)
    }
}

private extension MainScreenFilterStateTests {
    func makeItem(
        title: String,
        details: String = "",
        timestamp: Date,
        colorHex: String?
    ) -> Item {
        Item(
            title: title,
            details: details,
            timestamp: timestamp,
            colorTag: colorHex.flatMap { Color(hexRGBA: $0) }
        )
    }
}
