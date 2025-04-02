//
//  MoreScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 24.03.2024.
//

import SwiftUI
import SwiftData

struct MoreScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettings.self) private var appSettings
    @Query private var items: [Item]
    @State private var showDeleteDataConfirmation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    Spacer().containerRelativeFrame([ .vertical])
                    VStack(spacing: 16) {
                        Group {
                            appThemePicker
                            feedbackButton
                            githubButton
                            if !items.isEmpty {
                                removeAllDataButton
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .foregroundStyle(.buttonTint)
                        appVersionText
                    }
                    .animation(.default, value: items.isEmpty)
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
    
    private var feedbackButton: some View {
        Button("Send feedback", action: FeedbackSender.sendFeedback)
            .accessibilityIdentifier("sendFeedbackButton")
    }
    
    @ViewBuilder
    private var githubButton: some View {
        if let easyDevLink = URL(string: "https://github.com/easydev991/SwiftUI-Days") {
            Link(destination: easyDevLink) {
                Text("GitHub page")
            }
            .accessibilityIdentifier("linkToGitHubPage")
        }
    }
    
    private var removeAllDataButton: some View {
        Button("Delete all data", role: .destructive) {
            showDeleteDataConfirmation.toggle()
        }
        .accessibilityIdentifier("removeAllDataButton")
        .transition(.slide.combined(with: .scale).combined(with: .opacity))
        .confirmationDialog(
            "Do you want to delete all data permanently?",
            isPresented: $showDeleteDataConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                do {
                    try modelContext.delete(model: Item.self)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
            .accessibilityIdentifier("confirmRemoveAllDataButton")
        }
    }
    
    private var appVersionText: some View {
        Text("App version: \(appSettings.appVersion)")
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }
}

#if DEBUG
#Preview {
    MoreScreen()
        .environment(AppSettings())
        .modelContainer(PreviewModelContainer.make(with: Item.makeList()))
}
#endif
