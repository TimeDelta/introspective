//
//  GroupDefinitionMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective

func equals(_ expected: GroupDefinition) -> Matcher<GroupDefinition?> {
	return Matcher("\(expected.description)") { (actual: GroupDefinition?) -> MatchResult in
		guard let actual = actual else {
			return .mismatch("is nil")
		}
		if expected.equalTo(actual) {
			return .match
		}
		return .mismatch(nil)
	}
}

func hasName(_ expected: String) -> Matcher<GroupDefinition?> {
	return Matcher("GroupDefinition with name: \(expected)") { (actual: GroupDefinition?) -> MatchResult in
		guard let actual = actual else {
			return .mismatch("is nil")
		}
		if expected == actual.name {
			return .match
		}
		return .mismatch("GroupDefinition has name: \(actual.name)")
	}
}
