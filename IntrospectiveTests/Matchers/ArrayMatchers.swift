//
//  ArrayMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective

func arrayHasExactly<Type: Equatable>(_ expected: [Type]) -> Matcher<[Type]?> {
	return arrayHasExactly(expected, areEqual: { $0 == $1 })
}

func arrayHasExactly<Type>(_ expected: [Type], areEqual: @escaping (Type, Type) -> Bool) -> Matcher<[Type]?> {
	return Matcher("array with \(expected.debugDescription)") { (actual: [Type]?) -> MatchResult in
		guard let actual = actual else {
			return .mismatch("is nil")
		}
		var mismatchMessage = ""
		let unexpected = actual.filter({ item in
			return !expected.contains(where: { areEqual(item, $0) })
		})
		if unexpected.count != 0 {
			mismatchMessage += "Found \(unexpected.count) unexpected items: \(unexpected.debugDescription)"
		}
		let missing = expected.filter({ item in
			return !actual.contains(where: { areEqual(item, $0) })
		})
		if missing.count != 0 {
			mismatchMessage += "Missing \(missing.count) expected items: \(missing.debugDescription)"
		}
		if !mismatchMessage.isEmpty {
			return .mismatch(mismatchMessage)
		}
		return .match
	}
}
