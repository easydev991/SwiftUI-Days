import SwiftUI

struct MoreScreen: View {
    @Environment(\.locale) private var locale
    @Environment(\.analyticsService) private var analytics
    @Environment(AppSettings.self) private var appSettings
    private var isRunningOnMac: Bool {
        ProcessInfo.processInfo.isiOSAppOnMac
    }

    private let appId = "id6744068216"

    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    Spacer().containerRelativeFrame([.vertical])
                    VStack(spacing: 16) {
                        if isRunningOnMac {
                            verticalLayout
                        } else {
                            ViewThatFits(in: .horizontal) {
                                horizontalLayout
                                verticalLayout
                            }
                        }
                        appVersionText
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle(.more)
        }
        .trackScreen(.more)
    }

    private var horizontalLayout: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                VStack(alignment: .trailing, spacing: 16) {
                    appThemeIconButton
                    privacyButton
                    appDataButton
                }
                VStack(alignment: .leading, spacing: 16) {
                    feedbackButton
                    rateAppButton
                    shareAppButton
                }
            }
            githubButton
        }
        .daysButtonStyle()
    }

    private var verticalLayout: some View {
        VStack(spacing: 16) {
            appThemeIconButton
            privacyButton
            appDataButton
            feedbackButton
            rateAppButton
            shareAppButton
            githubButton
        }
        .daysButtonStyle()
    }

    @ViewBuilder
    private var appThemeIconButton: some View {
        if !isRunningOnMac {
            NavigationLink(.appThemeAndIcon) {
                ThemeIconScreen(analytics: analytics)
            }
            .accessibilityIdentifier("appThemeIconButton")
        }
    }

    private var appDataButton: some View {
        NavigationLink(.appData) {
            AppDataScreen()
        }
        .accessibilityIdentifier("appDataButton")
    }

    @ViewBuilder
    private var privacyButton: some View {
        if !isRunningOnMac {
            NavigationLink(.privacy) {
                PrivacyScreen()
            }
        }
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
                .accessibilityIdentifier("githubButton")
        }
    }

    private var appVersionText: some View {
        Text(.appVersion(appSettings.appVersion))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }
}

#if DEBUG
#Preview {
    MoreScreen()
        .environment(AppSettings())
}
#endif
