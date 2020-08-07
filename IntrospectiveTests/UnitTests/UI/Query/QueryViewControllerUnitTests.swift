//
//  QueryViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import UIKit
import SwiftyMocky
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import BooleanAlgebra
@testable import Common
@testable import Queries
@testable import Samples

final class QueryViewControllerUnitTests: UnitTest {

	private typealias SampleTypeInfo = QueryViewControllerImpl.SampleTypeInfo

	private final var tableView: UITableView {
		return controller.tableView
	}

	private final var addPartButton: UIBarButtonItem!
	private final var editButton: UIBarButtonItem!
	private final var finishedButton: UIBarButtonItem!
	private final var toolbar: UIToolbar!

	private final var coachMarksController: CoachMarksControllerProtocolMock!

	private final let allTypes: [Sample.Type] = [HeartRate.self, MoodImpl.self]

	private var controller: QueryViewControllerImpl!

	override func setUp() {
		super.setUp()

		coachMarksController = CoachMarksControllerProtocolMock()
		Given(mockCoachMarkFactory, .controller(willReturn: coachMarksController))

		Given(mockSampleFactory, .allTypes(willReturn: allTypes))

		setValidation()

		addPartButton = UIBarButtonItem()
		editButton = UIBarButtonItem()
		finishedButton = UIBarButtonItem()
		toolbar = UIToolbar()

		let storyboard = UIStoryboard(name: "Query", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "queryView") as! QueryViewControllerImpl)

