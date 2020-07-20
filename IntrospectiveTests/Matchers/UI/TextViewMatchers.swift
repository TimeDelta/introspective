//
//  TextViewMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/20/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest

func hasText(_ expectedText: String) -> Matcher<UITextView?> {
	hasText(equalTo(expectedText))
}

func hasText(_ expectedTextMatcher: Matcher<String>) -> Matcher<UITextView?> {
	return Matcher("has text: \(expectedTextMatcher.description)") { (actual: UITextView?) -> MatchResult in
		guard let actual = actual else {
			return .mismatch("is nil")
		}
		guard let actualText = actual.text else {
			return .mismatch("text is nil")
		}
		return expectedTextMatcher.matches(actualText)
	}
}
