import XCTest
import SwiftyMocky
import CoreData
@testable import Attributes
@testable import Common
@testable import DependencyInjection
@testable import Queries
@testable import Samples

final class DirectionalCalendarMatcherUnitTests: UnitTest {
    private let instant = Date(timeIntervalSince1970: 1_700_000_000)

    func testAfterDefaultsAndAttributeRoundTrip() throws {
        let matcher = WithinXCalendarUnitsAfterSubQueryMatcher()
        XCTAssertEqual(try matcher.value(of: type(of: matcher).amountOfTime) as? Int, 5)
        XCTAssertEqual(try matcher.value(of: type(of: matcher).timeUnit) as? Calendar.Component, .minute)
        try matcher.set(attribute: type(of: matcher).amountOfTime, to: 9)
        try matcher.set(attribute: type(of: matcher).timeUnit, to: Calendar.Component.hour)
        try matcher.set(attribute: CommonSubQueryMatcherAttributes.mostRecentOnly, to: true)
        XCTAssertEqual(matcher.numberOfTimeUnits, 9)
        XCTAssertEqual(matcher.timeUnit, .hour)
        XCTAssertTrue(matcher.mostRecentOnly)
        XCTAssertTrue(matcher.description.contains("after most recent"))
    }

    func testBeforeDefaultsAndAttributeRoundTrip() throws {
        let matcher = WithinXCalendarUnitsBeforeSubQueryMatcher()
        XCTAssertEqual(try matcher.value(of: type(of: matcher).amountOfTime) as? Int, 5)
        try matcher.set(attribute: type(of: matcher).amountOfTime, to: 2)
        try matcher.set(attribute: type(of: matcher).timeUnit, to: Calendar.Component.day)
        try matcher.set(attribute: CommonSubQueryMatcherAttributes.mostRecentOnly, to: true)
        XCTAssertEqual(try matcher.value(of: type(of: matcher).timeUnit) as? Calendar.Component, .day)
        XCTAssertEqual(try matcher.value(of: CommonSubQueryMatcherAttributes.mostRecentOnly) as? Bool, true)
        XCTAssertTrue(matcher.description.contains("before most recent"))
    }

    func testWrongAttributeTypesAndUnknownAttributesAreRejected() {
        let after = WithinXCalendarUnitsAfterSubQueryMatcher()
        let before = WithinXCalendarUnitsBeforeSubQueryMatcher()
        for matcher in [after as SubQueryMatcher, before as SubQueryMatcher] {
            XCTAssertThrowsError(try matcher.set(attribute: WithinXCalendarUnitsAfterSubQueryMatcher.amountOfTime, to: "5"))
            XCTAssertThrowsError(try matcher.set(attribute: WithinXCalendarUnitsAfterSubQueryMatcher.timeUnit, to: "day"))
            XCTAssertThrowsError(try matcher.set(attribute: CommonSubQueryMatcherAttributes.mostRecentOnly, to: 1))
            XCTAssertThrowsError(try matcher.value(of: CommonSampleAttributes.startDate))
            XCTAssertThrowsError(try matcher.set(attribute: CommonSampleAttributes.startDate, to: instant))
        }
    }

