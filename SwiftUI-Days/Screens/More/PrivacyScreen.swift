import SwiftUI

struct PrivacyScreen: View {
    @Environment(AppSettings.self) private var appSettings
    private var subtitle: String {
        appSettings.blurWhenMinimized
            ? String(localized: .blurredHint)
            : String(localized: .notBlurredHint)
    }

    var body: some View {
        VStack(spacing: 8) {
            @Bindable var settings = appSettings
            Toggle(.blurWhenMinimized, isOn: $settings.blurWhenMinimized)
            hintView
        }
        .padding()
        .navigationTitle(.privacy)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension PrivacyScreen {
    var hintView: some View {
        Text(subtitle)
            .animation(.default, value: appSettings.blurWhenMinimized)
            .font(.callout)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        PrivacyScreen()
    }
    .environment(AppSettings())
}
#endif
