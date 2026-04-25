import Foundation
@testable import SwiftUI_Days
import Testing

@Suite("Тесты ColorTagFilterSheetState")
struct ColorTagFilterSheetStateTests {
    @Test("Применить недоступно, когда черновик равен примененному фильтру")
    func applyDisabledWhenDraftEqualsSelected() {
        let stateWithColor = ColorTagFilterSheetState(
            selectedColorHex: "#11223344",
            draftSelectedColorHex: "#11223344"
        )
        let stateWithoutColor = ColorTagFilterSheetState(
            selectedColorHex: nil,
            draftSelectedColorHex: nil
        )

        #expect(!stateWithColor.isApplyEnabled)
        #expect(!stateWithoutColor.isApplyEnabled)
    }

    @Test("Применить доступно, когда черновик отличается от примененного фильтра")
    func applyEnabledWhenDraftDiffers() {
        let state = ColorTagFilterSheetState(
            selectedColorHex: "#11223344",
            draftSelectedColorHex: "#AABBCCDD"
        )

        #expect(state.isApplyEnabled)
    }

    @Test("Сброс доступен, когда есть примененный или черновой фильтр")
    func resetEnabledWhenAnyFilterExists() {
        let appliedState = ColorTagFilterSheetState(
            selectedColorHex: "#11223344",
            draftSelectedColorHex: "#11223344"
        )
        let draftOnlyState = ColorTagFilterSheetState(
            selectedColorHex: nil,
            draftSelectedColorHex: "#AABBCCDD"
        )
        let emptyState = ColorTagFilterSheetState(
            selectedColorHex: nil,
            draftSelectedColorHex: nil
        )

        #expect(appliedState.isResetEnabled)
        #expect(draftOnlyState.isResetEnabled)
        #expect(!emptyState.isResetEnabled)
    }

    @Test("Тап по цвету переключает выбор и снимает его при повторном тапе")
    func toggleColorSelectsAndDeselects() {
        let state = ColorTagFilterSheetState(selectedColorHex: nil)

        let selectedColor = state.toggledColorHex("#11223344")
        #expect(selectedColor == "#11223344")

        let stateWithSelection = ColorTagFilterSheetState(
            selectedColorHex: nil,
            draftSelectedColorHex: "#11223344"
        )
        let deselectedColor = stateWithSelection.toggledColorHex("#11223344")
        #expect(deselectedColor == nil)
    }

    @Test("Сброс при активном примененном фильтре требует apply nil и dismiss")
    func resetWithAppliedFilterReturnsApplyNilAndDismiss() {
        let state = ColorTagFilterSheetState(
            selectedColorHex: "#11223344",
            draftSelectedColorHex: "#AABBCCDD"
        )

        let result = state.resetResult()

        #expect(result == .applyNilAndDismiss)
    }

    @Test("Сброс без примененного фильтра возвращает clearDraft")
    func resetWithoutAppliedFilterReturnsClearDraft() {
        let state = ColorTagFilterSheetState(
            selectedColorHex: nil,
            draftSelectedColorHex: "#AABBCCDD"
        )

        let result = state.resetResult()

        #expect(result == .clearDraft)
    }
}