    func testEqualityIncludesDirectionWindowUnitAndMostRecentFlag() {
        let after = WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .day)
        XCTAssertEqual(after, WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .day))
        XCTAssertNotEqual(after, WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 3, timeUnit: .day))
        XCTAssertNotEqual(after, WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .hour))
        XCTAssertNotEqual(after, WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .day, mostRecentOnly: true))
        XCTAssertFalse(after.equalTo(WithinXCalendarUnitsBeforeSubQueryMatcher() as SubQueryMatcher))
        let before = WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .day)
        XCTAssertEqual(before, WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .day))
        XCTAssertNotEqual(before, WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .day, mostRecentOnly: true))
        XCTAssertFalse(before.equalTo(after as Attributed))
    }

    func testCalendarErrorsFailClosedInBothDirections() {
        Given(mockCalendarUtil, .distance(from: .any, to: .any, in: .any, willThrow: GenericError("calendar unavailable")))
        let reference = SampleCreatorTestUtil.createSample(startDate: instant)
        let after = SampleCreatorTestUtil.createSample(startDate: instant.addingTimeInterval(60))
        let before = SampleCreatorTestUtil.createSample(startDate: instant.addingTimeInterval(-60))
        XCTAssertTrue(WithinXCalendarUnitsAfterSubQueryMatcher().getSamples(from: [after], matching: [reference]).isEmpty)
        XCTAssertTrue(WithinXCalendarUnitsBeforeSubQueryMatcher().getSamples(from: [before], matching: [reference]).isEmpty)
    }

    func testNegativeCalendarSentinelCannotOverflowAbsoluteValue() {
        Given(mockCalendarUtil, .distance(from: .any, to: .any, in: .any, willReturn: Int.min))
        let reference = SampleCreatorTestUtil.createSample(startDate: instant)
        let after = SampleCreatorTestUtil.createSample(startDate: instant.addingTimeInterval(60))
        let before = SampleCreatorTestUtil.createSample(startDate: instant.addingTimeInterval(-60))
        XCTAssertTrue(WithinXCalendarUnitsAfterSubQueryMatcher().getSamples(from: [after], matching: [reference]).isEmpty)
        XCTAssertTrue(WithinXCalendarUnitsBeforeSubQueryMatcher().getSamples(from: [before], matching: [reference]).isEmpty)
    }

    func testEmptyAndUndatedInputsDoNotResolveCalendarDistance() throws {
        let undated = SampleCreatorTestUtil.createSampleWithoutDateAttribute(withAttributes: [])
        for matcher in [WithinXCalendarUnitsAfterSubQueryMatcher() as SubQueryMatcher,
                        WithinXCalendarUnitsBeforeSubQueryMatcher() as SubQueryMatcher] {
            XCTAssertTrue(try matcher.getSamples(from: [undated], matching: []).isEmpty)
            XCTAssertTrue(try matcher.getSamples(from: [undated], matching: [undated]).isEmpty)
        }
        Verify(mockCalendarUtil, .never, .distance(from: .any, to: .any, in: .any))
    }
}

final class DirectionalCalendarMatcherFunctionalTests: FunctionalTest {
    private let instant = Date(timeIntervalSince1970: 1_700_000_000)
    private func mood(_ seconds: Double) -> MoodImpl {
        MoodDataTestUtil.createMood(rating: 4, timestamp: instant.addingTimeInterval(seconds))
    }
    private func assertMoods(_ actual: [MoodImpl], _ expected: [MoodImpl], file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(actual.map { $0.objectID }, expected.map { $0.objectID }, file: file, line: line)
    }

