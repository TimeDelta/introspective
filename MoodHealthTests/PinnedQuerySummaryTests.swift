import XCTest
import Foundation
import Common

final class PinnedQuerySummaryTests: XCTestCase {
	private let refreshed = Date(timeIntervalSince1970: 1_700_000_000.123456)
	private func record(_ rating: Double?, minimum: Double? = 0, maximum: Double? = 1) -> PinnedQuerySummaryRecord {
		PinnedQuerySummaryRecord(start: nil, rating: rating, minimum: minimum, maximum: maximum)
	}

	func testEmptyResultsHaveNoInventedDatesOrRatingMean() {
		let summary = PinnedQuerySummary(records: [], evaluatedAt: refreshed, includeRatings: true)
		XCTAssertEqual(summary.count, 0)
		XCTAssertNil(summary.earliestDate); XCTAssertNil(summary.latestDate)
		XCTAssertNil(summary.meanRatingPosition)
		XCTAssertEqual(summary.validRatingCount, 0); XCTAssertEqual(summary.excludedRatingCount, 0)
		XCTAssertEqual(summary.evaluatedAt, refreshed)
	}

	func testMixedHistoricalScalesUseIndependentNormalizedPositions() throws {
		let records = [record(1, maximum: 4), record(75, maximum: 100),
			record(-1, minimum: -2, maximum: 2), record(50, maximum: 100)]
		let summary = PinnedQuerySummary(records: records, evaluatedAt: refreshed, includeRatings: true)
		// Positions are 1/4, 3/4, 1/4 and 1/2: 7/16, independent of raw scales.
		XCTAssertEqual(try XCTUnwrap(summary.meanRatingPosition), 7.0 / 16.0, accuracy: 1e-12)
		XCTAssertEqual(summary.count, 4); XCTAssertEqual(summary.validRatingCount, 4)
		XCTAssertEqual(summary.excludedRatingCount, 0)
		XCTAssertEqual(records[2].rating, -1); XCTAssertEqual(records[2].minimum, -2)
	}

	func testMeanWeightsMatchingRecordsRatherThanDaysOrScaleWidths() throws {
		let firstDay = refreshed.addingTimeInterval(-86_400)
		let records = [PinnedQuerySummaryRecord(start: firstDay, rating: 0, minimum: 0, maximum: 100)] +
			(0..<3).map { _ in PinnedQuerySummaryRecord(start: refreshed, rating: 1, minimum: 0, maximum: 1) }
		let summary = PinnedQuerySummary(records: records, evaluatedAt: refreshed, includeRatings: true)
		XCTAssertEqual(try XCTUnwrap(summary.meanRatingPosition), 0.75, accuracy: 1e-12)
		XCTAssertEqual(summary.validRatingCount, 4)
	}

	func testInvalidAndIncompleteRatingsAreExcludedWithoutDilutingTheMean() throws {
		let records = [record(0.2), record(.nan), record(.infinity), record(-.infinity),
			record(nil), record(0.5, minimum: nil), record(0.5, maximum: nil),
			record(-0.001), record(1.001), record(0.8)]
		let summary = PinnedQuerySummary(records: records, evaluatedAt: refreshed, includeRatings: true)
		XCTAssertEqual(summary.count, 10); XCTAssertEqual(summary.validRatingCount, 2)
		XCTAssertEqual(summary.excludedRatingCount, 8)
		XCTAssertEqual(try XCTUnwrap(summary.meanRatingPosition), 0.5, accuracy: 1e-12)
	}

	func testInvalidScalesAndOverflowingSpansHaveNoNumericFallback() {
		let huge = Double.greatestFiniteMagnitude
		let records = [record(0, maximum: 0), record(0, minimum: 1, maximum: 0),
			record(0, minimum: -.infinity), record(0, maximum: .infinity),
			record(0, minimum: .nan), record(0, maximum: .nan),
			record(0, minimum: -huge, maximum: huge)]
		let summary = PinnedQuerySummary(records: records, evaluatedAt: refreshed, includeRatings: true)
		XCTAssertEqual(summary.count, 7); XCTAssertEqual(summary.validRatingCount, 0)
		XCTAssertEqual(summary.excludedRatingCount, 7); XCTAssertNil(summary.meanRatingPosition)
	}

