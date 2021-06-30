//
//  DateOnlyAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection

public final class DateOnlyAttribute: DateAttributeBase {
	public final override var typeName: String {
		"Date"
	}

	public init(
		id: Int16,
		name: String = "Date",
		pluralName: String? = "Dates",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		earliestDate: Date? = nil,
		latestDate: Date? = nil
	) {
		super.init(
			id: id,
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional,
			includeTime: false,
			format: "MMMM d, yyyy",
			earliestDate: earliestDate,
			latestDate: latestDate
		)
	}

	public final override func typedValuesAreEqual(_ first: Date, _ second: Date) -> Bool {
		let firstDate = injected(CalendarUtil.self).start(of: .day, in: first)
		let secondDate = injected(CalendarUtil.self).start(of: .day, in: second)
		return firstDate == secondDate
	}
}
