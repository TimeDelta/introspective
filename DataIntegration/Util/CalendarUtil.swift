//
//  CalendarUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftDate

public class CalendarUtil: NSObject {

	public static let componentNames: [Calendar.Component: String] = [
		.calendar: "Calendar",
		.era: "Era",
		.year: "Year",
		.yearForWeekOfYear: "Year For Week Of Year",
		.quarter: "Quarter",
		.month: "Month",
		.weekOfMonth: "Week Of Month",
		.weekOfYear: "Week",
		.weekday: "Weekday",
		.weekdayOrdinal: "Weekday Ordinal",
		.timeZone: "TimeZone",
		.day: "Day",
		.hour: "Hour",
		.minute: "Minute",
		.second: "Second",
		.nanosecond: "Nanosecond",
	]

	/// Set all components of the specified date less than the specified component to the minimum value for that component.
	/// - Parameter toBeginningOf: Must be one of the following values: `.year`, `.month`, `.weekOfYear`, `.day`, `.hour`, `.minute`, `.second`, `.nanosecond`
	public func start(of component: Calendar.Component, in date: Date) -> Date {
		let calendar = Calendar.autoupdatingCurrent
		let dateInRegion = DateInRegion(date, region: Region(calendar: calendar, zone: calendar.timeZone))
		let start = dateInRegion.dateAtStartOf(component)
		return start.date
	}

	/// Set all components of the specified date less than the specified component to the maximum value for that component.
	/// - Parameter toBeginningOf: Must be one of the following values: `.year`, `.month`, `.weekOfYear`, `.day`, `.hour`, `.minute`, `.second`, `.nanosecond`
	public func end(of component: Calendar.Component, in date: Date) -> Date {
		let calendar = Calendar.autoupdatingCurrent
		let dateInRegion = DateInRegion(date, region: Region(calendar: calendar, zone: calendar.timeZone))
		let end = dateInRegion.dateAtEndOf(component)
		return end.date
	}

	public func string(for date: Date, inFormat format: String = "YYYY-MM-dd HH:mm:ss") -> String {
		let calendar = Calendar.autoupdatingCurrent
		let dateInRegion = DateInRegion(date, region: Region(calendar: calendar, zone: calendar.timeZone))
		return dateInRegion.toFormat(format)
	}

	public func date(_ date1: Date, occursOnSame component: Calendar.Component, as date2: Date) -> Bool {
		let startOfDate1 = start(of: component, in: date1)
		let startOfDate2 = start(of: component, in: date2)
		return startOfDate1 == startOfDate2
	}

	public func compare(_ date1: Date?, _ date2: Date?) -> ComparisonResult {
		if date1 != nil && date2 != nil {
			return date1!.compare(date2!)
		} else if date1 != nil {
			return .orderedAscending
		} else if date2 != nil {
			return .orderedDescending
		} else {
			return .orderedSame
		}
	}
}
