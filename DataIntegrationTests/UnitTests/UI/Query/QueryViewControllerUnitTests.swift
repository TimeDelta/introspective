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
		controller.viewDidLoad()
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

		controller.viewDidLoad()

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

		controller.viewDidLoad()

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
}
