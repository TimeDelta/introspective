//
//  CalendarComponentAggregationParameter.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class CalendarComponentAggregationParameter: Parameter {

	fileprivate typealias Me = CalendarComponentAggregationParameter

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
	fileprivate static let possibleValues: [String] = supportedComponents.map { (component: Calendar.Component) -> String in
		return component.description
	}
	fileprivate static let setOfPossibleValues: Set<String> = Set<String>(possibleValues)

	public fileprivate(set) var name: String
	public fileprivate(set) var extendedDescription: String?
	/// If this is nil, it means this parameter takes an open value
	public let possibleValues: [String]? = Me.possibleValues

	public init(name: String, description: String?) {
		self.name = name
		self.extendedDescription = description
	}

	public func isValid(value: String) -> Bool {
		return Me.setOfPossibleValues.contains(value)
	}

	public func errorMessageFor(invalidValue: String) -> String {
		return "\"\(invalidValue)\" is not a supported unit of time."
	}

	public func convertToValue(from strValue: String) throws -> Any {
		var index: Int = 0
		for value in possibleValues! {
			if value == strValue {
				break
			}
			index += 1
		}
		if index == possibleValues!.count {
			throw AggregationError.unsupportedValue
		}
		return Me.supportedComponents[index]
	}
}
