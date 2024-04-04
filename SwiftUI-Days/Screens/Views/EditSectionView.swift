//
//  EditSectionView.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 24.03.2024.
//

import SwiftUI

struct EditSectionView: View {
    let headerText: LocalizedStringKey
    let placeholder: LocalizedStringKey
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(headerText).font(.title3.bold())
                .accessibilityIdentifier("sectionHeader")
            TextField(placeholder, text: $text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...3)
                .accessibilityIdentifier("sectionTextField")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("editSectionView")
    }
}

#if DEBUG
#Preview {
    EditSectionView(
        headerText: "Title",
        placeholder: "Title for the Item",
        text: .constant("Событие, которое очень хочется запомнить, и никак нельзя забывать, например, первая поездка на велосипеде")
    )
}
#endif
