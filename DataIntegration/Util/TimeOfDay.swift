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

	public init?(_ str: String) {
		let parts = str.split(separator: ":")
		// very minor sacrifice to speed to ensure readability here
		// - nesting all parts inside each other is technically faster
		//   in cases where not all parts are provided but speed gain
		//   is very minor so favor readability
		if parts.count > 0 {
			guard let h = Int(parts[0]) else { return nil }
			hour = h
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
		var text = String(hour) + ":" + String(minute)
		if second > 0 || nanosecond > 0 {
			text += ":" + String(second)
		}
		if nanosecond > 0 {
			text += ":" + String(nanosecond)
		}
		return text
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
