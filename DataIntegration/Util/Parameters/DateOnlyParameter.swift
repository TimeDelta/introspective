//
//  DateOnlyParameter.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DateOnlyParameter: DateParameterBase {

	init(name: String, description: String? = nil, earliestDate: Date? = nil, latestDate: Date? = nil) {
		super.init(
			name: name,
			description: description,
			includeTime: false,
			format: "MMMM dd YYYY",
			earliestDate: earliestDate,
			latestDate: latestDate)
	}
}
