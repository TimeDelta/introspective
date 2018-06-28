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

	public static let Sunday = DayOfWeek(0, "sun")
	public static let Monday = DayOfWeek(1, "mon")
	public static let Tuesday = DayOfWeek(2, "tues")
	public static let Wednesday = DayOfWeek(3, "wed")
	public static let Thursday = DayOfWeek(4, "thur")
	public static let Friday = DayOfWeek(5, "fri")
	public static let Saturday = DayOfWeek(6, "sat")

	static fileprivate let allDays = [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday]

	fileprivate var intValue: Int
	fileprivate var minRequiredString: String

	fileprivate init(_ intValue: Int, _ minRequiredString: String) {
		self.intValue = intValue
		self.minRequiredString = minRequiredString
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
}
