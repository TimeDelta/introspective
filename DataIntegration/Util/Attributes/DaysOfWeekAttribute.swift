//
//  DaysOfWeekAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DaysOfWeekAttribute: AnyMultiSelectAttribute {

	public required init(name: String = "Days of the week", description: String? = nil) {
		super.init(name: name, description: description, possibleValues: DayOfWeek.allDays)
	}

	public override func errorMessageFor(invalidValue: String) -> String {
		for day in invalidValue.split(separator: separator) {
			let dayOfWeek = try? DayOfWeek.fromString(String(day))
			if dayOfWeek == nil {
				return "\"\(day)\" is not a day of the week"
			}
		}
		return "No days selected"
	}

	public override func convertToValue(from strValue: String) throws -> Any {
		var daysOfWeek = Set<DayOfWeek>()
		for day in strValue.split(separator: separator) {
			let dayAbbreviation = day.trimmingCharacters(in: .whitespacesAndNewlines)
			let dayOfWeek = try DayOfWeek.fromString(dayAbbreviation)
			daysOfWeek.insert(dayOfWeek)
		}
		return daysOfWeek
	}

	public override func convertToString(from value: Any) throws -> String {
		if let castedValue = value as? Set<DayOfWeek> {
			let sortedDaysOfWeek = castedValue.sorted(by: { (day1, day2) -> Bool in day1.intValue < day2.intValue } )
			return sortedDaysOfWeek.map{ day in return day.abbreviation }.joined(separator: String(separator))
		}
		if let castedValue = value as? [DayOfWeek] {
			let sortedDaysOfWeek = castedValue.sorted(by: { (day1, day2) -> Bool in day1.intValue < day2.intValue } )
			return sortedDaysOfWeek.map{ day in return day.abbreviation }.joined(separator: String(separator))
		}
		if let castedValue = value as? DayOfWeek {
			return castedValue.abbreviation
		}
		throw AttributeError.typeMismatch
	}

	public override func convertToDisplayableString(from value: Any) throws -> String {
		if let castedValue = value as? Set<DayOfWeek> {
			let sortedDaysOfWeek = castedValue.sorted(by: { (day1, day2) -> Bool in day1.intValue < day2.intValue } )
			return convertDaysOfWeekIntoDisplayString(sortedDaysOfWeek)
		}
		if let castedValue = value as? [DayOfWeek] {
			let sortedDaysOfWeek = castedValue.sorted(by: { (day1, day2) -> Bool in day1.intValue < day2.intValue } )
			return convertDaysOfWeekIntoDisplayString(sortedDaysOfWeek)
		}
		if let castedValue = value as? DayOfWeek {
			return castedValue.abbreviation
		}
		throw AttributeError.typeMismatch
	}

	public override func indexOf(possibleValue: Any) -> Int? {
		guard let castedValue = possibleValue as? DayOfWeek else {
			return nil
		}
		return DayOfWeek.allDays.firstIndex(of: castedValue)
	}

	public override func valueAsArray(_ value: Any) throws -> [Any] {
		if let castedValue = value as? Set<DayOfWeek> {
			return castedValue.map { v in return v }
		}
		if let castedValue = value as? [DayOfWeek] {
			return castedValue
		}
		throw AttributeError.unsupportedValue
	}

	public override func valueFromArray(_ value: [Any]) throws -> Any {
		guard let castedValue = value as? [DayOfWeek] else {
			throw AttributeError.typeMismatch
		}
		return Set<DayOfWeek>(castedValue)
	}

	fileprivate func convertDaysOfWeekIntoDisplayString(_ sortedDaysOfWeek: [DayOfWeek]) -> String {
		var text = ""
		let dayAbbreviations = sortedDaysOfWeek.map{ day in return day.abbreviation }
		for index in 0 ..< dayAbbreviations.count {
			if index > 0 && index < dayAbbreviations.count - 1 {
				text += ", "
			}
			if index == dayAbbreviations.count - 1 {
				text += " or "
			}
			text += dayAbbreviations[index]
		}
		return text
	}
}
