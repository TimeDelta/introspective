
//
//  SubQueryMatcherMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/9/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective
@testable import Queries

func equals(_ expected: SubQueryMatcher) -> Matcher<SubQueryMatcher> {
	return Matcher(expected.description) { actual -> Bool in
		return actual.equalTo(expected)
	}
}
