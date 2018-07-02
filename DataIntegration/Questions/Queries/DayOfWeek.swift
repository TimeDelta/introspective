//
//  DayOfWeek.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class DayOfWeek: NSObject {

	enum ErrorTypes: Error {
		case UnknownDayOfWeek
	}

	public static let Sunday = DayOfWeek(0, "sun", "Sunday")
	public static let Monday = DayOfWeek(1, "mon", "Monday")
	public static let Tuesday = DayOfWeek(2, "tues", "Tuesday")
	public static let Wednesday = DayOfWeek(3, "wed", "Wednesday")
	public static let Thursday = DayOfWeek(4, "thur", "Thursday")
	public static let Friday = DayOfWeek(5, "fri", "Friday")
	public static let Saturday = DayOfWeek(6, "sat", "Saturday")

	static fileprivate let allDays = [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday]

	public fileprivate(set) var fullDayName: String
	public fileprivate(set) var intValue: Int
	fileprivate var minRequiredString: String

	fileprivate init(_ intValue: Int, _ minRequiredString: String, _ fullDayName: String) {
		self.intValue = intValue
		self.minRequiredString = minRequiredString
		self.fullDayName = fullDayName
	}

	public static func fromString(_ str: String) throws -> DayOfWeek? {
		let dayName = str.lowercased()
		for day in allDays {
			if dayName.contains(day.minRequiredString) {
				return day
			}
		}
		throw ErrorTypes.UnknownDayOfWeek
	}

	public static func fromInt(_ intValue: Int) -> DayOfWeek {
		return allDays[intValue]
	}
}
