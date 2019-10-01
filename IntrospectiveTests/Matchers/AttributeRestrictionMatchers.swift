//
//  AttributeRestrictionMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions

func equals(_ expected: AttributeRestriction) -> Matcher<AttributeRestriction?> {
	return Matcher("\(expected.description)") { (actual: AttributeRestriction?) -> MatchResult in
		guard let actual = actual else {
			return .mismatch("is nil")
		}
		if expected.equalTo(actual) {
			return .match
		}
		return .mismatch(nil)
	}
}
