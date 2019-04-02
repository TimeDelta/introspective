//
//  CalendarComponentExtension.swift
//  Introspective
//
//  Created by Bryan Nova on 1/3/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

extension Calendar.Component {

	public enum Errors: Error {
		case unkownComponentName
	}

	public static var allValues = [
		era,
		year,
		month,
		day,
		hour,
		minute,
		second,
		weekday,
		weekdayOrdinal,
		quarter,
		weekOfMonth,
		weekOfYear,
		yearForWeekOfYear,
		nanosecond,
		calendar,
		timeZone,
	]

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
				Log().error("Missing Calendar Component type: %d", i)
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

	public var description: String {
		switch (self) {
			case .calendar: return "Calendar"
			case .era: return "Era"
			case .year: return "Year"
			case .yearForWeekOfYear: return "Year for Week of Year"
			case .quarter: return "Quarter"
			case .month: return "Month"
			case .weekOfMonth: return "Week of Month"
			case .weekOfYear: return "Week"
			case .weekday: return "Day of Week"
			case .weekdayOrdinal: return "Weekday Ordinal"
			case .timeZone: return "Time Zone"
			case .day: return "Day"
			case .hour: return "Hour"
			case .minute: return "Minute"
			case .second: return "Second"
			case .nanosecond: return "Nanosecond"
		}
	}

	public static func from(string: String) throws -> Calendar.Component {
		switch (string.lowercased()) {
			case "calendar": return .calendar
			case "era": return .era
			case "year": return .year
			case "year for week of year": return .yearForWeekOfYear
			case "quarter": return .quarter
			case "month": return .month
			case "week of month": return .weekOfMonth
			case "week": return .weekOfYear
			case "day of week": return .weekday
			case "weekday ordinal": return .weekdayOrdinal
			case "time zone": return .timeZone
			case "day": return .day
			case "hour": return .hour
			case "minute": return .minute
			case "second": return .second
			case "nanosecond": return .nanosecond
			default: throw Errors.unkownComponentName
		}
	}
}
