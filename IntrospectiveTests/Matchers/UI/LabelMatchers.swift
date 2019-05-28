//
//  LabelMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest

func hasText(_ expectedTextMatcher: Matcher<String>) -> Matcher<UILabel?> {
	return Matcher("has text: \(expectedTextMatcher.description)") { (actual: UILabel?) -> MatchResult in
		guard let actual = actual else {
			return .mismatch("is nil")
		}
		guard let actualText = actual.text else {
			return .mismatch("text is nil")
		}
		return expectedTextMatcher.matches(actualText)
	}
}
