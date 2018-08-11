//
//  DayOfWeekAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DayOfWeekAttribute: AnyAttribute, SelectOneAttribute {

	public fileprivate(set) var possibleValues: [Any] = DayOfWeek.allDays

	public required init(name: String = "Day of the week", pluralName: String? = "Days of the week", description: String? = nil) {
		super.init(name: name, pluralName: pluralName, description: description)
	}

	public override func isValid(value: String) -> Bool {
		return (try? DayOfWeek.fromString(value)) != nil
	}

	public override func errorMessageFor(invalidValue: String) -> String {
		if invalidValue.isEmpty {
			return "No value selected"
		}
		return "\"\(invalidValue)\" is not a day of the week"
	}

	public override func convertToValue(from strValue: String) throws -> Any {
		return try DayOfWeek.fromString(strValue)
	}

	public override func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? DayOfWeek else {
			throw AttributeError.typeMismatch
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
