//
//  DateTimeAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class DateTimeAttribute: DateAttributeBase {

	public final override var typeName: String {
		return "Date & Time"
	}

	public init(
		name: String = "Date and time",
		pluralName: String? = "Dates and times",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		format: String = defaultDateFormat,
		earliestDate: Date? = nil,
		latestDate: Date? = nil)
	{
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional,
			includeTime: true,
			format: format,
			earliestDate: earliestDate,
			latestDate: latestDate)
	}

	public final override func typedValuesAreEqual(_ first: Date, _ second: Date) -> Bool {
		return first == second
	}
}
