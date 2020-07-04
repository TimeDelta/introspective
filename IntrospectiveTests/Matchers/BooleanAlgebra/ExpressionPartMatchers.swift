//
//  ExpressionPartMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective
@testable import BooleanAlgebra

func equals(_ expected: BooleanExpressionPart) -> Matcher<BooleanExpressionPart> {
	let matcherDescription = "Part of type \(expected.type) with expression: \(expected.expression?.description ?? "nil")"
	return Matcher(matcherDescription) { (actual: BooleanExpressionPart) -> MatchResult in
		if actual.type != expected.type {
			return .mismatch("Wrong type: \(actual.type)")
		}
		if actual.expression == nil && expected.expression == nil {
			return .match
		}
		guard let actualExpression = actual.expression, let expectedExpression = expected.expression else {
			return .mismatch("Wrong expression: \(actual.expression?.description ?? "nil")")
		}
		if actualExpression.equalTo(expectedExpression) {
			return .match
		}
		return .mismatch("Wrong expression: \(actual.expression?.description ?? "nil")")
	}
}
