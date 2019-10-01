//
//  AttributeMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective
@testable import Attributes

func equals(_ expected: Attribute) -> Matcher<Attribute?> {
	return Matcher("attribute \(expected)") { (actual: Attribute?) -> Bool in
		guard let actual = actual else { return false }
		return expected.equalTo(actual)
	}
}
