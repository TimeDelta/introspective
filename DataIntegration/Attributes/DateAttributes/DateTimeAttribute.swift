//
//  DateTimeAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DateTimeAttribute: DateAttributeBase {

	public required convenience init(name: String = "Date and time", pluralName: String? = "Dates and times", description: String? = nil, variableName: String? = nil) {
		self.init(name: name, pluralName: pluralName, description: description, variableName: variableName, latestDate: nil)
	}

	public init(name: String = "Date and time", pluralName: String? = "Dates and times", description: String? = nil, variableName: String? = nil, earliestDate: Date? = nil, latestDate: Date? = nil) {
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			includeTime: true,
			earliestDate: earliestDate,
			latestDate: latestDate)
	}
}
