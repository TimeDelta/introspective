//
//  AnySample.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public final class AnySample: Sample {

	public static let name: String = "Custom"
	public static let defaultDependentAttribute: Attribute = CommonSampleAttributes.timestamp
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp
	public static let attributes: [Attribute] = []

	private final var _dates: [DateType: Date] = [DateType: Date]() {
		didSet { updateAttributeValuesWithDates() }
	}

	public final var attributedName: String
	public final var description: String

	public final var debugDescription: String {
		return "AnySample (\(_dates[.start]?.toString() ?? "nil") - \(_dates[.end]?.toString() ?? "nil") values: " + attributeValues.debugDescription
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

	public init(name: String = "", description: String = "", attributes: [Attribute] = [Attribute](), attributeValues: [String: Any] = [String: Any]()) {
		self.attributedName = name
		self.description = description
		self.attributes = attributes
		self.attributeValues = attributeValues
	}

	public final func set(dates: [DateType: Date]) {
		self._dates = dates
		updateAttributeValuesWithDates()
	}

	public final func dates() -> [DateType: Date] {
		return _dates
	}

	public final func value(of attribute: Attribute) throws -> Any? {
		guard let value = attributeValues[attribute.name] else {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		return value
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		guard let _ = attributes.first(where: { a in return a.name == attribute.name }) else {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		attributeValues[attribute.name] = value
	}

	private final func updateAttributeValuesWithDates() {
		if isAttribute(CommonSampleAttributes.startDate) {
			attributeValues[CommonSampleAttributes.startDate.name] = _dates[.start]
		}
		if isAttribute(CommonSampleAttributes.timestamp) {
			attributeValues[CommonSampleAttributes.timestamp.name] = _dates[.start]
		}
		if isAttribute(CommonSampleAttributes.endDate) {
			attributeValues[CommonSampleAttributes.endDate.name] = _dates[.end]
		}
	}

	private final func isAttribute(_ attribute: Attribute) -> Bool {
		return attributes.contains(where: { $0.equalTo(attribute) })
	}
}
