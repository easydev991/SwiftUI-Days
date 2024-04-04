//
//  DaysDeleteButton.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 23.03.2024.
//

import SwiftUI

struct DaysDeleteButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(
            "Delete",
            systemImage: "trash",
            role: .destructive,
            action: action
        )
        .accessibilityIdentifier("deleteButton")
    }
}

#if DEBUG
#Preview {
    DaysDeleteButton {}
}
#endif
