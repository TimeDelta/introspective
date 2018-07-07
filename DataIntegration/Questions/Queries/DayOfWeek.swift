//
//  DayOfWeek.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DayOfWeek: NSObject {

	public enum ErrorTypes: Error {
		case UnknownDayOfWeek
	}

	public static let Sunday = DayOfWeek(0, "Sun", "Sunday")
	public static let Monday = DayOfWeek(1, "Mon", "Monday")
	public static let Tuesday = DayOfWeek(2, "Tues", "Tuesday")
	public static let Wednesday = DayOfWeek(3, "Wed", "Wednesday")
	public static let Thursday = DayOfWeek(4, "Thurs", "Thursday")
	public static let Friday = DayOfWeek(5, "Fri", "Friday")
	public static let Saturday = DayOfWeek(6, "Sat", "Saturday")

	static fileprivate let allDays = [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday]

	public fileprivate(set) var fullDayName: String
	public fileprivate(set) var intValue: Int
	public fileprivate(set) var abbreviation: String

	fileprivate init(_ intValue: Int, _ minRequiredString: String, _ fullDayName: String) {
		self.intValue = intValue
		self.abbreviation = minRequiredString
		self.fullDayName = fullDayName
	}

	public static func fromString(_ str: String) throws -> DayOfWeek? {
		let dayName = str.lowercased()
		for day in allDays {
			if dayName.contains(day.abbreviation.lowercased()) {
				return day
			}
		}
		throw ErrorTypes.UnknownDayOfWeek
	}

	public static func fromInt(_ intValue: Int) -> DayOfWeek {
		return allDays[intValue]
	}
}
