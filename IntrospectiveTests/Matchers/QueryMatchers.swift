//
//  QueryMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/22/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective
@testable import Queries

func equals(_ expected: Query) -> Matcher<Query?> {
	return Matcher("\(String(describing: expected))") { (actual: Query?) -> MatchResult in
		guard let actual = actual else {
			return .mismatch("Actual was nil")
		}
		if actual.equalTo(expected) {
			return .match
		}
		return .mismatch(nil)
	}
}
