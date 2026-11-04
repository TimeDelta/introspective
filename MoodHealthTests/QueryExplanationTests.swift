import XCTest
import Foundation
import HealthKit
import Attributes
import AttributeRestrictions
import BooleanAlgebra
import Common
import DependencyInjection
import Queries
import Samples

private final class ExplanationUnknownExpression: BooleanExpression {
	var description: String { XCTFail("Unsupported descriptions must not run"); return "" }
	func evaluate(_ parameters: [UserInfoKey: Any]?) throws -> Bool { XCTFail("Preview must not evaluate"); return false }
	func isValid() -> Bool { XCTFail("Preview must not invoke arbitrary validity checks"); return true }
	func copy() -> BooleanExpression { XCTFail("Preview must not copy an unknown tree"); return self }
	func equalTo(_ other: BooleanExpression) -> Bool { false }
	func predicate() -> NSPredicate? { XCTFail("Preview must not execute a predicate"); return nil }
}

final class QueryExplanationTests: XCTestCase {
	private let anchor = Date(timeIntervalSince1970: 1_700_000_000.123456)

	override func setUp() {
		super.setUp()
		DependencyInjector.register([CommonInjectionProvider()])
	}

	private func explain(_ expression: BooleanExpression? = nil) throws -> QueryExplanation {
		let query = MoodQueryImpl(); query.expression = expression
		return try QueryExplanationBuilder.explain(query: query, evaluatedAt: anchor, convertTimeZones: false)
	}

