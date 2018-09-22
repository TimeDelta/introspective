//
//  DateAttributeBase.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DateAttributeBase: AttributeBase, DateAttribute {

	public final let includeTime: Bool
	public final let earliestDate: Date?
	public final let latestDate: Date?

	private final var dateFormat: String

	public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		includeTime: Bool = true,
		format: String = defaultDateFormat,
		earliestDate: Date? = nil,
		latestDate: Date? = nil)
	{
		self.includeTime = includeTime
		self.dateFormat = format
		self.earliestDate = earliestDate
		self.latestDate = latestDate
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName)
	}

	public final override func convertToDisplayableString(from value: Any) throws -> String {
		guard let castedValue = value as? Date else {
			throw AttributeError.typeMismatch
		}
		return DependencyInjector.util.calendarUtil.string(for: castedValue, inFormat: dateFormat)
	}
}
