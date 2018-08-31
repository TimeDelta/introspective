//
//  DateAttributeBase.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DateAttributeBase: AttributeBase, DateAttribute {

	public private(set) final var includeTime: Bool
	public private(set) final var earliestDate: Date?
	public private(set) final var latestDate: Date?

	private final var dateFormat: String

	public required convenience init(name: String, pluralName: String? = nil, description: String? = nil, variableName: String? = nil) {
		self.init(name: name, pluralName: pluralName, description: description, variableName: variableName, latestDate: nil)
	}

	public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		includeTime: Bool = true,
		format: String = defaultDateFormat,
		earliestDate: Date? = nil,
		latestDate: Date? = nil)
	{
		self.includeTime = includeTime
		self.dateFormat = format
		self.earliestDate = earliestDate
		self.latestDate = latestDate
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName)
	}

	public final override func isValid(value: String) -> Bool {
		return DependencyInjector.util.calendarUtil.date(from: value, format: dateFormat) != nil
	}

	public final override func errorMessageFor(invalidValue: String) -> String {
		return "\"" + invalidValue + "\" is not a date"
	}

	public final override func convertToValue(from strValue: String) throws -> Any {
		return DependencyInjector.util.calendarUtil.date(from: strValue, format: dateFormat)!
	}

	public final override func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? Date else {
			throw AttributeError.typeMismatch
		}
		return DependencyInjector.util.calendarUtil.string(for: castedValue, inFormat: dateFormat)
	}
}
