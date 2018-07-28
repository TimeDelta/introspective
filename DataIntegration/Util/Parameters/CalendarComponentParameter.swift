//
//  CalendarComponentAggregationParameter.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class CalendarComponentParameter: SelectOneParameter {

	fileprivate typealias Me = CalendarComponentParameter

	fileprivate static let supportedComponents: [Calendar.Component] = [
		.year,
		.quarter,
		.month,
		.weekOfMonth,
		.weekOfYear,
		.weekday,
		.day,
		.hour,
		.minute,
		.second,
		.nanosecond,
	]
	fileprivate static let setOfSupportedComponents: Set<Calendar.Component> = Set<Calendar.Component>(supportedComponents)

	public fileprivate(set) var name: String
	public fileprivate(set) var extendedDescription: String?
	/// If this is nil, it means this parameter takes an open value
	public let possibleValues: [Any] = Me.supportedComponents

	public init(name: String, description: String?) {
		self.name = name
		self.extendedDescription = description
	}

	public func isValid(value: String) -> Bool {
		let component = try? Calendar.Component.from(string: value)
		return component != nil && Me.setOfSupportedComponents.contains(component!)
	}

	public func errorMessageFor(invalidValue: String) -> String {
		return "\"\(invalidValue)\" is not a supported unit of time."
	}

	public func convertToValue(from strValue: String) throws -> Any {
		let component = try? Calendar.Component.from(string: strValue)
		if component == nil || !Me.setOfSupportedComponents.contains(component!) {
			throw ParameterError.unsupportedValue
		}
		return component!
	}

	public func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? Calendar.Component else {
			throw ParameterError.typeMismatch
		}
		return castedValue.description
	}

	public func indexOf(possibleValue: Any) -> Int? {
		guard let castedValue = possibleValue as? Calendar.Component else {
			return nil
		}
		return Me.supportedComponents.firstIndex(of: castedValue)
	}
}
