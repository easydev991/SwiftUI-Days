import Foundation
import OSLog

@Observable final class ReviewService {
    private let defaults: UserDefaults
    private let milestones = [1, 5, 15]
    private(set) var pendingReviewRequest = false
    private var pendingMilestone: Int?

    private let logger = Logger(
        subsystem: "SwiftUI-Days",
        category: String(describing: ReviewService.self)
    )

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let totalCount = totalItemsCreatedCount
        let attempted = attemptedMilestones
        logger.info("Инициализация — создано записей: \(totalCount), пройденные milestone: \(attempted)")
    }

    var totalItemsCreatedCount: Int {
        get {
            access(keyPath: \.totalItemsCreatedCount)
            return defaults.integer(
                forKey: DefaultsKey.reviewTotalItemsCreated.rawValue
            )
        }
        set {
            withMutation(keyPath: \.totalItemsCreatedCount) {
                defaults.set(
                    newValue,
                    forKey: DefaultsKey.reviewTotalItemsCreated.rawValue
                )
            }
        }
    }

    func registerItemSaved() {
        totalItemsCreatedCount += 1

        guard !sessionReviewRequested else { return }
        let count = totalItemsCreatedCount
        guard let milestone = milestones.last(where: { $0 <= count }) else { return }
        guard !attemptedMilestones.contains(milestone) else { return }

        logger.info("Запрос review для milestone \(milestone) (записей: \(count))")
        sessionReviewRequested = true
        pendingMilestone = milestone
        pendingReviewRequest = true
    }

    func markReviewRequested() {
        if let milestone = pendingMilestone {
            var attempted = attemptedMilestones
            if !attempted.contains(milestone) {
                attempted.append(milestone)
                defaults.set(attempted, forKey: DefaultsKey.reviewAttemptedMilestones.rawValue)
                logger.info("Пройден milestone \(milestone), все пройденные: \(attempted)")
            }
        }
        pendingMilestone = nil
        pendingReviewRequest = false
    }

    func reset() {
        let totalCount = totalItemsCreatedCount
        let attempted = attemptedMilestones
        logger.info("Сброс счётчика review — было: создано \(totalCount), milestone \(attempted)")
        defaults.removeObject(forKey: DefaultsKey.reviewTotalItemsCreated.rawValue)
        defaults.removeObject(forKey: DefaultsKey.reviewAttemptedMilestones.rawValue)
        withMutation(keyPath: \.totalItemsCreatedCount) {}
        pendingReviewRequest = false
        pendingMilestone = nil
        sessionReviewRequested = false
    }

    private var sessionReviewRequested = false

    private var attemptedMilestones: [Int] {
        defaults.array(forKey: DefaultsKey.reviewAttemptedMilestones.rawValue) as? [Int] ?? []
    }
}
