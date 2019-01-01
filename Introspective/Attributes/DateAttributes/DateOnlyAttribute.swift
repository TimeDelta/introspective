//
//  DateOnlyAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class DateOnlyAttribute: DateAttributeBase {

	public init(
		name: String = "Date",
		pluralName: String? = "Dates",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		earliestDate: Date? = nil,
		latestDate: Date? = nil)
	{
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional,
			includeTime: false,
			format: "MMMM d, yyyy",
			earliestDate: earliestDate,
			latestDate: latestDate)
	}
}
