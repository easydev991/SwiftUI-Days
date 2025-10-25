import SwiftUI

struct DaysDeleteButton: View {
    let action: () -> Void

    var body: some View {
        Button(
            .delete,
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
