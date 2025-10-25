import SwiftUI

struct MoreScreen: View {
    @Environment(\.locale) private var locale
    @Environment(AppSettings.self) private var appSettings
    private let appId = "id6744068216"

    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    Spacer().containerRelativeFrame([.vertical])
                    VStack(spacing: 16) {
                        ViewThatFits(in: .horizontal) {
                            horizontalLayout
                            verticalLayout
                        }
                        .daysButtonStyle()
                        appVersionText
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle(.more)
        }
    }

    private var horizontalLayout: some View {
        HStack(spacing: 24) {
            VStack(alignment: .trailing, spacing: 16) {
                appThemeIconButton
                appDataButton
                feedbackButton
            }
            VStack(alignment: .leading, spacing: 16) {
                rateAppButton
                shareAppButton
                githubButton
            }
        }
    }

    private var verticalLayout: some View {
        VStack(spacing: 16) {
            appThemeIconButton
            appDataButton
            feedbackButton
            rateAppButton
            shareAppButton
            githubButton
        }
    }

    private var appThemeIconButton: some View {
        NavigationLink(.appThemeAndIcon) {
            ThemeIconScreen()
        }
        .accessibilityIdentifier("appThemeIconButton")
    }

    private var appDataButton: some View {
        NavigationLink(.appData) {
            AppDataScreen()
        }
        .accessibilityIdentifier("appDataButton")
    }

    private var feedbackButton: some View {
        Button(.sendFeedback, action: FeedbackSender.sendFeedback)
            .accessibilityIdentifier("sendFeedbackButton")
    }

    @ViewBuilder
    private var rateAppButton: some View {
        if let appReviewLink = URL(string: "https://apps.apple.com/app/\(appId)?action=write-review") {
            Link(.rateTheApp, destination: appReviewLink)
                .accessibilityIdentifier("rateAppButton")
        }
    }

    @ViewBuilder
    private var shareAppButton: some View {
        let languageCode = locale.identifier.split(separator: "_").first == "ru" ? "ru" : "us"
        if let appStoreLink = URL(string: "https://apps.apple.com/\(languageCode)/app/\(appId)") {
            ShareLink(item: appStoreLink) {
                Text(.shareTheApp)
            }
            .accessibilityIdentifier("shareAppButton")
        }
    }

    @ViewBuilder
    private var githubButton: some View {
        if let githubLink = URL(string: "https://github.com/easydev991/SwiftUI-Days") {
            Link(.gitHubPage, destination: githubLink)
                .accessibilityIdentifier("linkToGitHubPage")
        }
    }

    private var appVersionText: some View {
        Text(.appVersion(appSettings.appVersion))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    MoreScreen()
        .environment(AppSettings())
}
