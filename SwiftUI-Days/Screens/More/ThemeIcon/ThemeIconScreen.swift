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
        .navigationTitle("App theme and Icon")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var themePicker: some View {
        HStack(spacing: 12) {
            Text("App theme")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityHidden(true)
            Picker(
                "App theme",
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
            Text("App Icon")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
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
            .frame(width: 65, height: 65)
            .clipShape(.rect(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
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
