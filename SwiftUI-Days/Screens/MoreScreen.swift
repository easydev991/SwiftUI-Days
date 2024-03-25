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
        VStack(spacing: 20) {
            feedbackButton
            developerProfileButton
            if !items.isEmpty {
                removeAllDataButton
            }
        }
        .buttonStyle(.borderedProminent)
        .foregroundStyle(.buttonTint)
        .animation(.default, value: items.isEmpty)
    }
    
    private var feedbackButton: some View {
        Button("Send feedback", action: FeedbackSender.sendFeedback)
    }
    
    @ViewBuilder
    private var developerProfileButton: some View {
        if let easyDevLink {
            Link(destination: easyDevLink) {
                Text("App Developer")
            }
        }
    }
    
    private var removeAllDataButton: some View {
        Button("Delete all data") {
            showDeleteDataConfirmation.toggle()
        }
        .transition(.slide.combined(with: .scale))
        .confirmationDialog(
            "Do you want to delete all data permanently?",
            isPresented: $showDeleteDataConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                try? modelContext.delete(model: Item.self)
            }
        }
    }
}

#if DEBUG
#Preview {
    MoreScreen()
        .modelContainer(PreviewModelContainer.make(with: Item.makeList()))
}
#endif
