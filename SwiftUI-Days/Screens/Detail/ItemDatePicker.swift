import SwiftUI

struct ItemDatePicker: View {
    @Binding var date: Date

    var body: some View {
        DatePicker(
            .date,
            selection: $date,
            displayedComponents: .date
        )
        .bold()
    }
}

#Preview {
    ItemDatePicker(date: .constant(.now))
}
