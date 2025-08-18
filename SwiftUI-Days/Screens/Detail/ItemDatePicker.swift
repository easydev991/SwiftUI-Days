import SwiftUI

struct ItemDatePicker: View {
    @Binding var date: Date

    var body: some View {
        DatePicker(
            "Date",
            selection: $date,
            displayedComponents: .date
        )
        .font(.title3.bold())
    }
}

#Preview {
    ItemDatePicker(date: .constant(.now))
}
