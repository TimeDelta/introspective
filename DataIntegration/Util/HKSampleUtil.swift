//
//  HKSampleUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class HKSampleUtil {

	/// Does the specified `HKSample` have any time overlap with any of the given days of the week?
	/// - Returns: `true` if the specified sample overlaps with one of the specifed days of the week or if the given `Set<DayOfWeek>` is empty, otherwise `false`.
	public func sample(_ sample: HKSample, occursOnOneOf daysOfWeek: Set<DayOfWeek>) -> Bool {
		if !daysOfWeek.isEmpty {
			let date = sample.endDate
			let calendar = Calendar.current
			let sampleDayOfWeek = calendar.component(.weekday, from: date)
			for dayOfWeek in daysOfWeek {
				if sampleDayOfWeek == dayOfWeek.intValue {
					return true
				}
			}
			return false
		}
		return true
	}
}
