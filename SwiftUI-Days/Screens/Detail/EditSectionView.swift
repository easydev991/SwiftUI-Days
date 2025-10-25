import SwiftUI

struct EditSectionView: View {
    let headerText: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitleView(headerText)
                .accessibilityHidden(true)
            TextField(placeholder, text: $text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1 ... 3)
                .accessibilityIdentifier("sectionTextField")
                .accessibilityLabel(Text(headerText))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("editSectionView")
    }
}

#Preview {
    EditSectionView(
        headerText: String(localized: "Title"),
        placeholder: String(localized: "Title for the Item"),
        text: .constant("Событие, которое очень хочется запомнить, и никак нельзя забывать, например, первая поездка на велосипеде")
    )
}