	func testVeryLargeFiniteScalesAndBothEndpointsStayFinite() throws {
		let records = [record(1.25e308, minimum: 1e308, maximum: 1.5e308),
			record(-1.25e308, minimum: -1.5e308, maximum: -1e308),
			record(-2, minimum: -2, maximum: 3), record(3, minimum: -2, maximum: 3)]
		let summary = PinnedQuerySummary(records: records, evaluatedAt: refreshed, includeRatings: true)
		XCTAssertEqual(summary.validRatingCount, 4); XCTAssertEqual(summary.excludedRatingCount, 0)
		XCTAssertEqual(try XCTUnwrap(summary.meanRatingPosition), 0.5, accuracy: 1e-12)
	}

	func testNonRatingQueriesNeverInventRatingCountsOrStatistics() {
		let summary = PinnedQuerySummary(records: [record(0.2), record(.nan), record(nil)],
			evaluatedAt: refreshed, includeRatings: false)
		XCTAssertEqual(summary.count, 3); XCTAssertEqual(summary.validRatingCount, 0)
		XCTAssertEqual(summary.excludedRatingCount, 0); XCTAssertNil(summary.meanRatingPosition)
	}

	func testMatchingDateBoundsIncludeBothEndpointsAcrossDisjointRecords() {
		let earlier = refreshed.addingTimeInterval(-10_000), later = refreshed.addingTimeInterval(10_000)
		let records = [PinnedQuerySummaryRecord(start: earlier, end: earlier.addingTimeInterval(10)),
			PinnedQuerySummaryRecord(start: later), PinnedQuerySummaryRecord(start: nil)]
		let summary = PinnedQuerySummary(records: records, evaluatedAt: refreshed, includeRatings: false)
		XCTAssertEqual(summary.count, 3)
		XCTAssertEqual(summary.earliestDate, earlier); XCTAssertEqual(summary.latestDate, later)
		XCTAssertEqual(summary.evaluatedAt, refreshed, "Evaluation time does not truncate future matching records")
	}

	func testEachDateEndpointIsValidatedIndependentlyAndEpochZeroIsARealDate() {
		let zero = Date(timeIntervalSinceReferenceDate: 0), later = Date(timeIntervalSinceReferenceDate: 100)
		let records = [PinnedQuerySummaryRecord(start: nil, end: later),
			PinnedQuerySummaryRecord(start: Date(timeIntervalSinceReferenceDate: .nan), end: zero),
			PinnedQuerySummaryRecord(start: zero, end: Date(timeIntervalSinceReferenceDate: .infinity)),
			PinnedQuerySummaryRecord(start: Date(timeIntervalSinceReferenceDate: -.infinity)),
			PinnedQuerySummaryRecord(start: nil)]
		let summary = PinnedQuerySummary(records: records, evaluatedAt: refreshed, includeRatings: false)
		XCTAssertEqual(summary.count, 5)
		XCTAssertEqual(summary.earliestDate, zero); XCTAssertEqual(summary.latestDate, later)
	}

	func testUnavailableDatesStayUnavailableAndDoNotExcludeValidRatings() throws {
		let records = [PinnedQuerySummaryRecord(start: nil, rating: 1, minimum: 0, maximum: 2),
			PinnedQuerySummaryRecord(start: Date(timeIntervalSinceReferenceDate: .nan), end: Date(timeIntervalSinceReferenceDate: .infinity))]
		let summary = PinnedQuerySummary(records: records, evaluatedAt: refreshed, includeRatings: true)
		XCTAssertNil(summary.earliestDate); XCTAssertNil(summary.latestDate)
		XCTAssertEqual(summary.count, 2); XCTAssertEqual(summary.validRatingCount, 1)
		XCTAssertEqual(summary.excludedRatingCount, 1)
		XCTAssertEqual(try XCTUnwrap(summary.meanRatingPosition), 0.5, accuracy: 1e-12)
	}

	func testBoundsRetainFractionalPrecisionWithoutRounding() {
		let earlier = Date(timeIntervalSince1970: 1_700_000_000.123456)
		let later = earlier.addingTimeInterval(0.000001)
		let summary = PinnedQuerySummary(records: [PinnedQuerySummaryRecord(start: later, end: earlier)],
			evaluatedAt: refreshed, includeRatings: false)
		XCTAssertEqual(summary.earliestDate, earlier); XCTAssertEqual(summary.latestDate, later)
		XCTAssertNotEqual(summary.earliestDate, summary.latestDate)
	}
}
