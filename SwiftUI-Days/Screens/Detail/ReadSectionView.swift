import SwiftUI

struct ReadSectionView: View {
    let headerText: LocalizedStringKey
    let bodyText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitleView(headerText)
                .accessibilityIdentifier("sectionHeader")
            Text(bodyText)
                .accessibilityIdentifier("sectionBody")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityIdentifier("readSectionView")
    }
}

#Preview("Много текста (название)") {
    ReadSectionView(
        headerText: "Title",
        bodyText: "Событие, которое очень хочется запомнить, и никак нельзя забывать, например, первая поездка на велосипеде"
    )
}

#Preview("Много текста (детали)") {
    ReadSectionView(
        headerText: "Details",
        bodyText: "Детали события, которые очень хочется запомнить, и никак нельзя забывать, например, первая поездка на велосипеде"
    )
}
