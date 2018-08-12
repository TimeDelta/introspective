//
//  TimeOfDayAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class TimeOfDayAttribute: AnyAttribute {

	public required init(name: String = "Time of day", pluralName: String? = "Times of day", description: String? = nil) {
		super.init(name: name, pluralName: pluralName, description: description)
	}

	public override func isValid(value: String) -> Bool {
		return TimeOfDay(value) != nil
	}

	public override func errorMessageFor(invalidValue: String) -> String {
		return "\(invalidValue) is not a time of day"
	}

	public override func convertToValue(from strValue: String) throws -> Any {
		return TimeOfDay(strValue)!
	}

	public override func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? TimeOfDay else { throw AttributeError.typeMismatch }
		return castedValue.toString()
	}
}
