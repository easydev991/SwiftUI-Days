//
//  EditSectionView.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 24.03.2024.
//

import SwiftUI

struct EditSectionView: View {
    let headerText: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(headerText).font(.title3.bold())
            TextField(placeholder, text: $text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    EditSectionView(
        headerText: "Заголовок",
        placeholder: "Введите название",
        text: .constant("Событие, которое очень хочется запомнить, и никак нельзя забывать, например, первая поездка на велосипеде")
    )
}