    func testAfterUsesTheCorrectDirectionAndInclusiveWholeUnitLimit() {
        let anchor = mood(0), before = mood(-60), equal = mood(0), near = mood(60), edge = mood(300), far = mood(360)
        let matcher = WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 5, timeUnit: .minute)
        assertMoods(matcher.getSamples(from: [far, before, edge, equal, near], matching: [anchor]), [edge, near])
    }

    func testBeforeUsesTheCorrectDirectionAndInclusiveWholeUnitLimit() {
        let anchor = mood(0), before = mood(-60), equal = mood(0), edge = mood(-300), far = mood(-360), after = mood(60)
        let matcher = WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: 5, timeUnit: .minute)
        assertMoods(matcher.getSamples(from: [far, after, edge, equal, before], matching: [anchor]), [edge, before])
    }

    func testAfterFindsMatchesInUnsortedReferenceResults() {
        let first = mood(0), second = mood(3600), third = mood(7200)
        let a = mood(60), b = mood(3660), c = mood(7260), gap = mood(1800)
        let matcher = WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .minute)
        assertMoods(matcher.getSamples(from: [c, a, gap, b], matching: [third, first, second]), [c, a, b])
    }

    func testBeforeFindsMatchesInUnsortedReferenceResults() {
        let first = mood(0), second = mood(3600), third = mood(7200)
        let a = mood(-60), b = mood(3540), c = mood(7140), gap = mood(1800)
        let matcher = WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .minute)
        assertMoods(matcher.getSamples(from: [c, a, gap, b], matching: [third, first, second]), [c, a, b])
    }

    func testAfterChoosesTheNearestPastReferenceEvenWhenAFutureReferenceIsCloser() {
        let query = mood(120)
        assertMoods(WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .minute)
            .getSamples(from: [query], matching: [mood(121), mood(0)]), [query])
    }

    func testBeforeChoosesTheNearestFutureReferenceEvenWhenAPastReferenceIsCloser() {
        let query = mood(120)
        assertMoods(WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .minute)
            .getSamples(from: [query], matching: [mood(119), mood(240)]), [query])
    }

    func testAfterUsesTheEndOfAReferenceActivityAndExcludesOverlap() {
        let reference = ActivityDataTestUtil.createActivity(startDate: instant, endDate: instant.addingTimeInterval(600))
        let overlap = mood(300), equalEnd = mood(600), after = mood(660)
        assertMoods(WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .minute)
            .getSamples(from: [overlap, equalEnd, after], matching: [reference]), [after])
    }

    func testBeforeUsesTheEndOfAQueryActivityAndExcludesOverlap() {
        let reference = mood(600)
        let before = ActivityDataTestUtil.createActivity(startDate: instant, endDate: instant.addingTimeInterval(540))
        let overlap = ActivityDataTestUtil.createActivity(startDate: instant.addingTimeInterval(300), endDate: instant.addingTimeInterval(660))
        let result = WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .minute)
            .getSamples(from: [overlap, before], matching: [reference])
        XCTAssertEqual(result.map { $0.objectID }, [before.objectID])
    }

    func testAfterMostRecentOnlyUsesLatestStartRatherThanInputOrderOrLongestActivity() {
        let long = ActivityDataTestUtil.createActivity(startDate: instant, endDate: instant.addingTimeInterval(7200))
        let latest = ActivityDataTestUtil.createActivity(startDate: instant.addingTimeInterval(3600), endDate: instant.addingTimeInterval(3660))
        let nearLatest = mood(3720), nearLongEnd = mood(7260)
        assertMoods(WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .minute, mostRecentOnly: true)
            .getSamples(from: [nearLongEnd, nearLatest], matching: [latest, long]), [nearLatest])
    }

    func testBeforeMostRecentOnlyUsesLatestStartRegardlessOfInputOrder() {
        let old = mood(0), latest = mood(3600), nearOld = mood(-60), nearLatest = mood(3540)
        assertMoods(WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .minute, mostRecentOnly: true)
            .getSamples(from: [nearOld, nearLatest], matching: [latest, old]), [nearLatest])
    }

    func testFractionalSecondNeighborsHaveDirectionEvenWhenCalendarDistanceRoundsToZero() {
        let anchor = mood(0), after = mood(0.5), before = mood(-0.5)
        assertMoods(WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 1, timeUnit: .second)
            .getSamples(from: [before, after], matching: [anchor]), [after])
        assertMoods(WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: 1, timeUnit: .second)
            .getSamples(from: [before, after], matching: [anchor]), [before])
    }

    func testZeroAndNegativeWindowsNeverMatch() {
        let anchor = mood(0), neighbors = [mood(-60), mood(60)]
        for window in [0, -1, Int.min] {
            XCTAssertTrue(WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: window)
                .getSamples(from: neighbors, matching: [anchor]).isEmpty)
            XCTAssertTrue(WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: window)
                .getSamples(from: neighbors, matching: [anchor]).isEmpty)
        }
    }

    func testDuplicateReferencesDoNotDuplicateOrReorderQueryResults() {
        let anchor = mood(0), a = mood(60), b = mood(120)
        assertMoods(WithinXCalendarUnitsAfterSubQueryMatcher().getSamples(from: [b, a], matching: [anchor, anchor]), [b, a])
    }

    func testCalendarMonthWindowDoesNotAssumeThirtyDays() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let january = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 1, day: 1, hour: 12)))
        let february = try XCTUnwrap(calendar.date(byAdding: .month, value: 1, to: january))
        let anchor = MoodDataTestUtil.createMood(rating: 4, timestamp: january)
        let query = MoodDataTestUtil.createMood(rating: 4, timestamp: february)
        XCTAssertEqual(february.timeIntervalSince(january), 31 * 86400)
        assertMoods(WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 1, timeUnit: .month)
            .getSamples(from: [query], matching: [anchor]), [query])
    }
}
