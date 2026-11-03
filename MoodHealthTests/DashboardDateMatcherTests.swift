import XCTest
import Common
import DependencyInjection
import Queries
import Samples

final class DashboardDateMatcherTests: XCTestCase {
	override func setUp() {
		super.setUp()
		DependencyInjector.register([CommonInjectionProvider(), SamplesInjectionProvider()])
	}

	private func interval(_ start: TimeInterval, _ end: TimeInterval) -> Sleep {
		Sleep(.asleep, startDate: Date(timeIntervalSince1970: start), endDate: Date(timeIntervalSince1970: end))
	}

	private func ids(_ samples: [Sleep]) -> [ObjectIdentifier] { samples.map { ObjectIdentifier($0) } }

	func testEmptyReferencesNeverMatchIncludingMostRecentMode() throws {
		let target = interval(10, 20)
		for recent in [false, true] {
			let matchers: [SubQueryMatcher] = [SameDatesSubQueryMatcher(mostRecentOnly: recent),
				SameStartDatesSubQueryMatcher(mostRecentOnly: recent), SameEndDatesSubQueryMatcher(mostRecentOnly: recent)]
			for matcher in matchers {
				XCTAssertTrue(try matcher.getSamples(from: [target], matching: []).isEmpty)
				XCTAssertTrue(try matcher.getSamples(from: [Sleep](), matching: [target]).isEmpty)
			}
		}
	}

	func testMostRecentStartUsesLatestStartInEitherReferenceOrder() throws {
		let olderStart = interval(10, 100), newerStart = interval(20, 30)
		let olderTarget = interval(10, 100), newerTarget = interval(20, 30)
		let matchers: [SubQueryMatcher] = [SameDatesSubQueryMatcher(mostRecentOnly: true),
			SameStartDatesSubQueryMatcher(mostRecentOnly: true)]
		for matcher in matchers {
			for references in [[olderStart, newerStart], [newerStart, olderStart]] {
				let found = try matcher.getSamples(from: [olderTarget, newerTarget], matching: references)
				XCTAssertEqual(ids(found), ids([newerTarget]), "Latest start must not depend on input order or interval end")
			}
		}
	}

	func testMostRecentEndUsesLatestEndInEitherReferenceOrder() {
		let newerStart = interval(20, 30), newerEnd = interval(10, 100)
		let startTarget = interval(20, 30), endTarget = interval(10, 100)
		let matcher = SameEndDatesSubQueryMatcher(mostRecentOnly: true)
		for references in [[newerStart, newerEnd], [newerEnd, newerStart]] {
			XCTAssertEqual(ids(matcher.getSamples(from: [startTarget, endTarget], matching: references)), ids([endTarget]))
		}
	}

	func testAllReferenceModeKeepsResultOrderAndDoesNotDuplicateMatches() throws {
		let first = interval(10, 20), second = interval(30, 40), unrelated = interval(50, 60)
		let matchers: [SubQueryMatcher] = [SameDatesSubQueryMatcher(), SameStartDatesSubQueryMatcher(), SameEndDatesSubQueryMatcher()]
		for matcher in matchers {
			let found = try matcher.getSamples(from: [second, unrelated, first], matching: [first, second, first])
			XCTAssertEqual(ids(found), ids([second, first]))
		}
	}

	func testMostRecentStartTiesRetainTheFirstReferenceWithoutAnEndTieBreaker() {
		let short = interval(20, 30), long = interval(20, 100)
		let shortTarget = interval(20, 30), longTarget = interval(20, 100)
		let matcher = SameDatesSubQueryMatcher(mostRecentOnly: true)
		XCTAssertEqual(ids(matcher.getSamples(from: [shortTarget, longTarget], matching: [short, long])), ids([shortTarget]))
		XCTAssertEqual(ids(matcher.getSamples(from: [shortTarget, longTarget], matching: [long, short])), ids([longTarget]))
	}

	func testEachMatcherRetainsExactFractionalEndpointComparisons() {
		let reference = interval(10.25, 30.75)
		let exact = interval(10.25, 30.75), differentStart = interval(10.5, 30.75), differentEnd = interval(10.25, 30.875)
		let targets = [exact, differentStart, differentEnd]
		for recent in [false, true] {
			XCTAssertEqual(ids(SameDatesSubQueryMatcher(mostRecentOnly: recent).getSamples(from: targets, matching: [reference])), ids([exact]))
			XCTAssertEqual(ids(SameStartDatesSubQueryMatcher(mostRecentOnly: recent).getSamples(from: targets, matching: [reference])), ids([exact, differentEnd]))
			XCTAssertEqual(ids(SameEndDatesSubQueryMatcher(mostRecentOnly: recent).getSamples(from: targets, matching: [reference])), ids([exact, differentStart]))
		}
	}

	func testMissingEndUsesExistingCalendarOrderingAndMatchesOnlyMissingEnds() {
		let point = SexualActivity(Date(timeIntervalSince1970: 10))
		let finiteEnd = interval(20, 30)
		let target = SexualActivity(Date(timeIntervalSince1970: 99))
		let matcher = SameEndDatesSubQueryMatcher(mostRecentOnly: true)
		let referenceOrders: [[Sample]] = [[finiteEnd, point], [point, finiteEnd]]
		for references in referenceOrders {
			let found = matcher.getSamples(from: [target], matching: references)
			XCTAssertEqual(found.count, 1)
			XCTAssertTrue(found.first === target)
		}
		XCTAssertTrue(matcher.getSamples(from: [target], matching: [finiteEnd]).isEmpty)
	}

	func testFullDateMatcherDistinguishesPointRecordsFromIntervalsAtTheSameStart() {
		let at = Date(timeIntervalSince1970: 10.25)
		let matchingPoint = SexualActivity(at), otherPoint = SexualActivity(at.addingTimeInterval(0.25))
		let reference = SexualActivity(at), intervalReference = interval(10.25, 20)
		let matcher = SameDatesSubQueryMatcher()
		let found = matcher.getSamples(from: [otherPoint, matchingPoint], matching: [intervalReference, reference])
		XCTAssertEqual(found.count, 1)
		XCTAssertTrue(found.first === matchingPoint)
		XCTAssertTrue(matcher.getSamples(from: [matchingPoint], matching: [intervalReference]).isEmpty)
	}
}
