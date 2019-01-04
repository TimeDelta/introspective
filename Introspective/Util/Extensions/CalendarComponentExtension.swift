//
//  CalendarComponentExtension.swift
//  Introspective
//
//  Created by Bryan Nova on 1/3/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import os

extension Calendar.Component {

	public static func fromInt(_ i: Int) -> Calendar.Component {
		switch (i) {
			case 0: return .era
			case 1: return .year
			case 2: return .month
			case 3: return .day
			case 4: return .hour
			case 5: return .minute
			case 6: return .second
			case 7: return .weekday
			case 8: return .weekdayOrdinal
			case 9: return .quarter
			case 10: return .weekOfMonth
			case 11: return .weekOfYear
			case 12: return .yearForWeekOfYear
			case 13: return .nanosecond
			case 14: return .calendar
			case 15: return .timeZone
			default:
				os_log("Missing Calendar Component type: %d", type: .error, i)
				return .day // random default that should never happen
		}
	}

	public func intValue() -> Int {
		switch (self) {
			case .era: return 0
			case .year: return 1
			case .month: return 2
			case .day: return 3
			case .hour: return 4
			case .minute: return 5
			case .second: return 6
			case .weekday: return 7
			case .weekdayOrdinal: return 8
			case .quarter: return 9
			case .weekOfMonth: return 10
			case .weekOfYear: return 11
			case .yearForWeekOfYear: return 12
			case .nanosecond: return 13
			case .calendar: return 14
			case .timeZone: return 15
		}
	}
}
