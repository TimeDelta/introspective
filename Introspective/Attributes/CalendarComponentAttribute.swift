//
//  CalendarComponentAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class CalendarComponentAttribute: TypedSelectOneAttribute<Calendar.Component> {

	private typealias Me = CalendarComponentAttribute

	public static let supportedComponents: [Calendar.Component] = [
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

	public init(
		name: String = "Time unit",
		pluralName: String? = "Time units",
		description: String? = nil,
		variableName: String? = nil,
		possibleValues: [Calendar.Component] = CalendarComponentAttribute.supportedComponents)
	{
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			possibleValues: possibleValues,
			possibleValueToString: { $0.description },
			areEqual: { $0 == $1 })
	}
}
