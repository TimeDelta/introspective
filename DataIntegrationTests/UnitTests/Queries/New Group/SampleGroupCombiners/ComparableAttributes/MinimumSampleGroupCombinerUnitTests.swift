//
//  MinimumSampleGroupCombinerUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import DataIntegration

class MinimumSampleGroupCombinerUnitTests: UnitTest {

	fileprivate typealias Me = MinimumSampleGroupCombinerUnitTests
	fileprivate static let groupByAttribute = TextAttribute(name: "groupBy")

	fileprivate var combiner: MinimumSampleGroupCombiner!

	override func setUp() {
		super.setUp()
		combiner = MinimumSampleGroupCombiner()
	}

	func testGivenEmptyGroupsArray_combine_returnsEmptyArray() {
		// when
		let combinedSamples = combiner.combine(groups: [], groupedBy: Me.groupByAttribute, combinationAttribute: Me.groupByAttribute)

		// then
		XCTAssert(combinedSamples.count == 0)
	}

	func testGivenIntegerAttribute_combine_correctlyCombinesGroups() {
		// given
		let expectedMin: Int = 5
		let combineByAttribute = IntegerAttribute(name: "combineBy")
		let samples = [SampleCreatorTestUtil.createSample(withValue: expectedMin, for: combineByAttribute, otherAttributes: [Me.groupByAttribute])]
		Given(mockNumericSampleUtil, .min(for: .value(combineByAttribute), over: .value(samples), willReturn: expectedMin))

		// when
		let combinedSamples = combiner.combine(groups: [("", samples)], groupedBy: Me.groupByAttribute, combinationAttribute: combineByAttribute)

		// then
		XCTAssert(try! combinedSamples[0].value(of: combineByAttribute) as! Int == expectedMin)
	}

	func testGivenDoubleAttribute_combine_correctlyCombinesGroups() {
		// given
		let expectedMin: Double = 5.0
		let combineByAttribute = DoubleAttribute(name: "combineBy")
		let samples = [SampleCreatorTestUtil.createSample(withValue: expectedMin, for: combineByAttribute, otherAttributes: [Me.groupByAttribute])]
		Given(mockNumericSampleUtil, .min(for: .value(combineByAttribute), over: .value(samples), willReturn: expectedMin))

		// when
		let combinedSamples = combiner.combine(groups: [("", samples)], groupedBy: Me.groupByAttribute, combinationAttribute: combineByAttribute)

		// then
		XCTAssert(try! combinedSamples[0].value(of: combineByAttribute) as! Double == expectedMin)
	}

	func testGivenDateAttribute_combine_correctlyCombinesGroups() {
		// given
		let expectedMin: Date = Date()
		let combineByAttribute = DateTimeAttribute()
		let samples = [SampleCreatorTestUtil.createSample(withValue: expectedMin, for: combineByAttribute, otherAttributes: [Me.groupByAttribute])]
		Given(mockNumericSampleUtil, .min(for: .value(combineByAttribute), over: .value(samples), willReturn: expectedMin))

		// when
		let combinedSamples = combiner.combine(groups: [("", samples)], groupedBy: Me.groupByAttribute, combinationAttribute: combineByAttribute)

		// then
		XCTAssert(try! combinedSamples[0].value(of: combineByAttribute) as! Date == expectedMin)
	}
}
