//
//  CalendarComponentAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class CalendarComponentAttribute: AttributeBase, SelectOneAttribute {

	fileprivate typealias Me = CalendarComponentAttribute

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

	public let possibleValues: [Any] = Me.supportedComponents

	public required init(name: String = "Time unit", pluralName: String? = "Time units", description: String? = nil, variableName: String? = nil) {
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName)
	}

	public override func isValid(value: String) -> Bool {
		let component = try? Calendar.Component.from(string: value)
		return component != nil && Me.setOfSupportedComponents.contains(component!)
	}

	public override func errorMessageFor(invalidValue: String) -> String {
		return "\"\(invalidValue)\" is not a supported unit of time."
	}

	public override func convertToValue(from strValue: String) throws -> Any {
		let component = try? Calendar.Component.from(string: strValue)
		if component == nil || !Me.setOfSupportedComponents.contains(component!) {
			throw AttributeError.unsupportedValue
		}
		return component!
	}

	public override func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? Calendar.Component else {
			throw AttributeError.typeMismatch
		}
		return castedValue.description
	}

	public func indexOf(possibleValue: Any) -> Int? {
		guard let castedValue = possibleValue as? Calendar.Component else {
			return nil
		}
		return Me.supportedComponents.index(of: castedValue)
	}
}
