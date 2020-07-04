//
//  DayOfWeek.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class DayOfWeek: Hashable, Comparable {
	public enum ErrorTypes: Error {
		case UnknownDayOfWeek
	}

	public static let Sunday = DayOfWeek(0, "Sun", "Sunday")
	public static let Monday = DayOfWeek(1, "Mon", "Monday")
	public static let Tuesday = DayOfWeek(2, "Tue", "Tuesday")
	public static let Wednesday = DayOfWeek(3, "Wed", "Wednesday")
	public static let Thursday = DayOfWeek(4, "Thu", "Thursday")
	public static let Friday = DayOfWeek(5, "Fri", "Friday")
	public static let Saturday = DayOfWeek(6, "Sat", "Saturday")

	public static let allDays = [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday]

	public static func < (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
		lhs.intValue < rhs.intValue
	}

	public static func <= (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
		lhs.intValue <= rhs.intValue
	}

	public static func == (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
		lhs.intValue == rhs.intValue
	}

	public static func >= (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
		lhs.intValue >= rhs.intValue
	}

	public static func > (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
		lhs.intValue > rhs.intValue
	}

	/// - Throws: When not a valid day name
	public static func fromString(_ str: String) throws -> DayOfWeek {
		let dayName = str.lowercased()
		for day in allDays {
			if dayName.contains(day.abbreviation.lowercased()) {
				return day
			}
		}
		throw ErrorTypes.UnknownDayOfWeek
	}

	public static func fromInt(_ intValue: Int) -> DayOfWeek {
		allDays[intValue]
	}

	public var description: String {
		fullDayName
	}

	public final let fullDayName: String
	public final let intValue: Int
	public final let abbreviation: String

	private init(_ intValue: Int, _ minRequiredString: String, _ fullDayName: String) {
		self.intValue = intValue
		abbreviation = minRequiredString
		self.fullDayName = fullDayName
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(intValue)
	}
}
