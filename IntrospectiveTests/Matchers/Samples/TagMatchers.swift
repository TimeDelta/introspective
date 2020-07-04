//
//  TagMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/4/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest

@testable import Samples

func hasName(_ expectedName: String) -> Matcher<Tag> {
	return hasName(equalTo(expectedName))
}

func hasName(_ expectedNameMatcher: Matcher<String>) -> Matcher<Tag> {
	return Matcher("has name \(expectedNameMatcher.description)") { actual -> MatchResult in
		return expectedNameMatcher.matches(actual.name)
	}
}
