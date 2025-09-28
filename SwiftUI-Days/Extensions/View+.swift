import SwiftUI

extension View {
    @ViewBuilder
    func daysButtonStyle() -> some View {
        if #available(iOS 26.0, *) {
            buttonStyle(.glassProminent)
                .foregroundStyle(.buttonTint)
        } else {
            buttonStyle(.borderedProminent)
                .foregroundStyle(.buttonTint)
        }
    }
}
