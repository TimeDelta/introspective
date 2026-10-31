import XCTest
import CoreData
import SwiftyMocky
@testable import Persistence
@testable import Samples
@testable import Settings

final class MoodRescalingUnitTests: UnitTest {
    private func emptyTransaction() -> TransactionMock {
        let transaction = TransactionMock()
        Given(mockDatabase, .transaction(willReturn: transaction))
        Given(transaction, .query(.any(NSFetchRequest<MoodImpl>.self), willReturn: []))
        return transaction
    }

    func testEmptyBatchCommitsExactlyOnce() throws {
        let transaction = emptyTransaction()
        try MoodUtilImpl().scaleMoods()
        Verify(transaction, .once, .commit())
    }

    func testFetchFailurePropagatesWithoutCommitting() {
        let transaction = TransactionMock()
        let failure = NSError(domain: "MoodRescaling", code: 1)
        Given(mockDatabase, .transaction(willReturn: transaction))
        Given(transaction, .query(.any(NSFetchRequest<MoodImpl>.self), willThrow: failure))
        XCTAssertThrowsError(try MoodUtilImpl().scaleMoods()) { error in
            XCTAssertEqual(error as NSError, failure)
        }
        Verify(transaction, .never, .commit())
    }

    func testCommitFailureStopsAfterTwoRetriesAndPreservesFirstError() {
        let transaction = emptyTransaction()
        let first = NSError(domain: "MoodRescaling", code: 1)
        let subsequent = NSError(domain: "MoodRescaling", code: 2)
        Given(transaction, .commit(willThrow: first, subsequent, subsequent))
        XCTAssertThrowsError(try MoodUtilImpl().scaleMoods()) { error in
            XCTAssertEqual(error as NSError, first)
        }
        Verify(transaction, .exactly(3), .commit())
    }

    func testSuccessfulRetryDoesNotCommitAgain() throws {
        let transaction = emptyTransaction()
        Given(transaction, .commit(willProduce: { stub in
            stub.throw(NSError(domain: "MoodRescaling", code: 1))
            stub.return(Void())
        }))
        try MoodUtilImpl().scaleMoods()
        Verify(transaction, .exactly(2), .commit())
    }
}

final class MoodRescalingFunctionalTests: FunctionalTest {
    private let util = MoodUtilImpl()

    private func setScale(min: Double, max: Double) throws {
        settings.setMinMood(min)
        settings.setMaxMood(max)
        try settings.save()
    }

    private func persisted(_ original: MoodImpl) throws -> MoodImpl {
        // Fetch with refresh enabled instead of relying on asynchronous context merging.
        try XCTUnwrap(database.query(MoodImpl.fetchRequest()).first { $0.objectID == original.objectID })
    }

    func testNegativeScaleEndpointsAndMidpointMapToPositiveScale() throws {
        let original = [-4.0, 0, 4].map { MoodDataTestUtil.createMood(rating: $0, min: -4, max: 4) }
        try setScale(min: 10, max: 20)
        try util.scaleMoods()
        for (mood, expected) in zip(original, [10.0, 15, 20]) {
            let saved = try persisted(mood)
            XCTAssertEqual(saved.rating, expected, accuracy: 0.000_001)
            XCTAssertEqual(saved.minRating, 10)
            XCTAssertEqual(saved.maxRating, 20)
        }
        XCTAssertEqual(try database.query(MoodImpl.fetchRequest()).count, 3)
    }

    func testFractionalRatingsAreNotRoundedWhenRescaling() throws {
        let original = MoodDataTestUtil.createMood(rating: -0.5, min: -2, max: 2)
        try setScale(min: 1, max: 7)
        try util.scaleMoods()
        let saved = try persisted(original)
        XCTAssertEqual(saved.rating, 3.25, accuracy: 0.000_001)
        XCTAssertEqual(saved.minRating, 1)
        XCTAssertEqual(saved.maxRating, 7)
    }

    func testBatchRescalingPreservesIdentityTimestampNoteTimeZoneAndHealthMetadata() throws {
        let timestamp = Date(timeIntervalSince1970: 1_700_000_000.123_456)
        let note = "  Calm 🧠\nafter a walk  "
        let original = MoodDataTestUtil.createMood(note: note, rating: 0, timestamp: timestamp,
                                                   min: -1, max: 1, source: .health)
        let metadata = database.transaction()
        let editing = try metadata.pull(savedObject: original)
        editing.timeZone = TimeZone(identifier: "America/New_York")
        editing.healthKitUUID = "original-health-sample"
        try metadata.commit()
        settings.setConvertTimeZones(false)
        try setScale(min: 0, max: 10)
        try util.scaleMoods()
        let saved = try persisted(original)
        XCTAssertEqual(saved.objectID, original.objectID)
        XCTAssertEqual(saved.rating, 5)
        XCTAssertEqual(saved.date, timestamp)
        XCTAssertEqual(saved.note, note)
        XCTAssertEqual(saved.timeZone?.identifier, "America/New_York")
        XCTAssertEqual(saved.getSource(), .health)
        XCTAssertEqual(saved.healthKitUUID, "original-health-sample")
        XCTAssertEqual(try database.query(MoodImpl.fetchRequest()).count, 1)
    }

    func testScalingOneMoodDoesNotSaveUntilItsTransactionCommits() throws {
        let original = MoodDataTestUtil.createMood(rating: 4, min: 0, max: 8)
        try setScale(min: 0, max: 10)
        let transaction = database.transaction()
        var editing: Mood = try transaction.pull(savedObject: original)
        util.scaleMood(&editing)
        XCTAssertEqual(editing.rating, 5)
        XCTAssertEqual(try persisted(original).rating, 4)
        try transaction.commit()
        let saved = try persisted(original)
        XCTAssertEqual(saved.rating, 5)
        XCTAssertEqual(saved.minRating, 0)
        XCTAssertEqual(saved.maxRating, 10)
    }

    func testRescalingEmptyStoreDoesNotCreateMoods() throws {
        try setScale(min: -5, max: 5)
        try util.scaleMoods()
        XCTAssertTrue(try database.query(MoodImpl.fetchRequest()).isEmpty)
    }

    func testIdentityScalePreservesFractionalRatingAndNilNote() throws {
        let original = MoodDataTestUtil.createMood(rating: 2.125, min: -3, max: 7)
        try setScale(min: -3, max: 7)
        try util.scaleMoods()
        let saved = try persisted(original)
        XCTAssertEqual(saved.rating, 2.125, accuracy: 0.000_001)
        XCTAssertNil(saved.note)
    }
}
