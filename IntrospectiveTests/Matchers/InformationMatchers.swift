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
@testable import SampleGroupInformation

func equals(_ expected: SampleGroupInformation) -> Matcher<SampleGroupInformation?> {
	return Matcher("\(expected.description)") { (actual: SampleGroupInformation?) -> MatchResult in
		guard let actual = actual else {
			return .mismatch("is nil")
		}
		if expected.equalTo(actual) {
			return .match
		}
		return .mismatch(nil)
	}
}
