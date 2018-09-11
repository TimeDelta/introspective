//
//  MaximumSampleGroupCombinerUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import DataIntegration

class MaximumSampleGroupCombinerUnitTests: UnitTest {

	fileprivate typealias Me = MaximumSampleGroupCombinerUnitTests
	fileprivate static let groupByAttribute = TextAttribute(name: "groupBy")

	fileprivate var combiner: MaximumSampleGroupCombiner!

	override func setUp() {
		super.setUp()
		combiner = MaximumSampleGroupCombiner()
	}

	func testGivenEmptyGroupsArray_combine_returnsEmptyArray() {
		// when
		let combinedSamples = combiner.combine(groups: [], groupedBy: Me.groupByAttribute, combinationAttribute: Me.groupByAttribute)

		// then
		XCTAssert(combinedSamples.count == 0)
	}

	func testGivenIntegerAttribute_combine_correctlyCombinesGroups() {
		// given
		let expectedMax: Int = 5
		let combineByAttribute = IntegerAttribute(name: "combineBy")
		let samples = [SampleCreatorTestUtil.createSample(withValue: expectedMax, for: combineByAttribute, otherAttributes: [Me.groupByAttribute])]
		Given(mockNumericSampleUtil, .max(for: .value(combineByAttribute), over: .value(samples), willReturn: expectedMax))

		// when
		let combinedSamples = combiner.combine(groups: [("", samples)], groupedBy: Me.groupByAttribute, combinationAttribute: combineByAttribute)

		// then
		XCTAssert(try! combinedSamples[0].value(of: combineByAttribute) as! Int == expectedMax)
	}

	func testGivenDoubleAttribute_combine_correctlyCombinesGroups() {
		// given
		let expectedMax: Double = 5.0
		let combineByAttribute = DoubleAttribute(name: "combineBy")
		let samples = [SampleCreatorTestUtil.createSample(withValue: expectedMax, for: combineByAttribute, otherAttributes: [Me.groupByAttribute])]
		Given(mockNumericSampleUtil, .max(for: .value(combineByAttribute), over: .value(samples), willReturn: expectedMax))

		// when
		let combinedSamples = combiner.combine(groups: [("", samples)], groupedBy: Me.groupByAttribute, combinationAttribute: combineByAttribute)

		// then
		XCTAssert(try! combinedSamples[0].value(of: combineByAttribute) as! Double == expectedMax)
	}

	func testGivenDateAttribute_combine_correctlyCombinesGroups() {
		// given
		let expectedMax: Date = Date()
		let combineByAttribute = DateTimeAttribute()
		let samples = [SampleCreatorTestUtil.createSample(withValue: expectedMax, for: combineByAttribute, otherAttributes: [Me.groupByAttribute])]
		Given(mockNumericSampleUtil, .max(for: .value(combineByAttribute), over: .value(samples), willReturn: expectedMax))

		// when
		let combinedSamples = combiner.combine(groups: [("", samples)], groupedBy: Me.groupByAttribute, combinationAttribute: combineByAttribute)

		// then
		XCTAssert(try! combinedSamples[0].value(of: combineByAttribute) as! Date == expectedMax)
	}
}
