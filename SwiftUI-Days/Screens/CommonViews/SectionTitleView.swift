import SwiftUI

struct SectionTitleView: View {
    @Environment(\.isEnabled) private var isEnabled
    private let title: LocalizedStringKey

    init(_ title: LocalizedStringKey) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .bold()
            .foregroundStyle(isEnabled ? .primary : .secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let titleStringKeys: [LocalizedStringKey] = [
        "Title",
        "Details",
        "Add color tag",
    ]
    VStack(spacing: 20) {
        ForEach(
            Array(zip(titleStringKeys.indices, titleStringKeys)),
            id: \.0
        ) { _, title in
            SectionTitleView(title)
            SectionTitleView(title)
                .disabled(true)
        }
    }
}
