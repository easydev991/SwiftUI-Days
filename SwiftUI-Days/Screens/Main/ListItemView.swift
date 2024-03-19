//
//  ListItemView.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

import SwiftUI

struct ListItemView: View {
    let item: Item
    
    var body: some View {
        HStack(spacing: 12) {
            Text(item.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(item.timestamp.description)
                .containerRelativeFrame(.horizontal) { length, _ in
                    length * 0.3
                }
        }
    }
}

#Preview {
    ListItemView(item: .single)
}
