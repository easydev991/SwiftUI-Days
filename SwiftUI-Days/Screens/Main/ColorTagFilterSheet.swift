import SwiftUI

struct ColorTagFilterSheet: View {
    let availableColors: [String]
    let selectedColorHex: String?
    let onApply: (String?) -> Void
    @Environment(\.analyticsService) private var analytics
    @Environment(\.dismiss) private var dismiss
    @State private var draftSelectedColorHex: String?
    private let colorGridColumns = [
        GridItem(.adaptive(minimum: 52, maximum: 60), spacing: 8)
    ]

    init(
        availableColors: [String],
        selectedColorHex: String?,
        onApply: @escaping (String?) -> Void
    ) {
        self.availableColors = availableColors
        self.selectedColorHex = selectedColorHex
        self.onApply = onApply
        _draftSelectedColorHex = State(initialValue: selectedColorHex)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVGrid(columns: colorGridColumns, spacing: 16) {
                        ForEach(availableColors, id: \.self, content: colorButton)
                    }
                    .padding()
                }
                .scrollBounceBehavior(.basedOnSize)
                HStack(spacing: 20) {
                    resetButton
                    applyButton
                }
                .controlSize(.large)
                .padding()
            }
            .animation(.default, value: draftSelectedColorHex)
            .navigationTitle(.filterByColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel(.close)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.automatic)
    }

    private var isApplyEnabled: Bool {
        currentState.isApplyEnabled
    }

    private var isResetEnabled: Bool {
        currentState.isResetEnabled
    }

    private var currentState: ColorTagFilterSheetState {
        ColorTagFilterSheetState(
            selectedColorHex: selectedColorHex,
            draftSelectedColorHex: draftSelectedColorHex
        )
    }

    private var resetButton: some View {
        Button(.reset) {
            analytics.log(.userAction(action: .resetFilter))
            switch currentState.resetResult() {
            case .applyNilAndDismiss:
                onApply(nil)
                dismiss()
            case .clearDraft:
                draftSelectedColorHex = nil
            }
        }
        .buttonStyle(.bordered)
        .disabled(!isResetEnabled)
        .accessibilityIdentifier("resetColorFilterButton")
    }

    private var applyButton: some View {
        Button(.apply) {
            analytics.log(.userAction(action: .applyFilter))
            onApply(draftSelectedColorHex)
            dismiss()
        }
        .buttonStyle(.borderedProminent)
        .daysButtonStyle()
        .disabled(!isApplyEnabled)
        .accessibilityIdentifier("applyColorFilterButton")
    }

    private func colorButton(colorHex: String) -> some View {
        let isSelected = draftSelectedColorHex == colorHex
        return Button {
            draftSelectedColorHex = currentState.toggledColorHex(colorHex)
        } label: {
            ZStack {
                Circle()
                    .fill(Color(hexRGBA: colorHex) ?? .clear)
                    .frame(width: 38, height: 38)
                if isSelected {
                    Circle()
                        .stroke(.accent, lineWidth: 3)
                        .frame(width: 48, height: 48)
                }
            }
            .animation(.default, value: isSelected)
            .frame(width: 52, height: 52)
            .contentShape(.circle)
        }
        .buttonStyle(.plain)
        .allowsHitTesting(!isSelected)
        .accessibilityIdentifier("colorFilterCell_\(colorHex)")
        .accessibilityLabel(Text(colorHex))
        .accessibilityAddTraits(draftSelectedColorHex == colorHex ? .isSelected : [])
    }
}

#if DEBUG
#Preview("ColorFilter 1") {
    let colors = ColorTagFilterSheetPreviewData.previewColorHexes(count: ColorTagFilterSheetPreviewData.colors1)
    ColorTagFilterSheet(
        availableColors: colors,
        selectedColorHex: nil
    ) { _ in }
}

#Preview("ColorFilter 3") {
    let colors = ColorTagFilterSheetPreviewData.previewColorHexes(count: ColorTagFilterSheetPreviewData.colors3)
    ColorTagFilterSheet(
        availableColors: colors,
        selectedColorHex: ColorTagFilterSheetPreviewData.getOrNil(colors, index: ColorTagFilterSheetPreviewData.selectedIndex3)
    ) { _ in }
}

#Preview("ColorFilter 8") {
    let colors = ColorTagFilterSheetPreviewData.previewColorHexes(count: ColorTagFilterSheetPreviewData.colors8)
    ColorTagFilterSheet(
        availableColors: colors,
        selectedColorHex: ColorTagFilterSheetPreviewData.getOrNil(colors, index: ColorTagFilterSheetPreviewData.selectedIndex8)
    ) { _ in }
}

#Preview("ColorFilter 30") {
    let colors = ColorTagFilterSheetPreviewData.previewColorHexes(count: ColorTagFilterSheetPreviewData.colors30)
    ColorTagFilterSheet(
        availableColors: colors,
        selectedColorHex: ColorTagFilterSheetPreviewData.getOrNil(colors, index: ColorTagFilterSheetPreviewData.selectedIndex30)
    ) { _ in }
}
#endif
