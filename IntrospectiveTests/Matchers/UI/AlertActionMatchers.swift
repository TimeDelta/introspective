//
//  AlertActionMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest

func hasTitle(_ expectedTitle: String) -> Matcher<UIAlertAction?> {
	return Matcher("has title '\(expectedTitle)'") { (actual: UIAlertAction?) -> MatchResult in
		guard let actual = actual else {
			return .mismatch("is nil")
		}
		guard let actualTitle = actual.title else {
			return .mismatch("title is nil")
		}
		if actualTitle == expectedTitle {
			return .match
		}
		return .mismatch("title was \(actualTitle)")
	}
}
