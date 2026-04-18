import OSLog
import StoreKit
import SwiftUI

private struct ReviewRequestModifier: ViewModifier {
    @Environment(ReviewService.self) private var reviewService
    @Environment(\.requestReview) private var requestReview
    private let logger = Logger(subsystem: "SwiftUI-Days", category: "ReviewRequestModifier")

    func body(content: Content) -> some View {
        content
            .task(id: reviewService.pendingReviewRequest) {
                guard reviewService.pendingReviewRequest else { return }
                do {
                    try await Task.sleep(for: .seconds(0.8))
                } catch {
                    logger.info("Таск отменён во время ожидания — прерывание")
                    return
                }
                guard reviewService.pendingReviewRequest else {
                    logger.info("Проверка после ожидания — pendingReviewRequest = false")
                    return
                }
                requestReview()
                reviewService.markReviewRequested()
            }
    }
}

extension View {
    func reviewRequestHandling() -> some View {
        modifier(ReviewRequestModifier())
    }
}
