//
//  ReadSectionView.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 24.03.2024.
//

import SwiftUI

struct ReadSectionView: View {
    let headerText: String
    let bodyText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(headerText).font(.title3.bold())
            Text(bodyText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Много текста") {
    ReadSectionView(
        headerText: "Какое-то давнее событие из прошлого, которое хотим запомнить",
        bodyText: "Детали события, которые очень хочется запомнить, и никак нельзя забывать, например, первая поездка на велосипеде"
    )
}
