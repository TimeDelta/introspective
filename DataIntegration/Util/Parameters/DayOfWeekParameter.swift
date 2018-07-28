//
//  DayOfWeekParameter.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DayOfWeekParameter: SelectOneParameter {

	public fileprivate(set) var name: String
	public fileprivate(set) var extendedDescription: String?
	public fileprivate(set) var possibleValues: [Any] = DayOfWeek.allDays

	public init(name: String = "Day of the week", description: String? = nil) {
		self.name = name
		self.extendedDescription = description
	}

	public func isValid(value: String) -> Bool {
		return (try? DayOfWeek.fromString(value)) != nil
	}

	public func errorMessageFor(invalidValue: String) -> String {
		if invalidValue.isEmpty {
			return "No value selected"
		}
		return "\"\(invalidValue)\" is not a day of the week"
	}

	public func convertToValue(from strValue: String) throws -> Any {
		return try DayOfWeek.fromString(strValue)
	}

	public func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? DayOfWeek else {
			throw ParameterError.typeMismatch
		}
		return castedValue.abbreviation
	}

	public func indexOf(possibleValue: Any) -> Int? {
		guard let castedValue = possibleValue as? DayOfWeek else {
			return nil
		}
		return DayOfWeek.allDays.firstIndex(of: castedValue)
	}
}