		controller.addPartButton = addPartButton
		controller.editButton = editButton
		controller.finishedButton = finishedButton
		controller.toolbar = toolbar
	}

	// MARK: - viewDidLoad()

	func testGivenInitialQuery_viewDidLoad_properlyPopulatesQueryParts() throws {
		// given
		let restriction1 = LessThanDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		let restriction2 = GreaterThanDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		let restriction3 = EqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		let restriction4 = NotEqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		let subQueryRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: Weight.weight)
		// ((1 || 2) && 3) || 4
		let mainExpression = OrExpression(
			BooleanExpressionGroup(
				AndExpression(
					BooleanExpressionGroup(OrExpression(
						restriction1,
						restriction2
					)),
					restriction3)),
			restriction4)
		let mainQuery = try HeartRateQueryMock(parts: [])
		Given(mainQuery, .expression(getter: mainExpression))
		let subQuery = try WeightQueryMock(parts: [])
		Given(subQuery, .expression(getter: subQueryRestriction))
		let matcher = SameDatesSubQueryMatcher(mostRecentOnly: false)
		Given(mainQuery, .subQuery(getter: (matcher: matcher, query: subQuery)))
		Given(subQuery, .subQuery(getter: nil))
		controller.initialQuery = mainQuery

		// when
		let _ = controller.view // gets called twice by calling controller.viewDidLoad()

		// then
		let expectedState = [ // ((1 || 2) && 3) || 4
			(sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: [
				(type: .groupStart, expression: nil),
				(type: .groupStart, expression: nil),
				(type: .expression, expression: restriction1),
				(type: .or, expression: nil),
				(type: .expression, expression: restriction2),
				(type: .groupEnd, expression: nil),
				(type: .and, expression: nil),
				(type: .expression, expression: restriction3),
				(type: .groupEnd, expression: nil),
				(type: .or, expression: nil),
				(type: .expression, expression: restriction4),
			] as [BooleanExpressionPart]),
			(sampleTypeInfo: SampleTypeInfo(Weight.self, matcher), parts: [
				(type: .expression, expression: subQueryRestriction),
			] as [BooleanExpressionPart])
		]
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenInitialQueryWithWithSubQueryButNoExpression_viewDidLoad_properlyPopulatesQueryParts() throws {
		// given
		let mainQuery = try HeartRateQueryMock(parts: [])
		Given(mainQuery, .expression(getter: nil))
		let subQuery = try WeightQueryMock(parts: [])
		Given(subQuery, .expression(getter: nil))
		let matcher = SameDatesSubQueryMatcher(mostRecentOnly: false)
		Given(mainQuery, .subQuery(getter: (matcher: matcher, query: subQuery)))
		Given(subQuery, .subQuery(getter: nil))
		controller.initialQuery = mainQuery

		// when
		let _ = controller.view // gets called twice by calling controller.viewDidLoad()

		// then
		assertThat(controller.queries, queriesEquals([
			(sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: []),
			(sampleTypeInfo: SampleTypeInfo(Weight.self), parts: []),
		]))
	}

	func testGivenInitialQuery_viewDidLoad_enablesFinishedButton() throws {
		// given
		let restriction = LessThanDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		let query = try HeartRateQueryMock(parts: [])
		Given(query, .expression(getter: restriction))
		controller.initialQuery = query
		controller.finishedButton.isEnabled = false

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.finishedButton, isEnabled())
	}

	func testGivenTopmostSampleType_viewDidLoad_correctlySetsTopmostSampleType() {
		// given
		let sampleType = Activity.self
		controller.topmostSampleType = sampleType

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.queries, queriesEquals([(sampleTypeInfo: SampleTypeInfo(sampleType), parts: [])]))
	}

	func testGivenNoInitialQueryOrTopmostSampleType_viewDidLoad_setsTopmostSampleTypeToDefault() {
		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.queries, queriesEquals([(sampleTypeInfo: SampleTypeInfo(allTypes[0]), parts: [])]))
	}

	func testGivenFinishedButtonTitle_viewDidLoad_correctlySetsTitleOfFinishedButton() {
		// given
		let expectedTitle = "hfuijewhbiuof"
		controller.finishedButtonTitle = expectedTitle

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.finishedButton, hasTitle(expectedTitle))
	}

	// MARK: - viewDidAppear()

	func testGivenQueryInstructionsAlreadyShown_viewDidAppear_doesNotShowInstructions() {
		// given
		Given(mockUserDefaultsUtil, .bool(forKey: .any, willReturn: true))

		// when
		controller.viewDidAppear(true)

		// then
		Verify(coachMarksController, .never, .start(in: .any))
	}

	func testGivenQueryInstructionsNotShown_viewDidAppear_showsInstructions() {
		// given
		Given(mockUserDefaultsUtil, .bool(forKey: .any, willReturn: false))

		// when
		controller.viewDidAppear(true)

		// then
		Verify(coachMarksController, .start(in: .any))
	}

	// MARK: - viewWillDisappear()

	func test_viewWillDisappear_immediatelyStopsCoachMarks() {
		// when
		controller.viewWillDisappear(true)

		// then
		Verify(coachMarksController, .stop(immediately: .value(true)))
	}

	// MARK: - numberOfSections()

	func testGivenOneMainQuery_numberOfSections_returns1() {
		// given
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [])]

		// when
		let sections = controller.numberOfSections(in: tableView)

		// then
		assertThat(sections, equalTo(1))
	}

	func testGivenOneMainQueryAndFourSubQueries_numberOfSections_returns5() {
		// given
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
		]

		// when
		let sections = controller.numberOfSections(in: tableView)

		// then
		assertThat(sections, equalTo(5))
	}

	// MARK: - tableViewNumberOfRowsInSection()

	func testGivenNoPartsInSpecifiedSection_tableViewNumberOfRowsInSection_returns1() {
		// given
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .or, expression: nil),
				(type: .or, expression: nil),
			]),
		]

		// when
		let rows = controller.tableView(tableView, numberOfRowsInSection: 0)

		// then
		assertThat(rows, equalTo(1))
	}

	func testGivenTwoPartsInSpecifiedSection_tableViewNumberOfRowsInSection_returns3() {
		// given
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .or, expression: nil),
				(type: .or, expression: nil),
			]),
		]

		// when
		let rows = controller.tableView(tableView, numberOfRowsInSection: 1)

		// then
		assertThat(rows, equalTo(3))
	}

	// MARK: - tableViewCellForRowAt()

	func testGivenSection0Row0_tableViewCellForRowAt_returnsCellWithTitleAsMainSampleTypeName() {
		// given
		let sampleType = MoodImpl.self
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(sampleType), parts: [])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

		// then
		assertThat(cell, hasText(sampleType.name))
	}

	func testGivenSection0Row0_tableViewCellForRowAt_returnsCellWithTextLabelAccessibilityValueAsMainSampleTypeName() {
		// given
		let sampleType = MoodImpl.self
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(sampleType), parts: [])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

		// then
		assertThat(cell.textLabel, hasAccessibilityValue(sampleType.name))
	}

	func testGivenSection0Row0WithTopmostSampleType_tableViewCellForRowAt_returnsCellWithUserInteractionDisabled() {
		// given
		controller.topmostSampleType = HeartRate.self
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

		// then
		assertThat(cell, not(userInteractionIsEnabled()))
	}

	func testGivenSection1Row0_tableViewCellForRowAt_returnsSubSampleTypeCellWithMatcherCorrectlySet() {
		// given
		let matcher = SameDatesSubQueryMatcher(mostRecentOnly: false)
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
			(sampleTypeInfo: SampleTypeInfo(HeartRate.self, matcher), parts: []),
		]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1))

		// then
		guard let subSampleTypeCell = cell as? SubSampleTypeTableViewCell else {
			XCTFail("Wrong type of cell")
			return
		}
		assertThat(subSampleTypeCell.matcher, equals(matcher))
	}

	func testGivenSection1Row0_tableViewCellForRowAt_returnsSubSampleTypeCellWithSampleTypeCorrectlySet() {
		// given
		let sampleType = BloodPressure.self
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
			(sampleTypeInfo: SampleTypeInfo(sampleType, mockSubQueryMatcher()), parts: []),
		]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1))

		// then
		guard let subSampleTypeCell = cell as? SubSampleTypeTableViewCell else {
			XCTFail("Wrong type of cell")
			return
		}
		assertThat(subSampleTypeCell.sampleType, equals(sampleType))
	}

	func testGivenAttributeRestrictionAtSpecifiedIndex_tableViewCellForRowAt_returnsAttributeRestrictionCellWithCorrectRestriction() {
		// given
		let expectedRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [
			(type: .expression, expression: expectedRestriction)
		])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))

		// then
		guard let restrictionCell = cell as? AttributeRestrictionTableViewCell else {
			XCTFail("Wrong type of cell")
			return
		}
		assertThat(restrictionCell.attributeRestriction, equals(expectedRestriction))
	}

	func testGivenAttributeRestrictionAtSpecifiedIndex_tableViewCellForRowAt_returnsCellWithCorrectIndentationLevel() {
		// given
		let expectedRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [
			(type: .groupStart, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .and, expression: nil),
			(type: .groupEnd, expression: nil),
			(type: .expression, expression: expectedRestriction),
		])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 6, section: 0))

		// then
		assertThat(cell, hasIndentationLevel(3))
	}

	func testGivenAndAtSpecifiedIndex_tableViewCellForRowAt_returnsAndCellWithCorrectText() {
		// given
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [
			(type: .and, expression: nil)
		])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))

		// then
		assertThat(cell, hasText("and"))
	}

	func testGivenAndAtSpecifiedIndex_tableViewCellForRowAt_returnsCellWithCorrectIndentationLevel() {
		// given
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [
			(type: .groupStart, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .or, expression: nil),
			(type: .groupEnd, expression: nil),
			(type: .and, expression: nil),
		])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 6, section: 0))

		// then
		assertThat(cell, hasIndentationLevel(3))
	}

	func testGivenOrAtSpecifiedIndex_tableViewCellForRowAt_returnsOrCellWithCorrectText() {
		// given
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [
			(type: .or, expression: nil)
		])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))

		// then
		assertThat(cell, hasText("or"))
	}

	func testGivenOrAtSpecifiedIndex_tableViewCellForRowAt_returnsCellWithCorrectIndentationLevel() {
		// given
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [
			(type: .groupStart, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .and, expression: nil),
			(type: .groupEnd, expression: nil),
			(type: .or, expression: nil),
		])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 6, section: 0))

		// then
		assertThat(cell, hasIndentationLevel(3))
	}

	func testGivenGroupStartAtSpecifiedIndex_tableViewCellForRowAt_returnsGroupStartCellWithCorrectText() {
		// given
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [
			(type: .groupStart, expression: nil)
		])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))

		// then
		assertThat(cell, hasText("("))
	}

	func testGivenGroupStartAtSpecifiedIndex_tableViewCellForRowAt_returnsCellWithCorrectIndentationLevel() {
		// given
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [
			(type: .groupStart, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .or, expression: nil),
			(type: .groupEnd, expression: nil),
			(type: .groupStart, expression: nil),
		])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 6, section: 0))

		// then
		assertThat(cell, hasIndentationLevel(3))
	}

	func testGivenGroupEndAtSpecifiedIndex_tableViewCellForRowAt_returnsGroupEndCellWithCorrectText() {
		// given
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [
			(type: .groupEnd, expression: nil)
		])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))

		// then
		assertThat(cell, hasText(")"))
	}

	func testGivenGroupEndAtSpecifiedIndex_tableViewCellForRowAt_returnsCellWithCorrectIndentationLevel() {
		// given
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [
			(type: .groupStart, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .or, expression: nil),
			(type: .groupEnd, expression: nil),
			(type: .groupEnd, expression: nil),
		])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 6, section: 0))

		// then
		assertThat(cell, hasIndentationLevel(2))
	}

	func testGivenGroupEndAtSpecifiedIndexWithRow1_tableViewCellForRowAt_returnsCellWithCorrectIndentationLevel() {
		// given
		controller.queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [
			(type: .groupEnd, expression: nil),
		])]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))

		// then
		assertThat(cell, hasIndentationLevel(1))
	}

	// MARK: - tableViewCanEditRowAt()

	func testGivenSection0Row0_tableViewCanEditRowAt_returnsFalse() {
		// given
		let indexPath = IndexPath(row: 0, section: 0)

		// when
		let canMove = controller.tableView(tableView, canEditRowAt: indexPath)

		// then
		XCTAssertFalse(canMove)
	}

	func testGivenSection0Row1_tableViewCanEditRowAt_returnsTrue() {
		// given
		let indexPath = IndexPath(row: 1, section: 0)

		// when
		let canMove = controller.tableView(tableView, canEditRowAt: indexPath)

		// then
		XCTAssert(canMove)
	}

	func testGivenSection1Row0_tableViewCanEditRowAt_returnsTrue() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)

		// when
		let canMove = controller.tableView(tableView, canEditRowAt: indexPath)

		// then
		XCTAssert(canMove)
	}

	// MARK: - tableViewCanMoveRowAt()

	func testGivenSection0Row0_tableViewCanMoveRowAt_returnsFalse() {
		// given
		let indexPath = IndexPath(row: 0, section: 0)

		// when
		let canMove = controller.tableView(tableView, canMoveRowAt: indexPath)

		// then
		XCTAssertFalse(canMove)
	}

	func testGivenSection0Row1_tableViewCanMoveRowAt_returnsTrue() {
		// given
		let indexPath = IndexPath(row: 1, section: 0)

		// when
		let canMove = controller.tableView(tableView, canMoveRowAt: indexPath)

		// then
		XCTAssert(canMove)
	}

	func testGivenSection1Row0_tableViewCanMoveRowAt_returnsTrue() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)

		// when
		let canMove = controller.tableView(tableView, canMoveRowAt: indexPath)

		// then
		XCTAssert(canMove)
	}

	// MARK: - tableViewMoveRowAt()

	func testGivenMoveMakesQueriesInvalid_tableViewMoveRowAt_disablesFinishedButton() {
		// given
		controller.finishedButton.isEnabled = true
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .and, expression: nil),
				(type: .or, expression: nil),
			] as [BooleanExpressionPart]),
		]
		setValidation(false)

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 1, section: 0), to: IndexPath(row: 2, section: 0))

		// then
		assertThat(controller.finishedButton, not(isEnabled()))
	}

	func testGivenMoveMakesQueriesValid_tableViewMoveRowAt_enablesFinishedButton() {
		// given
		controller.finishedButton.isEnabled = false
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .and, expression: nil),
				(type: .or, expression: nil),
			] as [BooleanExpressionPart]),
		]
		setValidation(true)

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 1, section: 0), to: IndexPath(row: 2, section: 0))

		// then
		assertThat(controller.finishedButton, isEnabled())
	}

	func testGivenMoveNonDataTypeToSection0Row0_tableViewMoveRowAt_doesNothing() {
		// given
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section1Parts))
		]
		controller.queries = copyArray(initialState)

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 1, section: 0), to: IndexPath(row: 0, section: 0))

		// then
		assertThat(controller.queries, queriesEquals(initialState))
	}

	// MARK: Move non-expression

	func testGivenMoveNonExpressionToHigherRowInSameSection_tableViewMoveRowAt_correctlyMoves() {
		// given
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
			(type: .or, expression: nil),
			(type: .groupStart, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section1Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				section1Parts[2],
				section1Parts[0],
				section1Parts[1],
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 3, section: 0), to: IndexPath(row: 1, section: 0))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveNonExpressionToLowerRowInSameSection_tableViewMoveRowAt_correctlyMoves() {
		// given
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
			(type: .or, expression: nil),
			(type: .groupStart, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section1Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				section1Parts[1],
				section1Parts[0],
				section1Parts[2],
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 1, section: 0), to: IndexPath(row: 3, section: 0))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveNonExpressionToHigherSection_tableViewMoveRowAt_correctlyMoves() {
		// given
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section2Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				section2Parts[0],
				section1Parts[0],
			]),
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 1, section: 1), to: IndexPath(row: 1, section: 0))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveNonExpressionToLowerSetion_tableViewMoveRowAt_correctlyMoves() {
		// given
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section2Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				section1Parts[0],
				section2Parts[0],
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 1, section: 0), to: IndexPath(row: 1, section: 1))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	// MARK: Move expression

	func testGivenMoveExpressionToHigherRowInSameSection_tableViewMoveRowAt_correctlyMoves() {
		// given
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("a")),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section1Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				section1Parts[2],
				section1Parts[0],
				section1Parts[1],
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 3, section: 0), to: IndexPath(row: 1, section: 0))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveExpressionToLowerRowInSameSection_tableViewMoveRowAt_correctlyMoves() {
		// given
		let section1Parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("a")),
			(type: .or, expression: nil),
			(type: .groupStart, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section1Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				section1Parts[1],
				section1Parts[0],
				section1Parts[2],
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 1, section: 0), to: IndexPath(row: 3, section: 0))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveExpressionToHigherSection_tableViewMoveRowAt_correctlyMoves() {
		// given
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section2Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				section2Parts[0],
				section1Parts[0],
			]),
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 1, section: 1), to: IndexPath(row: 1, section: 0))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveExpressionToLowerSection_tableViewMoveRowAt_correctlyMoves() {
		// given
		let section1Parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("a")),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("b")),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(section2Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				section1Parts[0],
				section2Parts[0],
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 1, section: 0), to: IndexPath(row: 1, section: 1))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveRestrictionToSectionForDifferentSampleTypeWithSameAttribute_tableViewMoveRowAt_keepsSameRestriction() {
		// given
		let restrictedAttribute = CommonSampleAttributes.healthKitTimestamp
		let restriction = LessThanIntegerAttributeRestriction(restrictedAttribute: restrictedAttribute)
		let section1Parts: [BooleanExpressionPart] = [
			(type: .expression, expression: restriction),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(Weight.self), parts: copyArray(section2Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: []),
			(sampleTypeInfo: SampleTypeInfo(Weight.self), parts: [
				section1Parts[0],
				section2Parts[0],
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 1, section: 0), to: IndexPath(row: 1, section: 1))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveRestrictionToSectionForDifferentSampleTypeWithoutSameAttribute_tableViewMoveRowAt_usesDefaultRestriction() {
		// given
		let restrictedAttribute = HeartRate.heartRate
		let restriction = AttributeRestrictionMock(restrictedAttribute: restrictedAttribute)
		Given(restriction, .restrictedAttribute(getter: restrictedAttribute))
		let section1Parts: [BooleanExpressionPart] = [
			(type: .expression, expression: restriction),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(Weight.self), parts: copyArray(section2Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedRestriction = mockDefaultAttributeRestrictionFor(Weight.self)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: []),
			(sampleTypeInfo: SampleTypeInfo(Weight.self), parts: [
				(type: .expression, expression: expectedRestriction),
				section2Parts[0],
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 1, section: 0), to: IndexPath(row: 1, section: 1))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	// MARK: Move data type

	func testGivenMoveDataTypeOrphansRestrictionToTypeWithoutSameAttribute_tableViewMoveRowAt_usesDefaultRestriction() {
		// given
		let restrictedAttribute = HeartRate.heartRate
		let restriction = mockAttributeRestrictionFor(restrictedAttribute: restrictedAttribute)
		Given(restriction, .equalTo(.any(BooleanExpression.self), willReturn: false))

		let section1Type = HeartRate.self
		let section2Type = Weight.self
		let section3Type = MoodImpl.self
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
		]
		let section3Parts: [BooleanExpressionPart] = [
			(type: .expression, expression: restriction),
		]

		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: copyArray(section2Parts)),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: copyArray(section3Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedRestriction = mockDefaultAttributeRestrictionFor(section2Type)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: []),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: section1Parts),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: [
				section2Parts[0],
				(type: .expression, expression: expectedRestriction),
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 2), to: IndexPath(row: 1, section: 0))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveDataTypeTakesOwnershipOfRestrictionOnAttributeItDoesNotHave_tableViewMoveRowAt_usesDefaultRestriction() {
		// given
		let restrictedAttribute = HeartRate.heartRate
		let restriction = mockAttributeRestrictionFor(restrictedAttribute: restrictedAttribute)
		Given(restriction, .equalTo(.any(BooleanExpression.self), willReturn: false))

		let section1Type = HeartRate.self
		let section2Type = Weight.self
		let section3Type = MoodImpl.self
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
		]
		let section3Parts: [BooleanExpressionPart] = [
			(type: .expression, expression: restriction),
		]

		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: copyArray(section2Parts)),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: copyArray(section3Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedRestriction = mockDefaultAttributeRestrictionFor(section2Type)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: [
				section1Parts[0],
				section2Parts[0],
			]),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: []),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: [
				(type: .expression, expression: expectedRestriction),
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 1), to: IndexPath(row: 1, section: 2))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveDataTypeToRow0OfAnotherSection_tableViewMoveRowAt_correctlyMoves() {
		// given
		let section1Type = HeartRate.self
		let section2Type = Weight.self
		let section3Type = MoodImpl.self
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
		]
		let section3Parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: copyArray(section2Parts)),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: copyArray(section3Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: []),
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: section1Parts),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: [
				section2Parts[0],
				section3Parts[0],
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 2), to: IndexPath(row: 0, section: 0))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveDataTypeToNonDataTypeRowInHigherSection_tableViewMoveRowAt_correctlyMoves() {
		// given
		let section1Type = HeartRate.self
		let section2Type = Weight.self
		let section3Type = MoodImpl.self
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
		]
		let section3Parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: copyArray(section2Parts)),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: copyArray(section3Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: []),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: section1Parts),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: [
				section2Parts[0],
				section3Parts[0],
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 2), to: IndexPath(row: 1, section: 0))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveDataTypeToNonDataTypeRowInLowerSection_tableViewMoveRowAt_correctlyMoves() {
		// given
		let section1Type = HeartRate.self
		let section2Type = Weight.self
		let section3Type = MoodImpl.self
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
		]
		let section3Parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: copyArray(section2Parts)),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: copyArray(section3Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: [
				section1Parts[0],
				section2Parts[0],
			]),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: []),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: [
				section3Parts[0],
			]),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 1), to: IndexPath(row: 1, section: 2))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveDataTypeToLowerRowInSameSection_tableViewMoveRowAt_correctlyMoves() {
		// given
		let section1Type = HeartRate.self
		let section2Type = Weight.self
		let section3Type = MoodImpl.self
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
			(type: .groupEnd, expression: nil),
		]
		let section3Parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: copyArray(section2Parts)),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: copyArray(section3Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: [
				section1Parts[0],
				section2Parts[0],
			]),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: [section2Parts[1]]),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: section3Parts),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 1), to: IndexPath(row: 1, section: 1))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveDataTypeToLowerRowInSameSectionOrphansRestrictionToTypeWithoutSameAttribute_tableViewMoveRowAt_usesDefaultRestriction() {
		// given
		let restrictedAttribute = Weight.weight
		let restriction = mockAttributeRestrictionFor(restrictedAttribute: restrictedAttribute)
		Given(restriction, .equalTo(.any(BooleanExpression.self), willReturn: false))

		let section1Type = HeartRate.self
		let section2Type = Weight.self
		let section3Type = MoodImpl.self
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .expression, expression: restriction),
			(type: .groupEnd, expression: nil),
		]
		let section3Parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: copyArray(section2Parts)),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: copyArray(section3Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedRestriction = mockDefaultAttributeRestrictionFor(section1Type)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: [
				section1Parts[0],
				(type: .expression, expression: expectedRestriction),
			]),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: [section2Parts[1]]),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: section3Parts),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 1), to: IndexPath(row: 1, section: 1))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenMoveDataTypeToLowerRowInSameSectionOrphansRestrictionToTypeWithSameAttribute_tableViewMoveRowAt_keepsSameRestriction() {
		// given
		let restrictedAttribute = HeartRate.heartRate
		let restriction = LessThanDoubleAttributeRestriction(restrictedAttribute: restrictedAttribute)

		let section1Type = HeartRate.self
		let section2Type = Weight.self
		let section3Type = MoodImpl.self
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .expression, expression: restriction),
			(type: .groupEnd, expression: nil),
		]
		let section3Parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: copyArray(section2Parts)),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: copyArray(section3Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: [
				section1Parts[0],
				section2Parts[0],
			]),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: [section2Parts[1]]),
			(sampleTypeInfo: SampleTypeInfo(section3Type), parts: section3Parts),
		]

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 1), to: IndexPath(row: 1, section: 1))

		// then
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	// MARK: - tableViewEditActionsForRowAt()

	func testGivenSection0Row0_tableViewEditActionsForRowAt_returnsNil() {
		// given
		let indexPath = IndexPath(row: 0, section: 0)

		// when
		let actions = controller.tableView(tableView, editActionsForRowAt: indexPath)

		// then
		assertThat(actions, nilValue())
	}

	func testGivenSection1Row0_tableViewEditActionsForRowAt_returnsDeleteActionThatCorrectlyDeletesThatRow() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)
		let section1Type = BodyMassIndex.self
		let section2Type = LeanBodyMass.self
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
			(type: .groupEnd, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: copyArray(section2Parts)),
		]
		controller.queries = copyArray(initialState)
		Given(mockUiUtil, .tableViewRowAction(style: .any, title: .any, handler: .any, willReturn: UITableViewRowAction()))

		// when
		let actions = controller.tableView(tableView, editActionsForRowAt: indexPath)
		let handlerCaptor = ArgumentCaptor<(UITableViewRowAction, IndexPath) -> Void>()
		Verify(mockUiUtil, .tableViewRowAction(style: .value(.destructive), title: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value else {
			XCTFail("handler was nil")
			return
		}
		handler(actions![0], indexPath)

		// then
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: [
				section1Parts[0],
				section2Parts[0],
				section2Parts[1],
			]),
		]
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenSection1Row0_tableViewEditActionsForRowAt_returnsDeleteActionThatUsesDefaultRestrictionForOrphanedRestrictions() {
		// given
		let restrictedAttribute = HeartRate.heartRate
		let restriction = LessThanDoubleAttributeRestriction(restrictedAttribute: restrictedAttribute)

		let indexPath = IndexPath(row: 0, section: 1)
		let section1Type = SexualActivity.self
		let section2Type = Sleep.self
		let section1Parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		let section2Parts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
			(type: .expression, expression: restriction),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: copyArray(section1Parts)),
			(sampleTypeInfo: SampleTypeInfo(section2Type), parts: copyArray(section2Parts)),
		]
		controller.queries = copyArray(initialState)
		let expectedRestriction = mockDefaultAttributeRestrictionFor(section1Type)
		Given(mockUiUtil, .tableViewRowAction(style: .any, title: .any, handler: .any, willReturn: UITableViewRowAction()))

		// when
		let actions = controller.tableView(tableView, editActionsForRowAt: indexPath)
		let handlerCaptor = ArgumentCaptor<(UITableViewRowAction, IndexPath) -> Void>()
		Verify(mockUiUtil, .tableViewRowAction(style: .value(.destructive), title: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value else {
			XCTFail("handler was nil")
			return
		}
		handler(actions![0], indexPath)

		// then
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(section1Type), parts: [
				section1Parts[0],
				section2Parts[0],
				(type: .expression, expression: expectedRestriction),
			]),
		]
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenSection1Row0_tableViewEditActionsForRowAt_returnsDeleteActionThatEnablesFinishedButtonWhenValid() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
		]
		controller.finishedButton.isEnabled = false
		setValidation(true)
		Given(mockUiUtil, .tableViewRowAction(style: .any, title: .any, handler: .any, willReturn: UITableViewRowAction()))

		// when
		let actions = controller.tableView(tableView, editActionsForRowAt: indexPath)
		let handlerCaptor = ArgumentCaptor<(UITableViewRowAction, IndexPath) -> Void>()
		Verify(mockUiUtil, .tableViewRowAction(style: .value(.destructive), title: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value else {
			XCTFail("handler was nil")
			return
		}
		handler(actions![0], indexPath)

		// then
		assertThat(controller.finishedButton, isEnabled())
	}

	func testGivenSection1Row0_tableViewEditActionsForRowAt_returnsDeleteActionThatDisablesFinishedButtonWhenInvalid() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
			(sampleTypeInfo: SampleTypeInfo(), parts: []),
		]
		controller.finishedButton.isEnabled = true
		setValidation(false)
		Given(mockUiUtil, .tableViewRowAction(style: .any, title: .any, handler: .any, willReturn: UITableViewRowAction()))

		// when
		let actions = controller.tableView(tableView, editActionsForRowAt: indexPath)
		let handlerCaptor = ArgumentCaptor<(UITableViewRowAction, IndexPath) -> Void>()
		Verify(mockUiUtil, .tableViewRowAction(style: .value(.destructive), title: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value else {
			XCTFail("handler was nil")
			return
		}
		handler(actions![0], indexPath)

		// then
		assertThat(controller.finishedButton, not(isEnabled()))
	}

	func testGivenSection0Row1_tableViewEditActionsForRowAt_returnsDeleteActionThatCorrectlyDeletes() {
		// given
		let indexPath = IndexPath(row: 1, section: 0)
		let sectionParts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
			(type: .or, expression: nil),
		]
		let initialState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: copyArray(sectionParts)),
		]
		controller.queries = copyArray(initialState)
		Given(mockUiUtil, .tableViewRowAction(style: .any, title: .any, handler: .any, willReturn: UITableViewRowAction()))

		// when
		let actions = controller.tableView(tableView, editActionsForRowAt: indexPath)
		let handlerCaptor = ArgumentCaptor<(UITableViewRowAction, IndexPath) -> Void>()
		Verify(mockUiUtil, .tableViewRowAction(style: .value(.destructive), title: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value else {
			XCTFail("handler was nil")
			return
		}
		handler(actions![0], indexPath)

		// then
		let expectedState = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				sectionParts[1],
			]),
		]
		assertThat(controller.queries, queriesEquals(expectedState))
	}

	func testGivenSection0Row1_tableViewEditActionsForRowAt_returnsDeleteActionThatEnablesFinishedButtonWhenValid() {
		// given
		let indexPath = IndexPath(row: 1, section: 0)
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .and, expression: nil),
				(type: .or, expression: nil),
			] as [BooleanExpressionPart]),
		]
		Given(mockUiUtil, .tableViewRowAction(style: .any, title: .any, handler: .any, willReturn: UITableViewRowAction()))
		controller.finishedButton.isEnabled = false
		setValidation(true)

		// when
		let actions = controller.tableView(tableView, editActionsForRowAt: indexPath)
		let handlerCaptor = ArgumentCaptor<(UITableViewRowAction, IndexPath) -> Void>()
		Verify(mockUiUtil, .tableViewRowAction(style: .value(.destructive), title: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value else {
			XCTFail("handler was nil")
			return
		}
		handler(actions![0], indexPath)

		// then
		assertThat(controller.finishedButton, isEnabled())
	}

	func testGivenSection0Row1_tableViewEditActionsForRowAt_returnsDeleteActionThatDisablesFinishedButtonWhenInvalid() {
		// given
		let indexPath = IndexPath(row: 1, section: 0)
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .and, expression: nil),
				(type: .or, expression: nil),
			] as [BooleanExpressionPart]),
		]
		Given(mockUiUtil, .tableViewRowAction(style: .any, title: .any, handler: .any, willReturn: UITableViewRowAction()))
		controller.finishedButton.isEnabled = true
		setValidation(false)

		// when
		let actions = controller.tableView(tableView, editActionsForRowAt: indexPath)
		let handlerCaptor = ArgumentCaptor<(UITableViewRowAction, IndexPath) -> Void>()
		Verify(mockUiUtil, .tableViewRowAction(style: .value(.destructive), title: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value else {
			XCTFail("handler was nil")
			return
		}
		handler(actions![0], indexPath)

		// then
		assertThat(controller.finishedButton, not(isEnabled()))
	}

	// MARK: - tableViewDidSelectRowAt()

	func testGivenSection0Row0_tableViewDidSelectRowAt_deselectsSelectedRow() {
		// given
		let indexPath = IndexPath(row: 0, section: 0)
		tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
		mockChooseSampleTypeViewController()

		// when
		controller.tableView(tableView, didSelectRowAt: indexPath)

		// then
		assertThat(tableView.indexPathForSelectedRow, nilValue())
	}

	func testGivenSection0Row0_tableViewDidSelectRowAt_setsSelectedSampleTypeOnPresentedController() {
		// given
		let sampleType = RestingHeartRate.self
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(sampleType), parts: []),
		]
		let presentedController = mockChooseSampleTypeViewController()

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

		// then
		assertThat(presentedController.selectedSampleType, equals(sampleType))
	}

	func testGivenSection0Row0_tableViewDidSelectRowAt_setsNotificationToSendOnAcceptForPresentedController() {
		// given
		let matcher = SameDatesSubQueryMatcher(mostRecentOnly: true)
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(MedicationDose.self, matcher), parts: []),
		]
		let presentedController = mockChooseSampleTypeViewController()

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

		// then
		assertThat(presentedController.notificationToSendOnAccept, equalTo(.sampleTypeEdited))
	}

	func testGivenNonAttributeRestrictionPartAtSelectedRow_tableViewDidSelectRowAt_showsExpressionPartTypesActionSheet() {
		// given
		let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
		Given(mockUiUtil, .alert(title: .any, message: .any, preferredStyle: .any, willReturn: alert))
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [(type: .or, expression: nil)] as [BooleanExpressionPart]),
		]
		mockAlertActions()

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 0))

		// then
		assertThat(alert.actions, hasItems(
			hasTitle("Attribute Restriction"),
			hasTitle("And"),
			hasTitle("Or"),
			hasTitle("Condition Group Start"),
			hasTitle("Condition Group End")))
		Verify(mockUiUtil, .present(.value(controller), .value(alert), animated: .any, completion: .any))
	}

	func testGivenUserChoosesAttributeRestrictionOnPresentedActionSheet_tableViewDidSelectRowAt_changesSelectedRowToAttributeRestriction() {
		// given
		let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
		Given(mockUiUtil, .alert(title: .any, message: .any, preferredStyle: .any, willReturn: alert))
		let sampleType: Sample.Type = MedicationDose.self
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(sampleType), parts: [
				(type: .and, expression: nil),
			] as [BooleanExpressionPart])
		]
		mockAlertActions()
		let restriction = mockDefaultAttributeRestrictionFor(sampleType)

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
		let handlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(mockUiUtil, .alertAction(title: "Attribute Restriction", style: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value as? (UIAlertAction) -> Void else {
			XCTFail("handler was nil")
			return
		}
		handler(UIAlertAction())

		// then
		assertThat(controller.queries, queriesEquals([
			(sampleTypeInfo: SampleTypeInfo(sampleType), parts: [
				(type: .expression, expression: restriction),
			] as [BooleanExpressionPart])]))
	}

	func testGivenUserChoosesOrOnPresentedActionSheet_tableViewDidSelectRowAt_changesSelectedRowToOr() {
		// given
		let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
		Given(mockUiUtil, .alert(title: .any, message: .any, preferredStyle: .any, willReturn: alert))
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .and, expression: nil),
			] as [BooleanExpressionPart])
		]
		mockAlertActions()

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
		let handlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(mockUiUtil, .alertAction(title: "Or", style: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value as? (UIAlertAction) -> Void else {
			XCTFail("handler was nil")
			return
		}
		handler(UIAlertAction())

		// then
		assertThat(controller.queries, queriesEquals([
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .or, expression: nil),
			] as [BooleanExpressionPart])]))
	}

	func testGivenUserChoosesAndOnPresentedActionSheet_tableViewDidSelectRowAt_changesSelectedRowToAnd() {
		// given
		let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
		Given(mockUiUtil, .alert(title: .any, message: .any, preferredStyle: .any, willReturn: alert))
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .or, expression: nil),
			] as [BooleanExpressionPart])
		]
		mockAlertActions()

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
		let handlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(mockUiUtil, .alertAction(title: "And", style: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value as? (UIAlertAction) -> Void else {
			XCTFail("handler was nil")
			return
		}
		handler(UIAlertAction())

		// then
		assertThat(controller.queries, queriesEquals([
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .and, expression: nil),
			] as [BooleanExpressionPart])]))
	}

	func testGivenUserChoosesGroupStartOnPresentedActionSheet_tableViewDidSelectRowAt_changesSelectedRowToGroupStart() {
		// given
		let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
		Given(mockUiUtil, .alert(title: .any, message: .any, preferredStyle: .any, willReturn: alert))
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .and, expression: nil),
			] as [BooleanExpressionPart])
		]
		mockAlertActions()

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
		let handlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(mockUiUtil, .alertAction(title: "Condition Group Start", style: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value as? (UIAlertAction) -> Void else {
			XCTFail("handler was nil")
			return
		}
		handler(UIAlertAction())

		// then
		assertThat(controller.queries, queriesEquals([
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .groupStart, expression: nil),
			] as [BooleanExpressionPart])]))
	}

	func testGivenUserChoosesGroupEndOnPresentedActionSheet_tableViewDidSelectRowAt_changesSelectedRowToGroupEnd() {
		// given
		let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
		Given(mockUiUtil, .alert(title: .any, message: .any, preferredStyle: .any, willReturn: alert))
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .and, expression: nil),
			] as [BooleanExpressionPart])
		]
		mockAlertActions()

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
		let handlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(mockUiUtil, .alertAction(title: "Condition Group End", style: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value as? (UIAlertAction) -> Void else {
			XCTFail("handler was nil")
			return
		}
		handler(UIAlertAction())

		// then
		assertThat(controller.queries, queriesEquals([
			(sampleTypeInfo: SampleTypeInfo(), parts: [
				(type: .groupEnd, expression: nil),
			] as [BooleanExpressionPart])]))
	}

	func testGivenUserChoosesOptionThatInvalidatesQuery_tableViewDidSelectRowAt_disablesFinishedButton() {
		// given
		let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
		Given(mockUiUtil, .alert(title: .any, message: .any, preferredStyle: .any, willReturn: alert))
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [(type: .and, expression: nil)] as [BooleanExpressionPart])
		]
		mockAlertActions()
		controller.finishedButton.isEnabled = true
		setValidation(false)

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
		let handlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(mockUiUtil, .alertAction(title: "Or", style: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value as? (UIAlertAction) -> Void else {
			XCTFail("handler was nil")
			return
		}
		handler(UIAlertAction())

		// then
		assertThat(controller.finishedButton, not(isEnabled()))
	}

	func testGivenUserChoosesOptionThatValidatesQuery_tableViewDidSelectRowAt_enablesFinishedButton() {
		// given
		let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
		Given(mockUiUtil, .alert(title: .any, message: .any, preferredStyle: .any, willReturn: alert))
		controller.queries = [
			(sampleTypeInfo: SampleTypeInfo(), parts: [(type: .and, expression: nil)] as [BooleanExpressionPart])
		]
		mockAlertActions()
		controller.finishedButton.isEnabled = false
		setValidation(true)

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
		let handlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(mockUiUtil, .alertAction(title: "Or", style: .any, handler: handlerCaptor.capture()))
		guard let handler = handlerCaptor.value as? (UIAlertAction) -> Void else {
			XCTFail("handler was nil")
			return
		}
		handler(UIAlertAction())

		// then
		assertThat(controller.finishedButton, isEnabled())
	}

	// MARK: - finishedButtonPressed()

	func testGivenFinishedButtonNotificationIsRunQuery_finishedButtonPressed_setsQueryOnPresentedController() {
		// given
		let sampleQuery = HeartRateQueryMock()
		Given(mockQueryFactory, .heartRateQuery(.any, willReturn: sampleQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()
		controller.queries[0] = (sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: [])

		let presentedController = mockResultsViewController()

		// when
		controller.finishedButtonPressed(finishedButton)

		// then
		assertThat(presentedController.query, sameObject(sampleQuery))
	}

	func testGivenHeartRateDataTypeWithNoRestrictionsOrSubQuery_finishedButtonPressed_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		Given(mockQueryFactory, .heartRateQuery(.any, willReturn: sampleQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()
		controller.queries[0] = (sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: [])

		mockResultsViewController()

		// when
		controller.finishedButtonPressed(finishedButton)

		// then
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}

	func testGivenHeartRateDataTypeWithOneAttributeRestrictionAndNoSubQuery_finishedButtonPressed_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		Given(mockQueryFactory, .heartRateQuery(.any, willReturn: sampleQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()

		let attributeRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		let queryParts: [BooleanExpressionPart] = [
			(type: .expression, expression: attributeRestriction),
		]
		controller.queries[0] = (sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: queryParts)

		mockResultsViewController()

		// when
		controller.finishedButtonPressed(finishedButton)

		// then
		Verify(mockQueryFactory, .heartRateQuery(.value(queryParts)))
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}

	func testGivenHeartRateDataTypeWithMultipleAttributeRestrictionsAndNoSubQuery_finishedButtonPressed_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		Given(mockQueryFactory, .heartRateQuery(.any, willReturn: sampleQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()

		let attributeRestriction1 = EqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		let attributeRestriction2 = NotEqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		let queryParts: [BooleanExpressionPart] = [
			(type: .expression, expression: attributeRestriction1),
			(type: .expression, expression: attributeRestriction2),
		]
		controller.queries[0] = (sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: queryParts)

		mockResultsViewController()

		// when
		controller.finishedButtonPressed(finishedButton)

		// then
		Verify(mockQueryFactory, .heartRateQuery(.value(queryParts)))
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}

	func testGivenHeartRateDataTypeWithMoodSubQueryAndNoAttributeRestrictions_finishedButtonPressed_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		Given(mockQueryFactory, .heartRateQuery(.any, willReturn: sampleQuery))

		let subQuery = MoodQueryMock()
		Given(mockQueryFactory, .moodQuery(.any, willReturn: subQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()

		let subQuerySampleInfo = SampleTypeInfo(MoodImpl.self, mockSubQueryMatcher())
		controller.queries[0] = (sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: [])
		controller.queries.append((sampleTypeInfo: subQuerySampleInfo, parts: []))

		mockResultsViewController()

		// when
		controller.finishedButtonPressed(finishedButton)

		// then
		XCTAssertNotNil(sampleQuery.subQuery)
		if let actualSubQuery = sampleQuery.subQuery {
			XCTAssert(actualSubQuery.matcher === subQuerySampleInfo.matcher!)
			XCTAssert(actualSubQuery.query === subQuery)
		}
		Verify(mockQueryFactory, .heartRateQuery(.value([])))
		Verify(mockQueryFactory, .moodQuery(.value([])))
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}

	func testGivenHeartRateDataTypeWithMoodSubQueryThatHasMultipleAttributeRestrictions_finishedButtonPressed_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		Given(mockQueryFactory, .heartRateQuery(.any, willReturn: sampleQuery))

		let subQuery = MoodQueryMock()
		Given(mockQueryFactory, .moodQuery(.any, willReturn: subQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()

		let subQuerySampleInfo = SampleTypeInfo(MoodImpl.self, mockSubQueryMatcher())
		let attributeRestriction1 = EqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating)
		let attributeRestriction2 = NotEqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating)
		controller.queries[0] = (sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: [])
		let subQueryParts: [BooleanExpressionPart] = [
			(type: .expression, expression: attributeRestriction1),
			(type: .and, expression: nil),
			(type: .expression, expression: attributeRestriction2),
		]
		controller.queries.append((sampleTypeInfo: subQuerySampleInfo, parts: subQueryParts))

		mockResultsViewController()

		// when
		controller.finishedButtonPressed(finishedButton)

		// then
		XCTAssertNotNil(sampleQuery.subQuery)
		if let actualSubQuery = sampleQuery.subQuery {
			XCTAssert(actualSubQuery.matcher === subQuerySampleInfo.matcher!)
			XCTAssert(actualSubQuery.query === subQuery)
		}
		Verify(mockQueryFactory, .heartRateQuery(.value([])))
		Verify(mockQueryFactory, .moodQuery(.value(subQueryParts)))
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}

	func testGivenHeartRateDataTypeWithMultipleAttributeRestrictionsAndMoodSubQueryThatHasMultipleAttributeRestrictions_finishedButtonPressed_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		Given(mockQueryFactory, .heartRateQuery(.any, willReturn: sampleQuery))

		let subQuery = MoodQueryMock()
		Given(mockQueryFactory, .moodQuery(.any, willReturn: subQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()

		let heartRateAttributeRestriction1 = EqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		let heartRateAttributeRestriction2 = NotEqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		let queryParts: [BooleanExpressionPart] = [
			(type: .expression, expression: heartRateAttributeRestriction1),
			(type: .and, expression: nil),
			(type: .expression, expression: heartRateAttributeRestriction2),
		]
		controller.queries[0] = (sampleTypeInfo: SampleTypeInfo(HeartRate.self), parts: queryParts)

		let subQuerySampleInfo = SampleTypeInfo(MoodImpl.self, mockSubQueryMatcher())

		let moodAttributeRestriction1 = EqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating)
		let moodAttributeRestriction2 = NotEqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating)
		let subQueryParts: [BooleanExpressionPart] = [
			(type: .expression, expression: moodAttributeRestriction1),
			(type: .and, expression: nil),
			(type: .expression, expression: moodAttributeRestriction2),
		]
		controller.queries.append((sampleTypeInfo: subQuerySampleInfo, parts: subQueryParts))

		mockResultsViewController()

		// when
		controller.finishedButtonPressed(finishedButton)

		// then
		XCTAssertNotNil(sampleQuery.subQuery)
		if let actualSubQuery = sampleQuery.subQuery {
			XCTAssert(actualSubQuery.matcher === subQuerySampleInfo.matcher!)
			XCTAssert(actualSubQuery.query === subQuery)
		}
		Verify(mockQueryFactory, .heartRateQuery(.value(queryParts)))
		Verify(mockQueryFactory, .moodQuery(.value(subQueryParts)))
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}

	// MARK: - Helper Functions

	private final func setValidation(_ passes: Bool = true) {
		if passes {
			Given(mockQueryFactory, .activityQuery(.any, willReturn: ActivityQueryMock()))
			Given(mockQueryFactory, .bloodPressureQuery(.any, willReturn: BloodPressureQueryMock()))
			Given(mockQueryFactory, .bmiQuery(.any, willReturn: BodyMassIndexQueryMock()))
			Given(mockQueryFactory, .heartRateQuery(.any, willReturn: HeartRateQueryMock()))
			Given(mockQueryFactory, .leanBodyMassQuery(.any, willReturn: LeanBodyMassQueryMock()))
			Given(mockQueryFactory, .medicationDoseQuery(.any, willReturn: MedicationDoseQueryMock()))
			Given(mockQueryFactory, .moodQuery(.any, willReturn: MoodQueryMock()))
			Given(mockQueryFactory, .restingHeartRateQuery(.any, willReturn: RestingHeartRateQueryMock()))
			Given(mockQueryFactory, .sexualActivityQuery(.any, willReturn: SexualActivityQueryMock()))
			Given(mockQueryFactory, .sleepQuery(.any, willReturn: SleepQueryMock()))
			Given(mockQueryFactory, .weightQuery(.any, willReturn: WeightQueryMock()))
		} else {
			Given(mockQueryFactory, .activityQuery(.any, willThrow: GenericError("validation failed")))
			Given(mockQueryFactory, .bloodPressureQuery(.any, willThrow: GenericError("validation failed")))
			Given(mockQueryFactory, .bmiQuery(.any, willThrow: GenericError("validation failed")))
			Given(mockQueryFactory, .heartRateQuery(.any, willThrow: GenericError("validation failed")))
			Given(mockQueryFactory, .leanBodyMassQuery(.any, willThrow: GenericError("validation failed")))
			Given(mockQueryFactory, .medicationDoseQuery(.any, willThrow: GenericError("validation failed")))
			Given(mockQueryFactory, .moodQuery(.any, willThrow: GenericError("validation failed")))
			Given(mockQueryFactory, .restingHeartRateQuery(.any, willThrow: GenericError("validation failed")))
			Given(mockQueryFactory, .sexualActivityQuery(.any, willThrow: GenericError("validation failed")))
			Given(mockQueryFactory, .sleepQuery(.any, willThrow: GenericError("validation failed")))
			Given(mockQueryFactory, .weightQuery(.any, willThrow: GenericError("validation failed")))
		}
	}

	// MARK: Mocks

	@discardableResult
	private final func mockResultsViewController() -> ResultsViewControllerMock {
		let controller = ResultsViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("results"),
			from: .value("Results"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockChooseSampleTypeViewController() -> ChooseSampleTypeViewControllerMock {
		let controller = ChooseSampleTypeViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("chooseSampleType"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	private final func mockSubQueryMatcher() -> SubQueryMatcherMock {
		let mock = SubQueryMatcherMock()
		Given(mock, .debugDescription(getter: "sub query matcher"))
		mock.description = "sub query matcher"
		return mock
	}

	private final func mockDefaultAttributeRestrictionFor(_ sampleType: Sample.Type) -> AttributeRestriction {
		let expectedRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: sampleType.defaultIndependentAttribute)
		Given(
			mockAttributeRestrictionFactory,
			.typesFor(.value(sampleType.defaultIndependentAttribute), willReturn: [AttributeRestrictionMock.self]))
		Given(
			mockAttributeRestrictionFactory,
			.initialize(
				type: .value(AttributeRestrictionMock.self),
				forAttribute: .value(sampleType.defaultIndependentAttribute),
				willReturn: expectedRestriction))
		return expectedRestriction
	}

	private final func mockAttributeRestrictionFor(restrictedAttribute: Attribute) -> AttributeRestrictionMock {
		let restriction = AttributeRestrictionMock(restrictedAttribute: restrictedAttribute)
		Given(restriction, .restrictedAttribute(getter: restrictedAttribute))
		restriction.description = "restriction for \(restrictedAttribute.name)"
		Given(restriction, .debugDescription(getter: restriction.description))
		return restriction
	}

	private final func mockAlertActions() {
		mockAlertAction(withTitle: "Attribute Restriction")
		mockAlertAction(withTitle: "And")
		mockAlertAction(withTitle: "Or")
		mockAlertAction(withTitle: "Not")
		mockAlertAction(withTitle: "Condition Group Start")
		mockAlertAction(withTitle: "Condition Group End")
		mockAlertAction(withTitle: "Cancel")
	}

	private final func mockAlertAction(withTitle title: String?) {
		Given(
			mockUiUtil,
			.alertAction(
				title: .value(title),
				style: .any,
				handler: .any,
				willReturn: UIAlertAction(title: title, style: .default, handler: nil)))
	}

	// MARK: Matchers

	private final func queriesEquals(_ expectedQueries: [(sampleTypeInfo: SampleTypeInfo, parts: [BooleanExpressionPart])])
	-> Hamcrest.Matcher<[(sampleTypeInfo: SampleTypeInfo, parts: [BooleanExpressionPart])]> {
		return Hamcrest.Matcher("") { actualQueries -> MatchResult in
			if actualQueries.count != expectedQueries.count {
				return .mismatch("Actual had \(actualQueries.count) sections but should have \(expectedQueries.count) sections")
			}
			for i in 0 ..< actualQueries.count {
				let actualQuery = actualQueries[i]
				let expectedQuery = expectedQueries[i]
				if actualQuery.sampleTypeInfo.sampleType != expectedQuery.sampleTypeInfo.sampleType {
					return .mismatch("Wrong sample type at index \(i)")
				}
				if
					let actualMatcher = actualQuery.sampleTypeInfo.matcher,
					let expectedMatcher = expectedQuery.sampleTypeInfo.matcher
				{
					if !actualMatcher.equalTo(expectedMatcher) {
						return .mismatch("Wrong matcher at index \(i): was '\(actualMatcher.debugDescription)' but should be '\(expectedMatcher.debugDescription)'")
					}
				} else if let actualMatcher = actualQuery.sampleTypeInfo.matcher {
					return .mismatch("Actual matcher at index \(i) was '\(actualMatcher.debugDescription)' but should be nil")
				} else if let expectedMatcher = expectedQuery.sampleTypeInfo.matcher {
					return .mismatch("Actual matcher at index \(i) was nil but should be '\(expectedMatcher.debugDescription)'")
				}
				let actualParts = actualQuery.parts
				let expectedParts = expectedQuery.parts
				if actualParts.count != expectedParts.count {
					return .mismatch("Actual query at index \(i) had \(actualParts.count) parts instead of \(expectedParts.count)")
				}
				for j in 0 ..< actualParts.count {
					let actualPart = actualParts[j]
					let expectedPart = expectedParts[j]
					if actualPart.type != expectedPart.type {
						return .mismatch("Wrong part type in section \(i) at index \(j): was '\(actualPart.type)' but should be '\(expectedPart.type)'")
					}
					if
						let actualExpression = actualPart.expression,
						let expectedExpression = expectedPart.expression
					{
						if !actualExpression.equalTo(expectedExpression) {
							return .mismatch(
								"Wrong expression in section \(i) at index \(j): was \(actualExpression.description) but should be '\(expectedExpression.description)'")
						}
					} else if let actualExpression = actualPart.expression {
						return .mismatch("Actual expression in section \(i) at index \(j) was '\(actualExpression.description)' but should be nil")
					} else if let expectedExpression = expectedPart.expression {
						return .mismatch("Actual expression in section \(i) at index \(j) was nil but should be '\(expectedExpression.description)'")
					}
				}
			}
			return .match
		}
	}
}
