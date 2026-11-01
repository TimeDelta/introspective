import XCTest
import Attributes
import AttributeRestrictions
import BooleanAlgebra
import Common
@testable import Queries
import Samples

private final class ResultsSampleProbe: Sample {
	static let name = "Probe"
	static let attributes: [Attribute] = []
	static let dateAttributes: [DateType: DateAttribute] = [:]
	static let defaultDependentAttribute: Attribute = CommonSampleAttributes.timestamp
	static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp
	let attributedName = "Probe"
	let description = "Probe"
	let attributes: [Attribute]
	var storedValue: Any?
	var reads = 0
	var readError: Error?
	init(_ attribute: Attribute, _ value: Any?) { attributes = [attribute]; storedValue = value }
	func dates() -> [DateType: Date] { [:] }
	func value(of attribute: Attribute) throws -> Any? {
		reads += 1
		if let error = readError { throw error }
		return storedValue
	}
	func set(attribute: Attribute, to value: Any?) throws { storedValue = value }
}

final class ResultsSortTests: XCTestCase {
	private func snapshot(_ attribute: Attribute, _ values: [Any?], _ order: ComparisonResult = .orderedAscending) throws -> ResultsSortSnapshot {
		try ResultsSortSnapshot(samples: values.map { ResultsSampleProbe(attribute, $0) }, attribute: attribute, order: order)
	}

	func testAllSupportedSortTypesOrderValuesAndPreserveEqualEntries() throws {
		let cases: [(Attribute, Any, Any)] = [
			(IntegerAttribute(id: 0, name: "integer"), 1, 2),
			(DoubleAttribute(id: 0, name: "double"), 1.25, 2.5),
			(TextAttribute(id: 0, name: "text"), "a", "b"),
			(DateTimeAttribute(id: 0), Date(timeIntervalSince1970: 10), Date(timeIntervalSince1970: 20)),
			(DayOfWeekAttribute(id: 0), DayOfWeek.Monday, DayOfWeek.Friday),
			(TimeOfDayAttribute(id: 0), TimeOfDay("01:02:03")!, TimeOfDay("01:02:04")!),
			(DurationAttribute(id: 0), TimeDuration(60), TimeDuration(120)),
			(FrequencyAttribute(id: 0), Frequency(30, .hour)!, Frequency(1, .minute)!),
			(DosageAttribute(id: 0), Dosage(500, "mg"), Dosage(1, "g")),
		]
		for (attribute, low, high) in cases {
			let values: [Any?] = [high, nil, low, high, nil, low]
			XCTAssertEqual(try snapshot(attribute, values).sort(using: ResultsWork()), [1, 4, 2, 5, 0, 3], attribute.name)
			XCTAssertEqual(try snapshot(attribute, values, .orderedDescending).sort(using: ResultsWork()), [1, 4, 0, 3, 2, 5], attribute.name)
		}
	}

	func testIntegerSortingPreservesPrecisionBeyondDoubleRange() throws {
		let attribute = IntegerAttribute(id: 0, name: "integer")
		XCTAssertEqual(try snapshot(attribute, [9_007_199_254_740_993, 9_007_199_254_740_992, Int.min, Int.max])
			.sort(using: ResultsWork()), [2, 1, 0, 3])
	}

	func testNaNAndMissingValuesHaveStableOrderingInBothDirections() throws {
		let attribute = DoubleAttribute(id: 0, name: "double")
		let values: [Any?] = [Double.nan, Double.infinity, nil, -Double.infinity, 0.0, Double.nan]
		XCTAssertEqual(try snapshot(attribute, values).sort(using: ResultsWork()), [0, 2, 5, 3, 4, 1])
		XCTAssertEqual(try snapshot(attribute, values, .orderedDescending).sort(using: ResultsWork()), [0, 2, 5, 1, 4, 3])
	}

	func testProjectionReadsEachValueOnceAndSortingNeverReadsSamplesAgain() throws {
		let attribute = IntegerAttribute(id: 0, name: "integer")
		let samples = (0..<1024).reversed().map { ResultsSampleProbe(attribute, $0) }
		let projected = try ResultsSortSnapshot(samples: samples, attribute: attribute, order: .orderedAscending)
		XCTAssertTrue(samples.allSatisfy { $0.reads == 1 })
		for sample in samples { sample.readError = GenericError("Worker accessed live sample") }
		XCTAssertEqual(try projected.sort(using: ResultsWork()), Array((0..<1024).reversed()))
		XCTAssertTrue(samples.allSatisfy { $0.reads == 1 })
	}

