//
//  DateTimeAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DateTimeAttribute: DateAttributeBase {

	public required convenience init(name: String, description: String? = nil) {
		self.init(name: name, description: description, latestDate: nil)
	}

	public init(name: String, description: String? = nil, earliestDate: Date? = nil, latestDate: Date? = nil) {
		super.init(
			name: name,
			description: description,
			includeTime: true,
			earliestDate: earliestDate,
			latestDate: latestDate)
	}
}
