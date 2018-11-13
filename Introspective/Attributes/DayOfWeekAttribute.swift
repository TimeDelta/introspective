//
//  DayOfWeekAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class DayOfWeekAttribute: TypedSelectOneAttribute<DayOfWeek>, ComparableAttribute {

	public init(
		name: String = "Day of the week",
		pluralName: String? = "Day of the week",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false)
	{
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional,
			possibleValues: DayOfWeek.allDays,
			possibleValueToString: { $0.abbreviation },
			areEqual: { $0 == $1 })
	}
}
