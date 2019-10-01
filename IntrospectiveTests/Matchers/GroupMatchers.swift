//
//  GroupMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective
@testable import Common
@testable import Samples

typealias Group = (Any, [Sample])
typealias Groups = [Group]

func hasGroup<ValueType: Equatable>(
	forValue expectedGroupValue: ValueType,
	withSamples expectedSamples: [Sample]
) -> Matcher<Groups> {
	return hasGroup(forValue: expectedGroupValue, withSamples: expectedSamples, areEqual: { $0 == $1 })
}

func hasGroup<ValueType>(
	forValue expectedGroupValue: ValueType,
	withSamples expectedSamples: [Sample],
	areEqual: @escaping (ValueType, ValueType) throws -> Bool
) -> Matcher<Groups> {
	let valueDescription = String(describing: expectedGroupValue)
	let description = "Has group for value \(valueDescription) with \(expectedSamples.count) samples"
	return Matcher(description) { (actual: Groups) -> MatchResult in
		// Matcher class cannot accept a throwing function
		for (groupValue, actualSamples) in actual {
			do {
				guard let castedGroupValue = groupValue as? ValueType else {
					throw GenericError("Group value was wrong type: \(String(describing: groupValue))")
				}
				if try areEqual(castedGroupValue, expectedGroupValue) {
					return arrayHasExactly(expectedSamples, areEqual: { $0.equalTo($1) }).matches(actualSamples)
				}
			} catch {
				return .mismatch(errorInfo(error))
			}
		}
		return .mismatch("No group for \(valueDescription)")
	}
}
