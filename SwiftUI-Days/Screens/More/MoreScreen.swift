//
//  MoreScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 24.03.2024.
//

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
                        Group {
                            appThemePicker
                            appDataButton
                            feedbackButton
                            rateAppButton
                            shareAppButton
                            githubButton
                        }
                        .buttonStyle(.borderedProminent)
                        .foregroundStyle(.buttonTint)
                        appVersionText
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("More")
        }
    }

    private var appThemePicker: some View {
        Menu {
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
        } label: {
            Text("App theme")
        }
        .accessibilityIdentifier("appThemeButton")
    }

    private var appDataButton: some View {
        NavigationLink("App data", destination: AppDataScreen())
            .accessibilityIdentifier("appDataButton")
    }

    private var feedbackButton: some View {
        Button("Send feedback", action: FeedbackSender.sendFeedback)
            .accessibilityIdentifier("sendFeedbackButton")
    }

    @ViewBuilder
    private var rateAppButton: some View {
        if let appReviewLink = URL(string: "https://apps.apple.com/app/\(appId)?action=write-review") {
            Link("Rate the app", destination: appReviewLink)
                .accessibilityIdentifier("rateAppButton")
        }
    }

    @ViewBuilder
    private var shareAppButton: some View {
        let languageCode = locale.identifier.split(separator: "_").first == "ru" ? "ru" : "us"
        if let appStoreLink = URL(string: "https://apps.apple.com/\(languageCode)/app/\(appId)") {
            ShareLink(item: appStoreLink) {
                Text("Share the app")
            }
            .accessibilityIdentifier("shareAppButton")
        }
    }

    @ViewBuilder
    private var githubButton: some View {
        if let githubLink = URL(string: "https://github.com/easydev991/SwiftUI-Days") {
            Link("GitHub page", destination: githubLink)
                .accessibilityIdentifier("linkToGitHubPage")
        }
    }

    private var appVersionText: some View {
        Text("App version: \(appSettings.appVersion)")
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    MoreScreen()
        .environment(AppSettings())
}
