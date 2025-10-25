import SwiftUI

struct ItemDisplayOptionPicker: View {
    @Binding var displayOption: DisplayOption

    var body: some View {
        HStack(spacing: 12) {
            SectionTitleView(String(localized: .displayFormat))
                .accessibilityHidden(true)
            Picker(.displayFormat, selection: $displayOption) {
                ForEach(DisplayOption.allCases, id: \.self) { option in
                    Text(option.localizedTitle).tag(option)
                }
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityIdentifier("itemDisplayOptionPicker")
        }
    }
}

#Preview {
    @Previewable @State var option = DisplayOption.day
    ItemDisplayOptionPicker(displayOption: $option)
}
