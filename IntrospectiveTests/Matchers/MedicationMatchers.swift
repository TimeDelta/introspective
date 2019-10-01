//
//  MedicationMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/12/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective
@testable import Samples

func equals(_ expectedMedication: Medication) -> Matcher<Medication?> {
	return Matcher(expectedMedication.debugDescription) { actual -> MatchResult in
		guard let actual = actual else {
			return .mismatch("was nil")
		}
		if actual.equalTo(expectedMedication) {
			return .match
		}
		return .mismatch(nil)
	}
}
