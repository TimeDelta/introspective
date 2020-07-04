//
//  BooleanExpressionMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective
@testable import BooleanAlgebra

func equals(_ expected: BooleanExpression) -> Matcher<BooleanExpression?> {
	return Matcher("\(expected.description)") { (actual: BooleanExpression?) -> MatchResult in
		guard let actual = actual else {
			return .mismatch("is nil")
		}
		if expected.equalTo(actual) {
			return .match
		}
		return .mismatch(nil)
	}
}