	func testNestedAndOrNotKeepsParenthesesAndStablePaths() throws {
		let low = LessThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 2)
		let high = GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 8)
		let note = ContainsStringAttributeRestriction(restrictedAttribute: MoodImpl.note, substring: "work")
		let explanation = try explain(AndExpression(BooleanExpressionGroup(OrExpression(low, high)), NotExpression(note)))
		let root = try XCTUnwrap(explanation.root)
		XCTAssertEqual(root.kind, .all); XCTAssertEqual(root.path, "q0/expression")
		XCTAssertEqual(root.children.map { $0.kind }, [.group, .not])
		XCTAssertEqual(root.children[0].children[0].kind, .any)
		XCTAssertEqual(root.children[0].children[0].children.map { $0.path }, ["q0/expression/0/0/0", "q0/expression/0/0/1"])
		XCTAssertEqual(root.children[1].children[0].path, "q0/expression/1/0")
		XCTAssertTrue(root.children[0].children[0].details.joined().contains("counted once"))
		XCTAssertTrue(explanation.notes.joined().contains("must not be added"))
	}

	func testNoRestrictionsIsDescribedWithoutExecutingOrInventingConditions() throws {
		let value = try explain()
		XCTAssertNil(value.root); XCTAssertNil(value.subquery)
		XCTAssertEqual(value.path, "q0"); XCTAssertEqual(value.sampleTypeName, "Mood")
	}

	func testAllNumericComparisonOperatorsRemainDistinct() throws {
		let restrictions: [AttributeRestriction] = [
			LessThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 3),
			LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 3),
			EqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 3),
			GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 3),
			GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 3),
			NotEqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 3),
		]
		let operators = ["is less than", "is at most", "equals", "is at least", "is greater than", "does not equal"]
		for (restriction, operation) in zip(restrictions, operators) {
			XCTAssertEqual(try explain(restriction).root?.text, "Mood Rating " + operation + " 3.0")
		}
	}

	func testMissingValuesAreNotReinterpretedAsZeroOrNegationOfMissing() throws {
		let empty = try explain(EmptyStringAttributeRestriction(restrictedAttribute: MoodImpl.note))
		let present = try explain(NotEmptyStringAttributeRestriction(restrictedAttribute: MoodImpl.note))
		XCTAssertTrue(empty.root!.details.joined().contains("missing value match"))
		XCTAssertTrue(present.root!.details.joined().contains("missing value does not match"))
		let negated = try explain(NotExpression(ContainsStringAttributeRestriction(restrictedAttribute: MoodImpl.note, substring: "x")))
		XCTAssertTrue(negated.root!.details.joined().contains("Missing values follow the actual query rules"))
		XCTAssertTrue(negated.notes.joined().contains("not assumed to be zero"))
	}

	func testAbsoluteDateTimeBoundariesAreExclusiveAndPreserveFractionalInstant() throws {
		let after = try explain(AfterDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: anchor)).root!
		let before = try explain(BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: anchor)).root!
		XCTAssertTrue(after.text.contains("Timestamp is strictly after"))
		XCTAssertTrue(before.text.contains("Timestamp is strictly before"))
		let fraction = Calendar.autoupdatingCurrent.component(.nanosecond, from: anchor)
		let fractionalText = String(format: ".%09d", fraction)
		XCTAssertTrue(after.text.contains(fractionalText)); XCTAssertTrue(before.text.contains(fractionalText))
		XCTAssertTrue(after.details.joined().contains("excluded"))
		XCTAssertFalse(after.text.contains(".123000000"), "Stored microseconds must not be falsely shown as millisecond-rounded")
	}

	func testDateOnlyBoundariesUseTheActualStoredValueRatherThanRenormalizingIt() throws {
		// Initializers accept a non-midnight date. The explanation must faithfully
		// show that actual boundary, rather than silently moving it to midnight.
		let after = try explain(AfterDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: anchor)).root!
		let before = try explain(BeforeDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: anchor)).root!
		XCTAssertTrue(after.text.contains("stored date boundary")); XCTAssertTrue(before.text.contains("stored date boundary"))
		XCTAssertTrue(after.details.joined().contains("whole seconds"))
		XCTAssertTrue(before.details.joined().contains("start of the selected day"))
	}

	func testCurrentCalendarPeriodAndRollingLookbackHaveDifferentInclusiveMeanings() throws {
		let current = try explain(InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, .day)).root!
		let rolling = try explain(InThePastXTimeUnitsDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, 7, .day)).root!
		XCTAssertTrue(current.text.contains("current day"))
		XCTAssertTrue(rolling.text.contains("past 7 days"))
		XCTAssertTrue(current.details.joined().contains("both boundaries are included"))
		XCTAssertTrue(rolling.details.joined().contains("rolling calendar lookback"))
		XCTAssertNotEqual(current.details, rolling.details)
	}

	func testTimeZoneSettingIsExplicitAndDoesNotRewriteQuery() throws {
		let query = MoodQueryImpl()
		let off = try QueryExplanationBuilder.explain(query: query, evaluatedAt: anchor, convertTimeZones: false)
		let on = try QueryExplanationBuilder.explain(query: query, evaluatedAt: anchor, convertTimeZones: true)
		XCTAssertTrue(off.notes.joined().contains("original record timestamps"))
		XCTAssertTrue(on.notes.joined().contains("converted record timestamps"))
		XCTAssertNil(query.expression); XCTAssertNil(query.subQuery)
	}

	func testHealthAndDurationUnitsAreShownWithoutFetchingHealthData() throws {
		let energy = ActiveEnergyQueryImpl()
		energy.expression = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: ActiveEnergy.energyBurned, value: 120)
		let description = try QueryExplanationBuilder.explain(query: energy, evaluatedAt: anchor, convertTimeZones: false)
		XCTAssertTrue(description.root!.text.contains("120.0 kcal"))
		XCTAssertTrue(description.notes.joined().contains("restricted read access"))
		XCTAssertTrue(description.notes.joined().contains("not an atomic snapshot"))
		let workout = WorkoutQueryImpl()
		workout.expression = GreaterThanDurationAttributeRestriction(restrictedAttribute: Workout.durationAttribute, value: TimeDuration(90))
		let duration = try QueryExplanationBuilder.explain(query: workout, evaluatedAt: anchor, convertTimeZones: false)
		XCTAssertTrue(duration.root!.text.contains("90.0 seconds"))
	}

	func testRootMostRecentRequestIsNotFalselyDescribedAsAnActiveFilter() throws {
		let query = MoodQueryImpl(); query.mostRecentEntryOnly = true
		let value = try QueryExplanationBuilder.explain(query: query, evaluatedAt: anchor, convertTimeZones: false)
		XCTAssertTrue(value.notes.joined().contains("does not apply that flag"))
	}

	func testAllSevenSupportedMatchersDescribeTheirActualEndpointsAndRecency() throws {
		let matchers: [SubQueryMatcher] = [
			WithinXCalendarUnitsSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .hour, mostRecentOnly: true),
			WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .hour),
			WithinXCalendarUnitsAfterSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .hour),
			InSameCalendarUnitSubQueryMatcher(timeUnit: .day), SameStartDatesSubQueryMatcher(),
			SameEndDatesSubQueryMatcher(mostRecentOnly: true), SameDatesSubQueryMatcher(),
		]
		let fragments = ["start or end", "strictly before a reference start", "strictly after a reference end", "end shares", "start timestamp equals", "latest end", "both equal"]
		for (matcher, fragment) in zip(matchers, fragments) {
			let query = MoodQueryImpl(); query.subQuery = (matcher, PainQueryImpl())
			let value = try QueryExplanationBuilder.explain(query: query, evaluatedAt: anchor, convertTimeZones: false)
			XCTAssertTrue(value.matcherDescription!.contains(fragment), value.matcherDescription!)
			XCTAssertEqual(value.subquery?.path, "q1"); XCTAssertEqual(value.subquery?.sampleTypeName, "Pain")
		}
	}

	func testNestedReferenceQueriesHaveDistinctStageAndExpressionPaths() throws {
		let first = MoodQueryImpl(), last = MoodQueryImpl()
		let second = PainQueryImpl()
		first.subQuery = (SameStartDatesSubQueryMatcher(), second)
		second.subQuery = (SameStartDatesSubQueryMatcher(), last)
		last.expression = EmptyStringAttributeRestriction(restrictedAttribute: MoodImpl.note)
		let value = try QueryExplanationBuilder.explain(query: first, evaluatedAt: anchor, convertTimeZones: false)
		XCTAssertEqual(value.subquery?.subquery?.path, "q2")
		XCTAssertEqual(value.subquery?.subquery?.root?.path, "q2/expression")
	}

	func testUnknownExpressionFailsClosedWithoutCallingItsMethods() {
		XCTAssertThrowsError(try explain(ExplanationUnknownExpression())) { XCTAssertTrue($0 is QueryExplanationError) }
	}

	func testIncompleteBooleanNodesFailInsteadOfForceUnwrapping() {
		let expressions: [BooleanExpression] = [AndExpression(), OrExpression(), NotExpression(), BooleanExpressionGroup()]
		for expression in expressions {
			XCTAssertThrowsError(try explain(expression))
		}
	}

	func testExpressionCyclesAndQueryCyclesFailWithoutRecursingForever() {
		let group = BooleanExpressionGroup(); group.subExpression = group
		defer { group.subExpression = nil }
		XCTAssertThrowsError(try explain(group))
		let query = MoodQueryImpl(); query.subQuery = (SameDatesSubQueryMatcher(), query)
		defer { query.subQuery = nil }
		XCTAssertThrowsError(try QueryExplanationBuilder.explain(query: query, evaluatedAt: anchor, convertTimeZones: false))
	}

	func testVeryDeepAndLargeTreesAreRejectedBeforeCopyOrEvaluation() {
		var deep: BooleanExpression = EmptyStringAttributeRestriction(restrictedAttribute: MoodImpl.note)
		for _ in 0..<65 { deep = BooleanExpressionGroup(deep) }
		XCTAssertThrowsError(try explain(deep))
		var broad: BooleanExpression = EmptyStringAttributeRestriction(restrictedAttribute: MoodImpl.note)
		for _ in 0..<11 { broad = AndExpression(broad, broad) }
		XCTAssertThrowsError(try explain(broad))
	}

	func testInvalidFiniteNumbersCalendarUnitsAndTimeOfDayFailSafely() {
		XCTAssertThrowsError(try explain(GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: .nan)))
		XCTAssertThrowsError(try explain(InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, .era)))
		XCTAssertThrowsError(try explain(InThePastXTimeUnitsDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, -1, .day)))
		let time = TimeOfDay(); time.hour = 24
		XCTAssertThrowsError(try explain(BeforeTimeOfDayAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, timeOfDay: time)))
		XCTAssertThrowsError(try explain(AfterDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: Date(timeIntervalSince1970: .infinity))))
	}

	func testWholeSecondTimeOfDayAndEmptyWeekdaySelectionAreExplained() throws {
		let time = TimeOfDay(); time.hour = 14; time.minute = 35; time.second = 17
		let before = try explain(BeforeTimeOfDayAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, timeOfDay: time)).root!
		XCTAssertTrue(before.text.contains("14:35:17"))
		XCTAssertTrue(before.details.joined().contains("ignore fractional seconds"))
		let weekdays = try explain(OnDayOfWeekAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp)).root!
		XCTAssertTrue(weekdays.text.contains("none of the weekdays"))
	}

	func testIncompleteTagAndForeignAttributeConditionsFailSafely() {
		let activity = ActivityQueryImpl()
		activity.expression = ActivityHasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute)
		XCTAssertThrowsError(try QueryExplanationBuilder.explain(query: activity, evaluatedAt: anchor, convertTimeZones: false))
		let foreign = DoubleAttribute(id: MoodImpl.rating.id, name: "Foreign Rating", variableName: "rating")
		XCTAssertThrowsError(try explain(EqualToDoubleAttributeRestriction(restrictedAttribute: foreign, value: 1)))
	}

	func testTextValuesAreQuotedAndNewlinesCannotMasqueradeAsExtraConditions() throws {
		let value = try explain(ContainsStringAttributeRestriction(restrictedAttribute: MoodImpl.note, substring: "x\nOR “all”"))
		XCTAssertFalse(value.root!.text.contains("\n"))
		XCTAssertTrue(value.root!.text.contains("\\nOR \\“all\\”"))
	}
}
