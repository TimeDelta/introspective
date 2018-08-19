//
//  CountSampleGroupCombinerUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import DataIntegration

class CountSampleGroupCombinerUnitTests: UnitTest {

	fileprivate typealias Me = CountSampleGroupCombinerUnitTests
	fileprivate static let groupByAttribute = TextAttribute(name: "groupBy")
	fileprivate static let combineByAttribute = TextAttribute(name: "combineBy")
	fileprivate static let attributes: [Attribute] = [groupByAttribute, combineByAttribute]

	fileprivate var combiner: CountSampleGroupCombiner!

	override func setUp() {
		super.setUp()
		combiner = CountSampleGroupCombiner()
	}

	func testGivenEmptyGroupsArray_combine_returnsEmptyArray() {
		// when
		let combinedSamples = combiner.combine(groups: [], groupedBy: Me.groupByAttribute, combinationAttribute: Me.combineByAttribute)

		// then
		XCTAssert(combinedSamples.count == 0)
	}

	func testGivenOneGroupWithOneSample_combine_correctlyCombinesGroup() {
		// given
		let samples = createSamples(count: 1, withAttributes: Me.attributes)

		// when
		let combinedSamples = combiner.combine(groups: [("", samples)], groupedBy: Me.groupByAttribute, combinationAttribute: Me.combineByAttribute)

		// then
		XCTAssert(valueOfCombineByAttribute(for: combinedSamples[0], is: 1))
	}

	func testGivenOneGroupWithMultipleSamples_combine_correctlyCominesGroup() {
		// given
		let expectedCount = 3
		let samples = createSamples(count: expectedCount, withAttributes: Me.attributes)

		// when
		let combinedSamples = combiner.combine(groups: [("", samples)], groupedBy: Me.groupByAttribute, combinationAttribute: Me.combineByAttribute)

		// then
		XCTAssert(valueOfCombineByAttribute(for: combinedSamples[0], is: expectedCount))
	}

	func testGivenMultipleGroups_combine_returnsCorrectNumberOfSamples() {
		// given
		let samples = createSamples(count: 1, withAttributes: Me.attributes)
		let groups: [(Any, [Sample])] = [
			("", samples),
			("a", samples),
			("b", samples),
			("c", samples),
		]

		// when
		let combinedSamples = combiner.combine(groups: groups, groupedBy: Me.groupByAttribute, combinationAttribute: Me.combineByAttribute)

		// then
		XCTAssert(combinedSamples.count == groups.count)
	}

	func testGivenMultipleGroupsWithDifferentNumbersOfSamples_combine_correctlyCombinesGroups() {
		// given
		let groups: [(Any, [Sample])] = [
			("a", createSamples(count: 5, withAttributes: Me.attributes)),
			("b", createSamples(count: 3, withAttributes: Me.attributes)),
			("c", createSamples(count: 7, withAttributes: Me.attributes)),
			("d", createSamples(count: 2, withAttributes: Me.attributes)),
		]

		// when
		let combinedSamples = combiner.combine(groups: groups, groupedBy: Me.groupByAttribute, combinationAttribute: Me.combineByAttribute)

		// then
		for i in 0 ..< groups.count {
			XCTAssert(valueOfCombineByAttribute(for: combinedSamples[i], is: groups[i].1.count))
		}
	}

	fileprivate func valueOfCombineByAttribute(for sample: Sample, is value: Int) -> Bool {
		return try! sample.value(of: Me.combineByAttribute) as! Int == value
	}
}
