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
@testable import Introspective

class QueryViewControllerUnitTests: UnitTest {

	private typealias Me = QueryViewControllerUnitTests
	private static let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
	private static let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
	private static let finishedButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)

	private var controller: QueryViewController!

	override func setUp() {
		super.setUp()
		controller = QueryViewController()
		controller.editButton = Me.editButton
		controller.finishedButton = Me.finishedButton
	}

	func testGivenHeartRateDataTypeWithNoRestrictionsOrSubQuery_prepareForSegue_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		Given(mockQueryFactory, .heartRateQuery(willReturn: sampleQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()
		controller.parts[0] = QueryViewController.Part(QueryViewController.SampleTypeInfo(HeartRate.self))

		// when
		controller.finishedButtonPressed(Me.finishedButton)

		// then
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}

	func testGivenHeartRateDataTypeWithOneAttributeRestrictionAndNoSubQuery_prepareForSegue_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		sampleQuery.attributeRestrictions = []
		Given(mockQueryFactory, .heartRateQuery(willReturn: sampleQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()
		controller.parts[0] = QueryViewController.Part(QueryViewController.SampleTypeInfo(HeartRate.self))

		let attributeRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		controller.parts.append(QueryViewController.Part(attributeRestriction))

		// when
		controller.finishedButtonPressed(Me.finishedButton)

		// then
		XCTAssert(sampleQuery.attributeRestrictions.contains(where: { r in return r.equalTo(attributeRestriction) }))
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}

	func testGivenHeartRateDataTypeWithMultipleAttributeRestrictionsAndNoSubQuery_prepareForSegue_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		sampleQuery.attributeRestrictions = []
		Given(mockQueryFactory, .heartRateQuery(willReturn: sampleQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()
		controller.parts[0] = QueryViewController.Part(QueryViewController.SampleTypeInfo(HeartRate.self))

		let attributeRestriction1 = EqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		let attributeRestriction2 = NotEqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		controller.parts.append(QueryViewController.Part(attributeRestriction1))
		controller.parts.append(QueryViewController.Part(attributeRestriction2))

		// when
		controller.finishedButtonPressed(Me.finishedButton)

		// then
		XCTAssert(sampleQuery.attributeRestrictions.contains(where: { r in return r.equalTo(attributeRestriction1) }))
		XCTAssert(sampleQuery.attributeRestrictions.contains(where: { r in return r.equalTo(attributeRestriction2) }))
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}

	func testGivenHeartRateDataTypeWithMoodSubQueryAndNoAttributeRestrictions_prepareForSegue_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		Given(mockQueryFactory, .heartRateQuery(willReturn: sampleQuery))

		let subQuery = MoodQueryMock()
		Given(mockQueryFactory, .moodQuery(willReturn: subQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()
		controller.parts[0] = QueryViewController.Part(QueryViewController.SampleTypeInfo(HeartRate.self))

		var dataTypeInfo = QueryViewController.SampleTypeInfo(MoodImpl.self)
		dataTypeInfo.matcher = SubQueryMatcherMock()
		dataTypeInfo.matcher!.mostRecentOnly = false
		controller.parts.append(QueryViewController.Part(dataTypeInfo))

		// when
		controller.finishedButtonPressed(Me.finishedButton)

		// then
		XCTAssert(sampleQuery.subQuery != nil)
		if sampleQuery.subQuery != nil {
			XCTAssert(sampleQuery.subQuery!.matcher === dataTypeInfo.matcher!)
			XCTAssert(sampleQuery.subQuery!.query === subQuery)
		}
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}

	func testGivenHeartRateDataTypeWithMoodSubQueryThatHasMultipleAttributeRestrictions_prepareForSegue_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		Given(mockQueryFactory, .heartRateQuery(willReturn: sampleQuery))

		let subQuery = MoodQueryMock()
		subQuery.attributeRestrictions = []
		Given(mockQueryFactory, .moodQuery(willReturn: subQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()
		controller.parts[0] = QueryViewController.Part(QueryViewController.SampleTypeInfo(HeartRate.self))

		var dataTypeInfo = QueryViewController.SampleTypeInfo(MoodImpl.self)
		dataTypeInfo.matcher = SubQueryMatcherMock()
		controller.parts.append(QueryViewController.Part(dataTypeInfo))

		let attributeRestriction1 = EqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating)
		let attributeRestriction2 = NotEqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating)
		controller.parts.append(QueryViewController.Part(attributeRestriction1))
		controller.parts.append(QueryViewController.Part(attributeRestriction2))

		// when
		controller.finishedButtonPressed(Me.finishedButton)

		// then
		XCTAssert(sampleQuery.subQuery != nil)
		if sampleQuery.subQuery != nil {
			XCTAssert(sampleQuery.subQuery!.matcher === dataTypeInfo.matcher!)
			XCTAssert(sampleQuery.subQuery!.query === subQuery)
		}
		XCTAssert(subQuery.attributeRestrictions.contains(where: { r in return r.equalTo(attributeRestriction1) }))
		XCTAssert(subQuery.attributeRestrictions.contains(where: { r in return r.equalTo(attributeRestriction2) }))
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}

	func testGivenHeartRateDataTypeWithMultipleAttributeRestrictionsAndMoodSubQueryThatHasMultipleAttributeRestrictions_prepareForSegue_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		sampleQuery.attributeRestrictions = []
		Given(mockQueryFactory, .heartRateQuery(willReturn: sampleQuery))

		let subQuery = MoodQueryMock()
		subQuery.attributeRestrictions = []
		Given(mockQueryFactory, .moodQuery(willReturn: subQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()
		controller.parts[0] = QueryViewController.Part(QueryViewController.SampleTypeInfo(HeartRate.self))

		let heartRateAttributeRestriction1 = EqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		let heartRateAttributeRestriction2 = NotEqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate)
		controller.parts.append(QueryViewController.Part(heartRateAttributeRestriction1))
		controller.parts.append(QueryViewController.Part(heartRateAttributeRestriction2))

		var dataTypeInfo = QueryViewController.SampleTypeInfo(MoodImpl.self)
		dataTypeInfo.matcher = SubQueryMatcherMock()
		controller.parts.append(QueryViewController.Part(dataTypeInfo))

		let moodAttributeRestriction1 = EqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating)
		let moodAttributeRestriction2 = NotEqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating)
		controller.parts.append(QueryViewController.Part(moodAttributeRestriction1))
		controller.parts.append(QueryViewController.Part(moodAttributeRestriction2))

		// when
		controller.finishedButtonPressed(Me.finishedButton)

		// then
		XCTAssert(sampleQuery.subQuery != nil)
		if sampleQuery.subQuery != nil {
			XCTAssert(sampleQuery.subQuery!.matcher === dataTypeInfo.matcher!)
			XCTAssert(sampleQuery.subQuery!.query === subQuery)
		}
		XCTAssert(sampleQuery.attributeRestrictions.contains(where: { r in return r.equalTo(heartRateAttributeRestriction1) }))
		XCTAssert(sampleQuery.attributeRestrictions.contains(where: { r in return r.equalTo(heartRateAttributeRestriction2) }))
		XCTAssert(subQuery.attributeRestrictions.contains(where: { r in return r.equalTo(moodAttributeRestriction1) }))
		XCTAssert(subQuery.attributeRestrictions.contains(where: { r in return r.equalTo(moodAttributeRestriction2) }))
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}
}
