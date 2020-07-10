//
//  AnySample.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

import Attributes

public final class AnySample: Sample {
	public static let name: String = "Custom"
	public static let defaultDependentAttribute: Attribute = CommonSampleAttributes.timestamp
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp
	public static let attributes: [Attribute] = []
	public static let dateAttributes = [DateType: DateAttribute]()

	private final var _dates: [DateType: Date] = [DateType: Date]() {
		didSet { updateAttributeValuesWithDates() }
	}

	private final var _dateAttributes = [DateType: DateAttribute]()

	public final var attributedName: String
	public final var description: String

	public final var debugDescription: String {
		"AnySample (\(_dates[.start]?.toString() ?? "nil") - \(_dates[.end]?.toString() ?? "nil") values: " +
			attributeValues.debugDescription
	}

	public final var attributes: [Attribute] {
		didSet {
			attributeValues = [String: Any?]()
			for attribute in attributes {
				attributeValues[attribute.name] = ""
			}
		}
	}

	private final var attributeValues: [String: Any?]

	public init(
		name: String = "",
		description: String = "",
		attributes: [Attribute] = [Attribute](),
		attributeValues: [String: Any] = [String: Any]()
	) {
		attributedName = name
		self.description = description
		self.attributes = attributes
		self.attributeValues = attributeValues
	}

	public final func set(dates: [DateType: Date]) {
		_dates = dates
		updateAttributeValuesWithDates()
	}

	public final func dates() -> [DateType: Date] {
		_dates
	}

	public final func value(of attribute: Attribute) throws -> Any? {
		guard let value = attributeValues[attribute.name] else {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		return value
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		guard let _ = attributes.first(where: { a in a.name == attribute.name }) else {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		attributeValues[attribute.name] = value
	}

	private final func updateAttributeValuesWithDates() {
		if isAttribute(CommonSampleAttributes.startDate) {
			attributeValues[CommonSampleAttributes.startDate.name] = _dates[.start]
			_dateAttributes[.start] = CommonSampleAttributes.startDate
		} else if isAttribute(CommonSampleAttributes.healthKitStartDate) {
			attributeValues[CommonSampleAttributes.healthKitStartDate.name] = _dates[.start]
			_dateAttributes[.start] = CommonSampleAttributes.healthKitStartDate
		}
		if isAttribute(CommonSampleAttributes.timestamp) {
			attributeValues[CommonSampleAttributes.timestamp.name] = _dates[.start]
			_dateAttributes[.start] = CommonSampleAttributes.timestamp
		} else if isAttribute(CommonSampleAttributes.healthKitStartDate) {
			attributeValues[CommonSampleAttributes.healthKitStartDate.name] = _dates[.start]
			_dateAttributes[.start] = CommonSampleAttributes.healthKitTimestamp
		}
		if isAttribute(CommonSampleAttributes.endDate) {
			attributeValues[CommonSampleAttributes.endDate.name] = _dates[.end]
			_dateAttributes[.end] = CommonSampleAttributes.endDate
		} else if isAttribute(CommonSampleAttributes.healthKitEndDate) {
			attributeValues[CommonSampleAttributes.healthKitEndDate.name] = _dates[.start]
			_dateAttributes[.start] = CommonSampleAttributes.healthKitEndDate
		}
	}

	private final func isAttribute(_ attribute: Attribute) -> Bool {
		attributes.contains(where: { $0.equalTo(attribute) })
	}
}