	func testMutableSortValuesAreCopiedBeforeWorkerRuns() throws {
		let early = TimeOfDay("01:02:03")!
		let late = TimeOfDay("01:02:04")!
		let dosage = Dosage(500, "mg")
		let frequency = Frequency(30, .hour)!
		let times = try snapshot(TimeOfDayAttribute(id: 0), [late, early])
		let doses = try snapshot(DosageAttribute(id: 0), [Dosage(1, "g"), dosage])
		let rates = try snapshot(FrequencyAttribute(id: 0), [Frequency(1, .minute)!, frequency])
		early.hour = 23; dosage.amount = 5000; frequency.timesPerTimeUnit = 600
		for projected in [times, doses, rates] {
			XCTAssertEqual(try projected.sort(using: ResultsWork()), [1, 0])
		}
	}

	func testCancelledWorkNeverReturnsAnOrder() throws {
		let work = ResultsWork()
		work.cancel()
		let projected = try snapshot(IntegerAttribute(id: 0, name: "integer"), [3, 1, 2])
		XCTAssertNil(try projected.sort(using: work))
	}

	func testUnsortedAndEmptyInputsPreserveOriginalIndicesWithoutReadingValues() throws {
		let sample = ResultsSampleProbe(IntegerAttribute(id: 0, name: "integer"), 1)
		sample.readError = GenericError("No sort was requested")
		let projected = try ResultsSortSnapshot(samples: [sample, sample], attribute: nil, order: .orderedDescending)
		XCTAssertEqual(try projected.sort(using: ResultsWork()), [0, 1])
		XCTAssertEqual(sample.reads, 0)
		let work = ResultsWork(); work.cancel()
		XCTAssertNil(try projected.sort(using: work))
		XCTAssertEqual(try snapshot(TextAttribute(id: 0, name: "text"), []).sort(using: ResultsWork()), [])
	}

	func testUnreadableAndUnsupportedAttributesFailWithoutPartialResults() throws {
		let attribute = IntegerAttribute(id: 0, name: "integer")
		let sample = ResultsSampleProbe(attribute, 1)
		sample.readError = GenericError("Unavailable value")
		XCTAssertThrowsError(try ResultsSortSnapshot(samples: [sample], attribute: attribute, order: .orderedAscending))
		XCTAssertThrowsError(try snapshot(BooleanAttribute(id: 0, name: "flag"), [true, false]))
	}
}

final class NearbyResultsTests: XCTestCase {
	private let start = Date(timeIntervalSince1970: 1_700_000_000)
	private func matches(_ query: Query, type: Sample.Type, start: Date, end: Date? = nil) throws -> Bool {
		let sample = AnySample(attributes: Array(type.dateAttributes.values))
		try sample.set(attribute: type.dateAttributes[.start]!, to: start)
		if let endAttribute = type.dateAttributes[.end] { try sample.set(attribute: endAttribute, to: end) }
		return try XCTUnwrap(query.expression).evaluate([.sample: sample])
	}

	func testTimestampSourceToTimestampQueryUsesStrictWindowBoundaries() throws {
		let query = MoodQueryImpl()
		try NearbyResultsQuery.configure(query, type: MoodImpl.self, dates: [.start: start], duration: TimeDuration(60))
		for offset in [-61.0, -60, 60, 61] {
			XCTAssertFalse(try matches(query, type: MoodImpl.self, start: start.addingTimeInterval(offset)))
		}
		for offset in [-59.0, 0, 59] {
			XCTAssertTrue(try matches(query, type: MoodImpl.self, start: start.addingTimeInterval(offset)))
		}
	}

	func testIntervalSourceExpandsBothEndpointsForTimestampTargets() throws {
		let query = MoodQueryImpl()
		try NearbyResultsQuery.configure(query, type: MoodImpl.self, dates: [.start: start, .end: start.addingTimeInterval(120)], duration: TimeDuration(60))
		XCTAssertTrue(try matches(query, type: MoodImpl.self, start: start.addingTimeInterval(179)))
		XCTAssertFalse(try matches(query, type: MoodImpl.self, start: start.addingTimeInterval(180)))
		XCTAssertFalse(try matches(query, type: MoodImpl.self, start: start.addingTimeInterval(-60)))
	}

	func testIntervalTargetsMustBeFullyContainedForBothSourceTypes() throws {
		for dates: [DateType: Date] in [[.start: start], [.start: start, .end: start.addingTimeInterval(120)]] {
			let query = ActivityQueryImpl()
			try NearbyResultsQuery.configure(query, type: Activity.self, dates: dates, duration: TimeDuration(60))
			let maximum = (dates[.end] ?? start).addingTimeInterval(60)
			XCTAssertTrue(try matches(query, type: Activity.self, start: start, end: maximum.addingTimeInterval(-1)))
			XCTAssertFalse(try matches(query, type: Activity.self, start: start.addingTimeInterval(-60), end: start))
			XCTAssertFalse(try matches(query, type: Activity.self, start: start, end: maximum))
			XCTAssertFalse(try matches(query, type: Activity.self, start: start.addingTimeInterval(-61), end: maximum.addingTimeInterval(1)))
			XCTAssertFalse(try matches(query, type: Activity.self, start: start))
		}
	}

