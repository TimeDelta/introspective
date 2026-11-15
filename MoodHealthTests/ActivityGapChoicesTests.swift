import XCTest
import Foundation
import Common

final class ActivityGapChoicesTests: XCTestCase {
	private let base = Date(timeIntervalSince1970: 1_720_915_200)
	private func at(_ seconds: TimeInterval) -> Date { base.addingTimeInterval(seconds) }
	private var interval: DateInterval { DateInterval(start: at(10.125), end: at(20.875)) }
	private func record(_ definition: String, _ start: TimeInterval, _ end: TimeInterval? = nil) -> ActivityReviewRecord {
		ActivityReviewRecord(id: UUID().uuidString, definitionID: definition, name: definition,
			start: at(start), end: end.map(at))
	}
	private func choices(_ records: [ActivityReviewRecord] = [], available: [String], recent: [String] = [],
		maximumRecent: Int = 5) throws -> ActivityGapChoices {
		try ActivityGapChoices(interval: interval, records: records, availableDefinitionIDs: available,
			recentDefinitionIDs: recent, asOf: at(100), maximumRecent: maximumRecent)
	}

	func testOnlyExactFractionalBoundariesProvideNeighborChoices() throws {
		let records = [record("before", -86400, 10.125), record("after", 20.875, 86400),
			record("too early", 0, 10.124), record("too late", 20.876, 30)]
		// Both neighbors may span the selected calendar day's boundary.
		let value = try ActivityGapChoices(interval: interval, records: records,
			availableDefinitionIDs: ["after", "before", "too early", "too late"], recentDefinitionIDs: [], asOf: at(90000))
		XCTAssertEqual(value.neighbors, [ActivityGapNeighbor(definitionID: "after", before: false, after: true),
			ActivityGapNeighbor(definitionID: "before", before: true, after: false)])
		XCTAssertEqual(records[0].end, at(10.125)); XCTAssertEqual(records[1].start, at(20.875))
		XCTAssertEqual(interval.duration, 10.75)
	}

	func testSameDefinitionOnBothSidesAppearsOnceWithBothContexts() throws {
		let value = try choices([record("work", 0, 10.125), record("work", 1, 10.125),
			record("work", 20.875, 30), record("music", 20.875, 40)],
			available: ["music", "work", "work"], recent: ["work", "music", "work"])
		XCTAssertEqual(value.neighbors, [ActivityGapNeighbor(definitionID: "music", before: false, after: true),
			ActivityGapNeighbor(definitionID: "work", before: true, after: true)])
		XCTAssertTrue(value.recentDefinitionIDs.isEmpty)
	}

	func testOverlappingBoundaryRecordsRetainEachAvailableDefinitionInItsDisplayOrder() throws {
		let records = [record("work", -10, 10.125), record("music", 0, 10.125),
			record("walk", 20.875, 40), record("deleted", 20.875, 30)]
		let value = try choices(records.reversed(), available: ["walk", "music", "work", "walk", ""])
		XCTAssertEqual(value.neighbors.map(\.definitionID), ["walk", "music", "work"])
		XCTAssertEqual(value.neighbors.map(\.before), [false, true, true])
		XCTAssertEqual(value.neighbors.map(\.after), [true, false, false])
	}

	func testRunningActivityCanProvideAfterContextWithoutInventingAnEnd() throws {
		let beforeRunning = record("running before", 0)
		let afterRunning = record("running after", 20.875)
		let value = try choices([beforeRunning, afterRunning], available: ["running before", "running after"])
		XCTAssertEqual(value.neighbors, [ActivityGapNeighbor(definitionID: "running after", before: false, after: true)])
		XCTAssertNil(beforeRunning.end); XCTAssertNil(afterRunning.end)
	}

	func testInvalidFutureAndNonpositiveRecordsDoNotSuggestActivities() throws {
		let records = [record("point", 10.125, 10.125), record("backwards", 20.875, 10.125),
			record("future end", 20.875, 101), record("future start", 101),
			record("nonfinite start", -.infinity, 10.125), record("nonfinite end", 20.875, .infinity),
			record("nan end", 20.875, .nan)]
		let value = try choices(records, available: records.map(\.definitionID))
		XCTAssertTrue(value.neighbors.isEmpty)
	}

	func testRecentChoicesPreserveRecencyDeduplicateAndExcludeUnavailableAndNeighborDefinitions() throws {
		let value = try choices([record("before", 0, 10.125)],
			available: ["before", "older", "newer", "third", "fourth", "fifth", "sixth", ""],
			recent: ["deleted", "newer", "before", "newer", "", "older", "third", "fourth", "fifth", "sixth"])
		XCTAssertEqual(value.recentDefinitionIDs, ["newer", "older", "third", "fourth", "fifth"])
		XCTAssertEqual(value.neighbors.map(\.definitionID), ["before"])
	}

	func testRecentLimitIsBoundedWithoutDroppingNeighborContext() throws {
		let records = [record("before", 0, 10.125)]
		let available = ["before", "a", "b", "c", "d", "e", "f"]
		let recent = ["a", "b", "c", "d", "e", "f"]
		XCTAssertEqual(try choices(records, available: available, recent: recent, maximumRecent: 2).recentDefinitionIDs, ["a", "b"])
		XCTAssertEqual(try choices(records, available: available, recent: recent, maximumRecent: .max).recentDefinitionIDs, ["a", "b", "c", "d", "e"])
		for limit in [0, -1, .min] {
			let value = try choices(records, available: available, recent: recent, maximumRecent: limit)
			XCTAssertTrue(value.recentDefinitionIDs.isEmpty)
			XCTAssertEqual(value.neighbors.map(\.definitionID), ["before"])
		}
	}

	func testInvalidIntervalsAndReferenceTimesAreRejected() {
		for gap in [DateInterval(start: at(10), end: at(10)), DateInterval(start: at(10), duration: .infinity),
			DateInterval(start: at(99), end: at(101))] {
			XCTAssertThrowsError(try ActivityGapChoices(interval: gap, records: [], availableDefinitionIDs: [],
				recentDefinitionIDs: [], asOf: at(100)))
		}
		for now in [Date(timeIntervalSince1970: .nan), Date(timeIntervalSince1970: .infinity)] {
			XCTAssertThrowsError(try ActivityGapChoices(interval: interval, records: [], availableDefinitionIDs: [],
				recentDefinitionIDs: [], asOf: now))
		}
	}

	func testCurrentBoundaryRunningActivityIsAvailableWithoutFutureCoverage() throws {
		let running = record("just started", 20.875)
		let value = try ActivityGapChoices(interval: interval, records: [running],
			availableDefinitionIDs: ["just started"], recentDefinitionIDs: [], asOf: interval.end)
		XCTAssertEqual(value.neighbors, [ActivityGapNeighbor(definitionID: "just started", before: false, after: true)])
	}
}
