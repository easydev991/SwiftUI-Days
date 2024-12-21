//
//  MoreScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 24.03.2024.
//

import SwiftUI
import SwiftData

struct MoreScreen: View {
    private let easyDevLink = URL(string: "https://t.me/easy_dev991")
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showDeleteDataConfirmation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    Spacer().containerRelativeFrame([ .vertical])
                    VStack(spacing: 16) {
                        Group {
                            feedbackButton
                            developerProfileButton
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
    
    @MainActor
    private var feedbackButton: some View {
        Button("Send feedback", action: FeedbackSender.sendFeedback)
            .accessibilityIdentifier("sendFeedbackButton")
    }
    
    @ViewBuilder
    private var developerProfileButton: some View {
        if let easyDevLink {
            Link(destination: easyDevLink) {
                Text("App Developer")
            }
            .accessibilityIdentifier("linkToDeveloperBlog")
        }
    }
    
    private var removeAllDataButton: some View {
        Button("Delete all data", role: .destructive) {
            showDeleteDataConfirmation.toggle()
        }
        .accessibilityIdentifier("removeAllDataButton")
        .transition(.slide.combined(with: .scale))
        .confirmationDialog(
            "Do you want to delete all data permanently?",
            isPresented: $showDeleteDataConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                try? modelContext.delete(model: Item.self)
            }
            .accessibilityIdentifier("confirmRemoveAllDataButton")
        }
    }
    
    private var appVersionText: some View {
        Text("App version: \((Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1")")
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }
}

#if DEBUG
#Preview {
    MoreScreen()
        .modelContainer(PreviewModelContainer.make(with: Item.makeList()))
}
#endif
