//
//  QueryViewControllerUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import UIKit
import SwiftyMocky
@testable import DataIntegration

class QueryViewControllerUnitTests: UnitTest {

	fileprivate var controller: QueryViewController!

	override func setUp() {
		super.setUp()
		controller = QueryViewController()
	}

	func testGivenHeartRateDataTypeWithNoRestrictionsOrSubQuery_prepareForSegue_correctlyBuildsAndRunsQuery() {
		// given
		let sampleQuery = HeartRateQueryMock()
		Given(mockQueryFactory, .heartRateQuery(willReturn: sampleQuery))

		Given(mockSampleFactory, .allTypes(willReturn: [HeartRate.self, MoodImpl.self]))
		controller.viewDidLoad()
		controller.parts[0] = QueryViewController.DataTypeInfo(HeartRate.self)
		let segue = UIStoryboardSegue(identifier: "", source: controller, destination: ResultsViewController())

		// when
		controller.prepare(for: segue, sender: self)

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
		controller.parts[0] = QueryViewController.DataTypeInfo(HeartRate.self)

		let attributeRestriction = EqualToNumericAttributeRestriction(attribute: HeartRate.heartRate)
		controller.parts.append(attributeRestriction)

		let segue = UIStoryboardSegue(identifier: "", source: controller, destination: ResultsViewController())

		// when
		controller.prepare(for: segue, sender: self)

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
		controller.parts[0] = QueryViewController.DataTypeInfo(HeartRate.self)

		let attributeRestriction1 = EqualToNumericAttributeRestriction(attribute: HeartRate.heartRate)
		let attributeRestriction2 = NotEqualToNumericAttributeRestriction(attribute: HeartRate.heartRate)
		controller.parts.append(attributeRestriction1)
		controller.parts.append(attributeRestriction2)

		let segue = UIStoryboardSegue(identifier: "", source: controller, destination: ResultsViewController())

		// when
		controller.prepare(for: segue, sender: self)

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
		controller.parts[0] = QueryViewController.DataTypeInfo(HeartRate.self)

		var dataTypeInfo = QueryViewController.DataTypeInfo(MoodImpl.self)
		dataTypeInfo.matcher = SubQueryMatcherMock()
		dataTypeInfo.matcher!.mostRecentOnly = false
		controller.parts.append(dataTypeInfo)

		let segue = UIStoryboardSegue(identifier: "", source: controller, destination: ResultsViewController())

		// when
		controller.prepare(for: segue, sender: self)

		// then
		XCTAssert(sampleQuery.subQuery != nil)
		XCTAssert(sampleQuery.subQuery!.matcher === dataTypeInfo.matcher!)
		XCTAssert(sampleQuery.subQuery!.query === subQuery)
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
		controller.parts[0] = QueryViewController.DataTypeInfo(HeartRate.self)

		var dataTypeInfo = QueryViewController.DataTypeInfo(MoodImpl.self)
		dataTypeInfo.matcher = SubQueryMatcherMock()
		controller.parts.append(dataTypeInfo)

		let attributeRestriction1 = EqualToNumericAttributeRestriction(attribute: MoodImpl.rating)
		let attributeRestriction2 = NotEqualToNumericAttributeRestriction(attribute: MoodImpl.rating)
		controller.parts.append(attributeRestriction1)
		controller.parts.append(attributeRestriction2)

		let segue = UIStoryboardSegue(identifier: "", source: controller, destination: ResultsViewController())

		// when
		controller.prepare(for: segue, sender: self)

		// then
		XCTAssert(sampleQuery.subQuery != nil)
		XCTAssert(sampleQuery.subQuery!.matcher === dataTypeInfo.matcher!)
		XCTAssert(sampleQuery.subQuery!.query === subQuery)
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
		controller.parts[0] = QueryViewController.DataTypeInfo(HeartRate.self)

		let heartRateAttributeRestriction1 = EqualToNumericAttributeRestriction(attribute: HeartRate.heartRate)
		let heartRateAttributeRestriction2 = NotEqualToNumericAttributeRestriction(attribute: HeartRate.heartRate)
		controller.parts.append(heartRateAttributeRestriction1)
		controller.parts.append(heartRateAttributeRestriction2)

		var dataTypeInfo = QueryViewController.DataTypeInfo(MoodImpl.self)
		dataTypeInfo.matcher = SubQueryMatcherMock()
		controller.parts.append(dataTypeInfo)

		let moodAttributeRestriction1 = EqualToNumericAttributeRestriction(attribute: MoodImpl.rating)
		let moodAttributeRestriction2 = NotEqualToNumericAttributeRestriction(attribute: MoodImpl.rating)
		controller.parts.append(moodAttributeRestriction1)
		controller.parts.append(moodAttributeRestriction2)

		let segue = UIStoryboardSegue(identifier: "", source: controller, destination: ResultsViewController())

		// when
		controller.prepare(for: segue, sender: self)

		// then
		XCTAssert(sampleQuery.subQuery != nil)
		XCTAssert(sampleQuery.attributeRestrictions.contains(where: { r in return r.equalTo(heartRateAttributeRestriction1) }))
		XCTAssert(sampleQuery.attributeRestrictions.contains(where: { r in return r.equalTo(heartRateAttributeRestriction2) }))
		XCTAssert(sampleQuery.subQuery!.matcher === dataTypeInfo.matcher!)
		XCTAssert(sampleQuery.subQuery!.query === subQuery)
		XCTAssert(subQuery.attributeRestrictions.contains(where: { r in return r.equalTo(moodAttributeRestriction1) }))
		XCTAssert(subQuery.attributeRestrictions.contains(where: { r in return r.equalTo(moodAttributeRestriction2) }))
		Verify(sampleQuery, .runQuery(callback: .any(((QueryResult?, Error?) -> ()).self)))
	}
}
