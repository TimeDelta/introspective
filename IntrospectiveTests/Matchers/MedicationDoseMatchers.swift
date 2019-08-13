//
//  MedicationDoseMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/12/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective

func equals(_ expectedDose: MedicationDose) -> Matcher<MedicationDose?> {
	return Matcher(expectedDose.debugDescription) { actual -> MatchResult in
		guard let actual = actual else {
			return .mismatch("was nil")
		}
		if actual.equalTo(expectedDose) {
			return .match
		}
		return .mismatch(nil)
	}
}
