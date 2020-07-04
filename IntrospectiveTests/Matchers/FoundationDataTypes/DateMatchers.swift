//
//  DateMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 6/3/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
import SwiftDate

func within(seconds: Int, of date: Date) -> Matcher<Date?> {
	return Matcher("within \(seconds) seconds of \(date.description)") { (actual: Date?) -> MatchResult in
		guard let actualDate = actual else {
			return .mismatch("Actual date was nil")
		}
		guard let differenceInSeconds = (actualDate - date).second else {
			return .mismatch("Unable to deteermine number of seconds between datees")
		}
		if abs(differenceInSeconds) > seconds {
			return .mismatch("Actual date was \(abs(differenceInSeconds)) seconds from target date")
		}
		return .match
	}
}
