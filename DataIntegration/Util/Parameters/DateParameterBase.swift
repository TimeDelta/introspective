//
//  DateTimeParameter.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DateParameterBase: DateParameter {

	public fileprivate(set) var name: String
	public fileprivate(set) var extendedDescription: String?
	public fileprivate(set) var includeTime: Bool
	public fileprivate(set) var earliestDate: Date?
	public fileprivate(set) var latestDate: Date?

	fileprivate var dateFormat: String

	init(
		name: String,
		description: String? = nil,
		includeTime: Bool = true,
		format: String = CalendarUtil.defaultDateFormat,
		earliestDate: Date? = nil,
		latestDate: Date? = nil)
	{
		self.name = name
		self.extendedDescription = description
		self.includeTime = includeTime
		self.dateFormat = format
		self.earliestDate = earliestDate
		self.latestDate = latestDate
	}

	public func isValid(value: String) -> Bool {
		return DependencyInjector.util.calendarUtil.date(from: value, format: dateFormat) != nil
	}

	public func errorMessageFor(invalidValue: String) -> String {
		return "\"" + invalidValue + "\" is not a date"
	}

	public func convertToValue(from strValue: String) throws -> Any {
		return DependencyInjector.util.calendarUtil.date(from: strValue, format: dateFormat)!
	}

	public func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? Date else {
			throw ParameterError.typeMismatch
		}
		return DependencyInjector.util.calendarUtil.string(for: castedValue, inFormat: dateFormat)
	}
}
