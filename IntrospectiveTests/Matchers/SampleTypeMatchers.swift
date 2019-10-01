//
//  SampleTypeMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/19/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective
@testable import Samples

func equals(_ expected: Sample.Type?) -> Matcher<Sample.Type?> {
	return Matcher("Equal to \(expected?.name ?? "nil")") { (actual: Sample.Type?) -> Bool in
		if expected == nil && actual == nil { return true }
		guard let expected = expected else { return false }
		guard let actual = actual else { return false }
		return expected.name == actual.name
	}
}
