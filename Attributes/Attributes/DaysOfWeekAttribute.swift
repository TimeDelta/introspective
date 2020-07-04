//
//  DaysOfWeekAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common

public final class DaysOfWeekAttribute: ComparableTypedMultiSelectAttribute<DayOfWeek> {
	override public final var typeName: String {
		"Days of the Week"
	}

	public init(
		name: String = "Days of the week",
		pluralName: String? = "Days of the week",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false
	) {
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional,
			possibleValues: DayOfWeek.allDays,
			possibleValueToString: { $0.abbreviation }
		)
	}
}
