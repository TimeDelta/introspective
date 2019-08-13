//
//  NavigationItemMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/12/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import UIKit
import Hamcrest

func hasTitle(_ expectedTitle: String) -> Matcher<UINavigationItem> {
	return hasTitle(equalTo(expectedTitle))
}

func hasTitle(_ matcher: Matcher<String?>) -> Matcher<UINavigationItem> {
	return Matcher("has title \(matcher.description)") { navigationItem -> MatchResult in
		return matcher.matches(navigationItem.title)
	}
}
