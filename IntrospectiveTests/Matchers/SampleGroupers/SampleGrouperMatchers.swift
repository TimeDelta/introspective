//
//  SampleGrouperMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/19/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective
@testable import SampleGroupers

func equals(_ expected: SampleGrouper.Type?) -> Matcher<SampleGrouper.Type?> {
	return Matcher("Equal to \(expected?.userVisibleDescription ?? "nil")") { (actual: SampleGrouper.Type?) -> Bool in
		if expected == nil && actual == nil { return true }
		guard let expected = expected else { return false }
		guard let actual = actual else { return false }
		return expected.userVisibleDescription == actual.userVisibleDescription
	}
}

func equals(_ expected: SampleGrouper?) -> Matcher<SampleGrouper> {
	return Matcher("Equal to \(expected?.debugDescription ?? "nil")") { (actual: SampleGrouper?) -> Bool in
		if expected == nil && actual == nil { return true }
		guard let expected = expected else { return false }
		guard let actual = actual else { return false }
		return expected.equalTo(actual)
	}
}
