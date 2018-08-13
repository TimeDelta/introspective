//
//  TimeOfDay.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public struct TimeOfDay {

	public var hour: Int = 0
	public var minute: Int = 0
	public var second: Int = 0
	public var nanosecond: Int = 0

	public init() {}

	public init(_ date: Date) {
		let calendar = Calendar.autoupdatingCurrent
		hour = calendar.component(.hour, from: date)
		minute = calendar.component(.minute, from: date)
		second = calendar.component(.second, from: date)
		nanosecond = calendar.component(.nanosecond, from: date)
	}

	public init?(_ str: String) {
		let strStrippedOfAmPm = str.trimmingCharacters(in: CharacterSet(charactersIn: "apm "))
		let parts = strStrippedOfAmPm.split(separator: ":")
		// very minor sacrifice to speed to ensure readability here
		// - nesting all parts inside each other is technically faster
		//   in cases where not all parts are provided but speed gain
		//   is very minor so favor readability
		if parts.count > 0 {
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
		if parts.count > 3 {
			guard let n = Int(parts[3]) else { return nil }
			nanosecond = n
		}
	}

	public nonmutating func toString() -> String {
		var text = ""
		if userPrefers12hrTime() {
			if hour > 12 {
				text += padLeft(String(hour - 12))
			} else if hour == 0 {
				text += "12"
			} else {
				text += padLeft(String(hour))
			}
		} else {
			text += padLeft(String(hour))
		}

		text += ":" + padLeft(String(minute))

		if second > 0 || nanosecond > 0 {
			text += ":" + padLeft(String(second))
		}

		if nanosecond > 0 {
			text += ":" + padLeft(String(nanosecond))
		}

		if userPrefers12hrTime() {
			if hour > 11 {
				text += " " + Calendar.autoupdatingCurrent.pmSymbol
			} else {
				text += " " + Calendar.autoupdatingCurrent.amSymbol
			}
		}

		return text
	}

	fileprivate func userPrefers12hrTime() -> Bool {
		let locale = NSLocale.current
		let formatter = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
		return formatter.contains("a")
	}

	fileprivate func padLeft(_ str: String) -> String {
		if str.count == 1 {
			return "0" + str
		}
		return str
	}
}

extension Date {

	public static func <(lhs: Date, rhs: TimeOfDay) -> Bool {
		return lhs.isBefore(timeOfDay: rhs)
	}

	public static func >(lhs: Date, rhs: TimeOfDay) -> Bool {
		return lhs.isAfter(timeOfDay: rhs)
	}

	public static func <=(lhs: Date, rhs: TimeOfDay) -> Bool {
		let comparisonResult = lhs.compare(to: rhs)
		return comparisonResult == .orderedAscending || comparisonResult == .orderedSame
	}

	public static func >=(lhs: Date, rhs: TimeOfDay) -> Bool {
		let comparisonResult = lhs.compare(to: rhs)
		return comparisonResult == .orderedDescending || comparisonResult == .orderedSame
	}

	public init(_ timeOfDay: TimeOfDay) {
		self.init()
		let calendar = Calendar.autoupdatingCurrent
		self = calendar.date(bySettingHour: timeOfDay.hour, minute: timeOfDay.minute, second: timeOfDay.second, of: self)!
		self = calendar.date(bySetting: .nanosecond, value: timeOfDay.nanosecond, of: self)!
	}

	public func isBefore(timeOfDay: TimeOfDay) -> Bool {
		return compare(to: timeOfDay) == .orderedAscending
	}

	public func isAfter(timeOfDay: TimeOfDay) -> Bool {
		return compare(to: timeOfDay) == .orderedDescending
	}

	public func compare(to timeOfDay: TimeOfDay) -> ComparisonResult {
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

		let nanosecond = calendar.component(.nanosecond, from: self)
		if nanosecond < timeOfDay.nanosecond { return .orderedAscending }
		if nanosecond > timeOfDay.nanosecond { return .orderedDescending }

		return .orderedSame
	}
}
