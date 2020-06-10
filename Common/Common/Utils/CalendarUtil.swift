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
	func date(from dateString: String, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> Date?
	func date(_ date1: Date, occursOnSame component: Calendar.Component, as date2: Date) -> Bool
	func compare(_ date1: Date?, _ date2: Date?) -> ComparisonResult
	func date<CollectionType: Collection>(_ date: Date, isOnOneOf daysOfWeek: CollectionType) -> Bool where CollectionType.Element == DayOfWeek
	func date(_ date: Date, isOnA dayOfWeek: DayOfWeek) -> Bool
	/// If `format` is `nil`, will attempt to convert the date string to a date using standard formats,
	/// otherwise will only attempt using the given format.
	/// - Returns: The date represented by the passed String if it can be converted, otherwise `nil`.
	func date(from dateStr: String, format: String?) -> Date?
	func dayOfWeek(forDate date: Date) -> DayOfWeek
	func distance(from date1: Date, to date2: Date, in unit: Calendar.Component) throws -> Int
	// need to inject this dependency for testing
	func currentTimeZone() -> TimeZone
	func ago(_ numUnits: Int, _ timeUnit: Calendar.Component) -> Date
}

public extension CalendarUtil {
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

	/// This is only used for testing
	private final var timeZone: TimeZone?
	private final let log = Log()

	public enum Errors: String, Error {
		case invalidCalendarComponent
	}

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
		formatter.timeZone = nil
		return formatter.string(from: date)
	}

	public final func date(from dateString: String, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> Date? {
		let formatter = DateFormatter()
		formatter.dateStyle = dateStyle
		formatter.timeStyle = timeStyle
		formatter.timeZone = nil
		return formatter.date(from: dateString)
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

	public final func date<CollectionType: Collection>(_ date: Date, isOnOneOf daysOfWeek: CollectionType) -> Bool
	where CollectionType.Element == DayOfWeek {
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

	/// If `format` is `nil`, will attempt to convert the date string to a date using standard formats,
	/// otherwise will only attempt using the given format.
	/// - Returns: The date represented by the passed String if it can be converted, otherwise `nil`.
	public final func date(from dateStr: String, format: String?) -> Date? {
		let realFormat = format ?? defaultDateFormat
		let calendar = Calendar.autoupdatingCurrent
		let region = Region(calendar: calendar, zone: calendar.timeZone)
		if let date = Date(dateStr, format: realFormat, region: region) {
			return date
		}
		if format == nil {
			if let dateDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue) {
				let fullRangeOfString = NSRange(location: 0, length: dateStr.count)
				let matches = dateDetector.matches(in: dateStr, range: fullRangeOfString)
				let possibleDates = matches.filter{ $0.range == fullRangeOfString }.compactMap{$0.date}
				if possibleDates.count > 0 {
					return possibleDates[0]
				}
			}
		}
		return nil
	}

	public final func dayOfWeek(forDate date: Date) -> DayOfWeek {
		let calendar = Calendar.current
		let dayOfWeekIntForDate = calendar.component(.weekday, from: date) - 1
		return DayOfWeek.fromInt(dayOfWeekIntForDate)
	}

	public final func distance(from date1: Date, to date2: Date, in unit: Calendar.Component) throws -> Int {
		guard let distance = Calendar.autoupdatingCurrent.dateComponents([unit], from: date1, to: date2).in(unit) else {
			log.error("Unable to calculate date distance in %@", unit.description)
			throw Errors.invalidCalendarComponent
		}
		return distance
	}

	// need to inject this dependency for testing
	public final func currentTimeZone() -> TimeZone {
		return timeZone ?? TimeZone.autoupdatingCurrent
	}

	/// This is used only for testing
	public final func setTimeZone(_ timeZone: TimeZone) {
		self.timeZone = timeZone
	}

	public final func ago(_ numUnits: Int, _ timeUnit: Calendar.Component) -> Date {
		switch (timeUnit) {
			case .year: return Date() - numUnits.years
			case .month: return Date() - numUnits.months
			case .weekOfYear: return Date() - numUnits.weeks
			case .day: return Date() - numUnits.days
			case .hour: return Date() - numUnits.hours
			case .minute: return Date() - numUnits.minutes
			case .second: return Date() - numUnits.seconds
			default:
				log.error("Unsupported time unit: ", timeUnit.description)
				return Date()
		}
	}
}
