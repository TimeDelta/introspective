//
//  SearchUtilUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective

class SearchUtilUnitTests: UnitTest {

	fileprivate var util: SearchUtilImpl!

	override func setUp() {
		super.setUp()
		util = SearchUtilImpl()
	}

	func testGivenNoElementsInArray_binarySearchFor_returnsNil() {
		// given
		let items: [Int] = []

		// when
		let index = util.binarySearch(for: 0, in: items)

		// then
		XCTAssert(index == nil)
	}

	func testGivenTargetItemNotInArray_binarySearchFor_returnsNil() {
		// given
		let items: [Int] = [0, 2, 3, 4, 5, 6]

		// when
		let index = util.binarySearch(for: 1, in: items)

		// then
		XCTAssert(index == nil)
	}

	func testGivenTargetItemInArray_binarySearchFor_returnsCorrectIndex() {
		// given
		let items: [Int] = [0, 2, 3, 4, 5, 6]

		// when
		let index = util.binarySearch(for: 4, in: items)

		// then
		XCTAssert(index == 3)
	}

	func testGivenNoElementsInArray_binarySearchForUsing_returnsNil() {
		// given
		let items: [Int] = []

		// when
		let index = util.binarySearch(for: 0, in: items, compare: comparisonFunction)

		// then
		XCTAssert(index == nil)
	}

	func testGivenTargetItemNotInArray_binarySearchForUsing_returnsNil() {
		// given
		let items: [Int] = [0, 2, 3, 4, 5, 6]

		// when
		let index = util.binarySearch(for: 1, in: items, compare: comparisonFunction)

		// then
		XCTAssert(index == nil)
	}

	func testGivenTargetItemInArray_binarySearchForUsing_returnsCorrectIndex() {
		// given
		let items: [Int] = [0, 2, 3, 4, 5, 6]

		// when
		let index = util.binarySearch(for: 4, in: items, compare: comparisonFunction)

		// then
		XCTAssert(index == 3)
	}

	func testGivenOnlyOneItemInArray_closestItem_returnsThatElement() {
		// given
		let items: [Int] = [0]

		// when
		let closest = util.closestItem(to: 9, in: items, distance: distanceFunction)

		// then
		XCTAssert(closest == items[0])
	}

	func testGivenExactElementInArray_closestItem_returnsThatElement() {
		// given
		let target = 6
		let items: [Int] = [5, 3, 1, target, 8, 3, 78]

		// when
		let closest = util.closestItem(to: target, in: items, distance: distanceFunction)

		// then
		XCTAssert(closest == target)
	}

	func testGivenTwoEquidistantItemsInArray_closestItem_returnsLowestIndexClosestItem() {
		// given
		let target = 5
		let items = [0, 10, -10, 200]

		// when
		let closest = util.closestItem(to: target, in: items, distance: distanceFunction)

		// then
		XCTAssert(closest == items[0])
	}

	fileprivate func comparisonFunction(i: Int, j: Int) -> ComparisonResult {
		if i < j { return .orderedAscending }
		if i > j { return .orderedDescending }
		return .orderedSame
	}

	fileprivate func distanceFunction(i: Int, j: Int) -> Int {
		return abs(i - j)
	}
}
