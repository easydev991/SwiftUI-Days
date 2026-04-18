import Foundation
@testable import SwiftUI_Days
import Testing

@Suite("Тесты ReviewService")
struct ReviewServiceTests {
    private let defaults: UserDefaults
    private let suiteName: String

    init() {
        suiteName = "ReviewServiceTests-\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
    }

    @Test("Триггер review при сохранении первой записи")
    func testFirstMilestone() {
        let service = ReviewService(defaults: defaults)
        service.registerItemSaved()
        #expect(service.pendingReviewRequest)
    }

    @Test("Триггер review при сохранении пятой записи")
    func testMilestoneAfterFifthItem() {
        let s1 = ReviewService(defaults: defaults)
        s1.registerItemSaved()
        s1.markReviewRequested()

        let s2 = ReviewService(defaults: defaults)
        for _ in 0 ..< 3 {
            s2.registerItemSaved()
        }
        s2.registerItemSaved()
        #expect(s2.pendingReviewRequest)
    }

    @Test("Триггер review при сохранении пятнадцатой записи")
    func testMilestoneAfterFifteenthItem() {
        let s1 = ReviewService(defaults: defaults)
        s1.registerItemSaved()
        s1.markReviewRequested()

        let s2 = ReviewService(defaults: defaults)
        for _ in 0 ..< 4 {
            s2.registerItemSaved()
        }
        s2.markReviewRequested()

        let s3 = ReviewService(defaults: defaults)
        for _ in 0 ..< 9 {
            s3.registerItemSaved()
        }
        s3.registerItemSaved()
        #expect(s3.pendingReviewRequest)
    }

    @Test("Нет триггера review без сохранений")
    func testNoRequestWithoutMilestone() {
        let service = ReviewService(defaults: defaults)
        #expect(!service.pendingReviewRequest)
    }

    @Test("Повторный milestone не триггерит review")
    func testDuplicateMilestoneNotRequested() {
        let s1 = ReviewService(defaults: defaults)
        s1.registerItemSaved()
        s1.markReviewRequested()

        let s2 = ReviewService(defaults: defaults)
        s2.registerItemSaved()
        #expect(!s2.pendingReviewRequest)
    }

    @Test("Лимит одного запроса review за сессию")
    func testSessionLimitBlocksSecondRequest() {
        let service = ReviewService(defaults: defaults)
        service.registerItemSaved()
        service.markReviewRequested()
        service.registerItemSaved()
        #expect(!service.pendingReviewRequest)
    }

    @Test("markReviewRequested сбрасывает pending флаг")
    func testMarkReviewRequestedClearsPending() {
        let service = ReviewService(defaults: defaults)
        service.registerItemSaved()
        service.markReviewRequested()
        #expect(!service.pendingReviewRequest)
    }

    @Test("markReviewRequested сохраняет только триггерный milestone")
    func testMarkReviewRequestedStoresTriggeredMilestone() throws {
        let service = ReviewService(defaults: defaults)
        service.registerItemSaved()
        for _ in 0 ..< 4 {
            service.registerItemSaved()
        }
        service.markReviewRequested()
        let attempted = try #require(
            defaults.array(forKey: DefaultsKey.reviewAttemptedMilestones.rawValue) as? [Int]
        )
        #expect(attempted.contains(1))
        #expect(!attempted.contains(5))
    }
}
