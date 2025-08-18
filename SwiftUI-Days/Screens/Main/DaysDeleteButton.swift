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

#Preview {
    DaysDeleteButton {}
}
