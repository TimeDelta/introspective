//
//  ContextualActionMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/10/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import UIKit

import Hamcrest

func hasTitle(_ title: String) -> Matcher<UIContextualAction> {
	return hasTitle(equalTo(title))
}

func hasTitle(_ titleMatcher: Matcher<String>) -> Matcher<UIContextualAction> {
	return Matcher("") { action -> MatchResult in
		guard let title = action.title else {
			return .mismatch("Title was nil")
		}
		return titleMatcher.matches(title)
	}
}
