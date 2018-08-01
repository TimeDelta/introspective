//
//  DateAttributeBase.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DateAttributeBase: AnyAttribute, DateAttribute {

	public fileprivate(set) var includeTime: Bool
	public fileprivate(set) var earliestDate: Date?
	public fileprivate(set) var latestDate: Date?

	fileprivate var dateFormat: String

	public required convenience init(name: String, description: String? = nil) {
		self.init(name: name, description: description, latestDate: nil)
	}

	public init(
		name: String,
		description: String? = nil,
		includeTime: Bool = true,
		format: String = CalendarUtil.defaultDateFormat,
		earliestDate: Date? = nil,
		latestDate: Date? = nil)
	{
		self.includeTime = includeTime
		self.dateFormat = format
		self.earliestDate = earliestDate
		self.latestDate = latestDate
		super.init(name: name, description: description)
	}

	public override func isValid(value: String) -> Bool {
		return DependencyInjector.util.calendarUtil.date(from: value, format: dateFormat) != nil
	}

	public override func errorMessageFor(invalidValue: String) -> String {
		return "\"" + invalidValue + "\" is not a date"
	}

	public override func convertToValue(from strValue: String) throws -> Any {
		return DependencyInjector.util.calendarUtil.date(from: strValue, format: dateFormat)!
	}

	public override func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? Date else {
			throw AttributeError.typeMismatch
		}
		return DependencyInjector.util.calendarUtil.string(for: castedValue, inFormat: dateFormat)
	}
}
