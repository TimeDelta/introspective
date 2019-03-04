//
//  CalendarUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftDate

public let defaultDateFormat = "MMMM d yyyy 'at' H:mm:ss"

//sourcery: AutoMockable
public protocol CalendarUtil {
	func convert(_ date: Date, from fromTimeZone: TimeZone, to toTimeZone: TimeZone) -> Date
	/// Set all components of the specified date less than the specified component to the minimum value for that component.
	/// - Parameter component: Must be one of the following values: `.year`, `.month`, `.weekOfYear`, `.day`, `.hour`, `.minute`, `.second`, `.nanosecond`
	func start(of component: Calendar.Component, in date: Date) -> Date
	/// Set all components of the specified date less than the specified component to the maximum value for that component.
	/// - Parameter component: Must be one of the following values: `.year`, `.month`, `.weekOfYear`, `.day`, `.hour`, `.minute`, `.second`, `.nanosecond`
	func end(of component: Calendar.Component, in date: Date) -> Date
	func string(for date: Date, inFormat format: String) -> String
	func string(for date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String
	func date(_ date1: Date, occursOnSame component: Calendar.Component, as date2: Date) -> Bool
	func compare(_ date1: Date?, _ date2: Date?) -> ComparisonResult
	func date<CollectionType: Collection>(_ date: Date, isOnOneOf daysOfWeek: CollectionType) -> Bool where CollectionType.Element == DayOfWeek
	func date(_ date: Date, isOnA dayOfWeek: DayOfWeek) -> Bool
	/// If `format` is `nil`, will attempt to convert the date string to a date using standard formats,
	/// otherwise will only attempt using the given format.
	/// - Returns: The date represented by the passed String if it can be converted, otherwise `nil`.
	func date(from dateStr: String, format: String?) -> Date?
	func distance(from date1: Date, to date2: Date, in unit: Calendar.Component) -> Int
}

extension CalendarUtil {
	func string(for date: Date, inFormat format: String = defaultDateFormat) -> String {
		return string(for: date, inFormat: format)
	}
	/// If `format` is `nil`, will attempt to convert the date string to a date using standard formats,
	/// otherwise will only attempt using the given format.
	/// - Returns: The date represented by the passed String if it can be converted, otherwise `nil`.
	func date(from dateStr: String, format: String? = nil) -> Date? {
		return date(from: dateStr, format: format)
	}
}

public final class CalendarUtilImpl: CalendarUtil {

	public final func convert(_ date: Date, from fromTimeZone: TimeZone, to toTimeZone: TimeZone) -> Date {
		let delta = TimeInterval(toTimeZone.secondsFromGMT() - fromTimeZone.secondsFromGMT())
		return date.addingTimeInterval(delta)
	}

	/// Set all components of the specified date less than the specified component to the minimum value for that component.
	/// - Parameter component: Must be one of the following values: `.year`, `.month`, `.weekOfYear`, `.day`, `.hour`, `.minute`, `.second`, `.nanosecond`
	public final func start(of component: Calendar.Component, in date: Date) -> Date {
		if component == .nanosecond { return date }
		let calendar = Calendar.autoupdatingCurrent
		let dateInRegion = DateInRegion(date, region: Region(calendar: calendar, zone: calendar.timeZone))
		let start = dateInRegion.dateAtStartOf(component)
		return start.date
	}

	/// Set all components of the specified date less than the specified component to the maximum value for that component.
	/// - Parameter component: Must be one of the following values: `.year`, `.month`, `.weekOfYear`, `.day`, `.hour`, `.minute`, `.second`, `.nanosecond`
	public final func end(of component: Calendar.Component, in date: Date) -> Date {
		if component == .nanosecond { return date }
		let calendar = Calendar.autoupdatingCurrent
		let dateInRegion = DateInRegion(date, region: Region(calendar: calendar, zone: calendar.timeZone))
		let end = dateInRegion.dateAtEndOf(component)
		return end.date
	}

	public final func string(for date: Date, inFormat format: String) -> String {
		let calendar = Calendar.autoupdatingCurrent
		let dateInRegion = DateInRegion(date, region: Region(calendar: calendar, zone: calendar.timeZone))
		return dateInRegion.toFormat(format)
	}

	public final func string(for date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = dateStyle
		formatter.timeStyle = timeStyle
		return formatter.string(from: date)
	}

	public final func date(_ date1: Date, occursOnSame component: Calendar.Component, as date2: Date) -> Bool {
		let startOfDate1 = start(of: component, in: date1)
		let startOfDate2 = start(of: component, in: date2)
		return startOfDate1 == startOfDate2
	}

	public final func compare(_ date1: Date?, _ date2: Date?) -> ComparisonResult {
		if date1 != nil && date2 != nil {
			return date1!.compare(date2!)
		}
		if date1 != nil { return .orderedAscending }
		if date2 != nil { return .orderedDescending }
		return .orderedSame
	}

	public final func date<CollectionType: Collection>(_ date: Date, isOnOneOf daysOfWeek: CollectionType) -> Bool where CollectionType.Element == DayOfWeek {
		let calendar = Calendar.current
		let dayOfWeekIntForDate = calendar.component(.weekday, from: date) - 1
		let dayOfWeekForDate = DayOfWeek.fromInt(dayOfWeekIntForDate)
		return daysOfWeek.contains(dayOfWeekForDate)
	}

	public final func date(_ date: Date, isOnA dayOfWeek: DayOfWeek) -> Bool {
		let calendar = Calendar.current
		let dayOfWeekIntForDate = calendar.component(.weekday, from: date)
		let dayOfWeekForDate = DayOfWeek.fromInt(dayOfWeekIntForDate)
		return dayOfWeekForDate == dayOfWeek
	}

	/// If `format` is `nil`, will attempt to convert the date string to a date using standard formats, otherwise will only attempt using the given format.
	/// - Returns: The date represented by the passed String if it can be converted, otherwise `nil`.
	public final func date(from dateStr: String, format: String?) -> Date? {
		let realFormat = format ?? defaultDateFormat
		let calendar = Calendar.autoupdatingCurrent
		let region = Region(calendar: calendar, zone: calendar.timeZone)
		if let date = Date(dateStr, format: realFormat, region: region) {
			return date
		}
		if format == nil {
			return (try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
				.matches(in: dateStr, range: NSRange(location: 0, length: dateStr.count))
				.compactMap{$0.date})?[0]
		}
		return nil
	}

	public final func distance(from date1: Date, to date2: Date, in unit: Calendar.Component) -> Int {
		return abs(Calendar.autoupdatingCurrent.dateComponents([unit], from: date1, to: date2).in(unit)!)
	}
}

extension Calendar.Component: CustomStringConvertible {

	public enum Errors: Error {
		case unkownComponentName
	}

	public var description: String {
		switch (self) {
			case .calendar: return "Calendar"
			case .era: return "Era"
			case .year: return "Year"
			case .yearForWeekOfYear: return "Year For Week Of Year"
			case .quarter: return "Quarter"
			case .month: return "Month"
			case .weekOfMonth: return "Week Of Month"
			case .weekOfYear: return "Week"
			case .weekday: return "Day of week"
			case .weekdayOrdinal: return "Weekday Ordinal"
			case .timeZone: return "TimeZone"
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
			case "timezone": return .timeZone
			case "day": return .day
			case "hour": return .hour
			case "minute": return .minute
			case "second": return .second
			case "nanosecond": return .nanosecond
			default: throw Errors.unkownComponentName
		}
	}
}
