//
//  DateAttributeBase.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DateAttributeBase: AttributeBase, DateAttribute {

	public final let includeTime: Bool
	public final let earliestDate: Date?
	public final let latestDate: Date?

	private final var dateFormat: String

	public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		includeTime: Bool = true,
		format: String = defaultDateFormat,
		earliestDate: Date? = nil,
		latestDate: Date? = nil)
	{
		self.includeTime = includeTime
		self.dateFormat = format
		self.earliestDate = earliestDate
		self.latestDate = latestDate
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional)
	}

	public final override func isValid(value: Any?) -> Bool {
		return (value == nil && optional) || value as? Date != nil
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? Date else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return DependencyInjector.util.calendar.string(for: castedValue, inFormat: dateFormat)
	}
}
