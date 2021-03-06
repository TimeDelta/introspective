//
//  ActivityDefinitionMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/15/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective
@testable import Samples

func equals(_ expected: ActivityDefinition) -> Matcher<ActivityDefinition?> {
	return Matcher("\(expected.description)") { actual -> MatchResult in
		guard let actual = actual else {
			return .mismatch("is nil")
		}
		if expected.equalTo(actual) {
			return .match
		}
		return .mismatch(nil)
	}
}

func equals(_ expected: ActivityDefinition) -> Matcher<ActivityDefinition> {
	return Matcher("\(expected.description)") { actual -> Bool in
		return expected.equalTo(actual)
	}
}
