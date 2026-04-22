import Foundation
import SwiftUI
@testable import SwiftUI_Days
import Testing

@Suite("Снапшот контента строки списка")
struct ListItemViewContentTests {
    private let calendar = Calendar.current

    @Test("Снимок сохраняет исходные значения и не меняется после мутаций модели")
    func snapshotKeepsOriginalValues() throws {
        let now = Date.now
        let oneDayAgo = try #require(calendar.date(byAdding: .day, value: -1, to: now))
        let item = Item(
            title: "Исходный заголовок",
            details: "Описание",
            timestamp: oneDayAgo,
            colorTag: .red,
            displayOption: .day
        )
        let expectedDaysCount = item.makeDaysCount(to: now)

        let content = ListItemView.Content(item: item, currentDate: now)

        item.title = "Измененный заголовок"
        item.colorTag = nil
        item.displayOption = .monthDay

        #expect(content.title == "Исходный заголовок")
        #expect(content.colorTag != nil)
        #expect(content.daysCount == expectedDaysCount)
    }
}
