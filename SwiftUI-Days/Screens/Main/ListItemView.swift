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
            Text("\(item.daysCount)")
                .containerRelativeFrame(.horizontal, alignment: .trailing) { length, _ in
                    length * 0.3
                }
        }
    }
}

#if DEBUG
#Preview {
    ListItemView(item: .singleLong)
}
#endif
