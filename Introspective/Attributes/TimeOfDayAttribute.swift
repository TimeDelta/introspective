//
//  TimeOfDayAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 8/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class TimeOfDayAttribute: AttributeBase<TimeOfDay>, ComparableAttribute {

	public final override var typeName: String {
		return "Time Unit"
	}

	public override init(
		name: String = "Time of day",
		pluralName: String? = "Times of day",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false)
	{
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional)
	}

	public final override func isValid(value: Any?) -> Bool {
		return (value == nil && optional) || value as? TimeOfDay != nil
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? TimeOfDay else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return castedValue.toString()
	}
}
