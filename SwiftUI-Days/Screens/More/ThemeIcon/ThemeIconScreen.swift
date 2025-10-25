import SwiftUI

struct ThemeIconScreen: View {
    @Environment(AppSettings.self) private var appSettings
    @State private var iconViewModel = IconViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                themePicker
                iconsGrid
                    .animation(.default, value: iconViewModel.currentAppIcon)
            }
            .padding()
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(.appThemeAndIcon)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var themePicker: some View {
        HStack(spacing: 12) {
            SectionTitleView(String(localized: .appTheme))
                .accessibilityHidden(true)
            Picker(
                .appTheme,
                selection: .init(
                    get: { appSettings.appTheme },
                    set: { appSettings.appTheme = $0 }
                )
            ) {
                ForEach(AppTheme.allCases) {
                    Text($0.title).tag($0)
                }
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityIdentifier("appThemePicker")
        }
    }

    private var iconsGrid: some View {
        VStack(spacing: 16) {
            SectionTitleView(String(localized: .appIcon))
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 65), spacing: 32, alignment: .leading)],
                spacing: 32
            ) {
                ForEach(IconVariant.allCases, id: \.self) { icon in
                    Button {
                        Task { await iconViewModel.setIcon(icon) }
                    } label: {
                        makeView(for: icon)
                    }
                    .accessibilityLabel(Text(icon.accessibilityLabel))
                }
            }
            .accessibilityIdentifier("appIconsGrid")
        }
    }

    private func makeView(for icon: ThemeIconScreen.IconVariant) -> some View {
        icon
            .listImage
            .resizable()
            .scaledToFit()
            .frame(width: 64, height: 64)
            .clipShape(.rect(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.iconBorder, lineWidth: 1)
            }
            .drawingGroup()
            .overlay(alignment: .topTrailing) {
                if icon == iconViewModel.currentAppIcon {
                    Image(.thumbCheckmark)
                        .offset(x: 6, y: -6)
                        .transition(.opacity.combined(with: .scale))
                        .accessibilityHidden(true)
                }
            }
    }
}

#Preview {
    NavigationStack {
        ThemeIconScreen()
    }
    .environment(AppSettings())
}
