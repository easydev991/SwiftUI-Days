import SwiftUI

struct DaysEditButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("Edit", systemImage: "pencil")
        }
        .accessibilityIdentifier("editButton")
    }
}

#Preview {
    DaysEditButton {}
}
