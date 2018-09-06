//
//  DaysOfWeekAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class DaysOfWeekAttribute: ComparableTypedMultiSelectAttribute<DayOfWeek> {

	public init(name: String = "Days of the week", pluralName: String? = "Days of the week", description: String? = nil, variableName: String? = nil) {
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			possibleValues: DayOfWeek.allDays,
			possibleValueToString: { $0.abbreviation })
	}
}