	func testInvalidInputsCannotCreateAnUnrestrictedNearbyQuery() throws {
		for seconds in [-1.0, Double.nan, Double.infinity, -Double.infinity] {
			let query = MoodQueryImpl()
			XCTAssertThrowsError(try NearbyResultsQuery.configure(query, type: MoodImpl.self, dates: [.start: start], duration: TimeDuration(seconds)))
			XCTAssertNil(query.expression)
		}
		for dates: [DateType: Date] in [[:], [.end: start], [.start: start, .end: start.addingTimeInterval(-1)], [.start: Date(timeIntervalSinceReferenceDate: .infinity)]] {
			XCTAssertThrowsError(try NearbyResultsQuery.configure(MoodQueryImpl(), type: MoodImpl.self, dates: dates, duration: TimeDuration(60)))
		}
		XCTAssertThrowsError(try NearbyResultsQuery.configure(MoodQueryImpl(), type: AnySample.self, dates: [.start: start], duration: TimeDuration(60)))
	}

	func testZeroDurationRetainsStrictContainmentSemantics() throws {
		let query = MoodQueryImpl()
		try NearbyResultsQuery.configure(query, type: MoodImpl.self, dates: [.start: start], duration: TimeDuration(0))
		XCTAssertFalse(try matches(query, type: MoodImpl.self, start: start))
		try NearbyResultsQuery.configure(query, type: MoodImpl.self, dates: [.start: start, .end: start.addingTimeInterval(120)], duration: TimeDuration(0))
		XCTAssertTrue(try matches(query, type: MoodImpl.self, start: start.addingTimeInterval(60)))
	}
}

final class ResultsQuerySnapshotTests: XCTestCase {
	func testRefreshCopiesNestedQueriesExpressionsAndMatcherConfiguration() throws {
		let factory = QueryFactoryImpl()
		let original = MoodQueryImpl()
		let restriction = AfterDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: Date(timeIntervalSince1970: 100))
		original.expression = restriction
		original.mostRecentEntryOnly = true
		let nested = ActivityQueryImpl()
		nested.mostRecentEntryOnly = true
		let matcher = WithinXCalendarUnitsSubQueryMatcher(numberOfTimeUnits: 17, timeUnit: .hour, mostRecentOnly: true)
		original.subQuery = (matcher, nested)
		let copied = try ResultsQuerySnapshot.copy(original, using: factory)
		XCTAssertFalse(copied === original)
		XCTAssertTrue(copied.equalTo(original))
		let copiedRestriction = try XCTUnwrap(copied.expression as? AfterDateAndTimeAttributeRestriction)
		let copiedSubQuery = try XCTUnwrap(copied.subQuery)
		let copiedMatcher = try XCTUnwrap(copiedSubQuery.matcher as? WithinXCalendarUnitsSubQueryMatcher)
		XCTAssertFalse(copiedSubQuery.query === nested)
		XCTAssertFalse(copiedMatcher === matcher)
		copiedRestriction.date = Date(timeIntervalSince1970: 200)
		copiedMatcher.numberOfTimeUnits = 42
		copiedSubQuery.query.mostRecentEntryOnly = false
		XCTAssertEqual(restriction.date, Date(timeIntervalSince1970: 100))
		XCTAssertEqual(matcher.numberOfTimeUnits, 17)
		XCTAssertTrue(nested.mostRecentEntryOnly)
	}

	func testRepeatedSnapshotsHaveIndependentExecutionAndConfiguration() throws {
		let original = MoodQueryImpl()
		let factory = QueryFactoryImpl()
		let first = try ResultsQuerySnapshot.copy(original, using: factory)
		let second = try ResultsQuerySnapshot.copy(original, using: factory)
		XCTAssertFalse(first === second)
		first.mostRecentEntryOnly = true
		XCTAssertFalse(second.mostRecentEntryOnly)
		XCTAssertFalse(original.mostRecentEntryOnly)
	}

	func testCyclicNestedQueriesAreRejectedWithoutRecursingForever() throws {
		let original = MoodQueryImpl()
		original.subQuery = (SameDatesSubQueryMatcher(), original)
		defer { original.subQuery = nil }
		XCTAssertThrowsError(try ResultsQuerySnapshot.copy(original, using: QueryFactoryImpl()))
	}
}
