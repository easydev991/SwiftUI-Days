//
//  ReadSectionView.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 24.03.2024.
//

import SwiftUI

struct ReadSectionView: View {
    let headerText: LocalizedStringKey
    let bodyText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(headerText).font(.title3.bold())
            Text(bodyText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
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
#endif
