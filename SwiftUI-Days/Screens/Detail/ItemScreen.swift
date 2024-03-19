//
//  ItemScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

import SwiftUI

struct ItemScreen: View {
    let item: Item
    
    var body: some View {
        VStack {
            LabeledContent {
                Text(item.title)
            } label: {
                Text("Title")
            }
            LabeledContent {
                Text(
                    item.timestamp,
                    format: Date.FormatStyle(
                        date: .numeric,
                        time: .standard
                    )
                )
            } label: {
                Text("Date")
            }
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ItemScreen(item: .single)
}
