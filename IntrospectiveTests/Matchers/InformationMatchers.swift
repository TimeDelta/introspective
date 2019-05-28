//
//  InformationMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/23/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective

func equals(_ expected: ExtraInformation) -> Matcher<ExtraInformation?> {
	return Matcher("\(expected.description)") { (actual: ExtraInformation?) -> MatchResult in
		guard let actual = actual else {
			return .mismatch("is nil")
		}
		if expected.equalTo(actual) {
			return .match
		}
		return .mismatch(nil)
	}
}
