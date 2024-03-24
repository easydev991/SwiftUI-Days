//
//  MoreScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 24.03.2024.
//

import SwiftUI

struct MoreScreen: View {
    var body: some View {
        VStack(spacing: 12) {
            feedbackButton
        }
    }
    
    private var feedbackButton: some View {
        Button("Send feedback", action: FeedbackSender.sendFeedback)
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.buttonTint)
    }
}

#if DEBUG
#Preview {
    MoreScreen()
}
#endif
