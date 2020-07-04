//
//  TimeOfDay.swift
//  Introspective
//
//  Created by Bryan Nova on 8/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection

public struct TimeOfDay: Comparable {
	public static func == (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
		lhs.hour == rhs.hour
			&& lhs.minute == rhs.minute
			&& lhs.second == rhs.second
	}

	public static func != (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
		lhs.hour != rhs.hour
			|| lhs.minute != rhs.minute
			|| lhs.second != rhs.second
	}

	public static func < (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
		lhs.compare(to: rhs) == .orderedAscending
	}

	public static func > (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
		lhs.compare(to: rhs) == .orderedDescending
	}

	public var hour: Int = 0
	public var minute: Int = 0
	public var second: Int = 0

	public init() {}

	public init(_ date: Date) {
		let calendar = Calendar.autoupdatingCurrent
		hour = calendar.component(.hour, from: date)
		minute = calendar.component(.minute, from: date)
		second = calendar.component(.second, from: date)
	}

	public init?(_ str: String) {
		let strStrippedOfAmPm = str.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: "apm "))
		let parts = strStrippedOfAmPm.split(separator: ":")
		// very minor sacrifice to speed to ensure readability here
		// - nesting all parts inside each other is technically faster
		//   in cases where not all parts are provided but speed gain
		//   is very minor so favor readability
		if !parts.isEmpty {
			guard let h = Int(parts[0]) else { return nil }
			hour = h
			if str.lowercased().contains("pm") && hour < 12 {
				hour += 12
			}
		}
		if parts.count > 1 {
			guard let m = Int(parts[1]) else { return nil }
			minute = m
		}
		if parts.count > 2 {
			guard let s = Int(parts[2]) else { return nil }
			second = s
		}
	}

	public nonmutating func toString(_ style: DateFormatter.Style = .medium) -> String {
		let date = Calendar.autoupdatingCurrent.date(bySettingHour: hour, minute: minute, second: second, of: Date())!
		return DependencyInjector.get(CalendarUtil.self).string(for: date, dateStyle: .none, timeStyle: style)
	}

	private func compare(to other: TimeOfDay) -> ComparisonResult {
		if hour < other.hour { return .orderedAscending }
		if hour > other.hour { return .orderedDescending }

		if minute < other.minute { return .orderedAscending }
		if minute > other.minute { return .orderedDescending }

		if second < other.second { return .orderedAscending }
		if second > other.second { return .orderedDescending }

		return .orderedSame
	}
}

public extension Date {
	static func < (lhs: Date, rhs: TimeOfDay) -> Bool {
		lhs.isBefore(timeOfDay: rhs)
	}

	static func > (lhs: Date, rhs: TimeOfDay) -> Bool {
		lhs.isAfter(timeOfDay: rhs)
	}

	static func <= (lhs: Date, rhs: TimeOfDay) -> Bool {
		let comparisonResult = lhs.compare(to: rhs)
		return comparisonResult == .orderedAscending || comparisonResult == .orderedSame
	}

	static func >= (lhs: Date, rhs: TimeOfDay) -> Bool {
		let comparisonResult = lhs.compare(to: rhs)
		return comparisonResult == .orderedDescending || comparisonResult == .orderedSame
	}

	init(_ timeOfDay: TimeOfDay) {
		self.init()
		let calendar = Calendar.autoupdatingCurrent
		self = calendar.date(
			bySettingHour: timeOfDay.hour,
			minute: timeOfDay.minute,
			second: timeOfDay.second,
			of: self
		)!
		self = calendar.date(bySetting: .nanosecond, value: 0, of: self)!
	}

	func isBefore(timeOfDay: TimeOfDay) -> Bool {
		compare(to: timeOfDay) == .orderedAscending
	}

	func isAfter(timeOfDay: TimeOfDay) -> Bool {
		compare(to: timeOfDay) == .orderedDescending
	}

	func compare(to timeOfDay: TimeOfDay) -> ComparisonResult {
		let calendar = Calendar.autoupdatingCurrent

		let hour = calendar.component(.hour, from: self)
		if hour < timeOfDay.hour { return .orderedAscending }
		if hour > timeOfDay.hour { return .orderedDescending }

		let minute = calendar.component(.minute, from: self)
		if minute < timeOfDay.minute { return .orderedAscending }
		if minute > timeOfDay.minute { return .orderedDescending }

		let second = calendar.component(.second, from: self)
		if second < timeOfDay.second { return .orderedAscending }
		if second > timeOfDay.second { return .orderedDescending }

		return .orderedSame
	}
}
