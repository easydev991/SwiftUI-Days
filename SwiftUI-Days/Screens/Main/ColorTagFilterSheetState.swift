struct ColorTagFilterSheetState {
    enum ResetResult: Equatable {
        case clearDraft
        case applyNilAndDismiss
    }

    let selectedColorHex: String?
    var draftSelectedColorHex: String?

    init(
        selectedColorHex: String?,
        draftSelectedColorHex: String? = nil
    ) {
        self.selectedColorHex = selectedColorHex
        self.draftSelectedColorHex = draftSelectedColorHex ?? selectedColorHex
    }

    var isApplyEnabled: Bool {
        draftSelectedColorHex != selectedColorHex
    }

    var isResetEnabled: Bool {
        selectedColorHex != nil || draftSelectedColorHex != nil
    }

    func toggledColorHex(_ colorHex: String) -> String? {
        draftSelectedColorHex == colorHex ? nil : colorHex
    }

    func resetResult() -> ResetResult {
        if selectedColorHex != nil {
            return .applyNilAndDismiss
        }
        return .clearDraft
    }
}
