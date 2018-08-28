//
//  AnySample.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public class AnySample: Sample {

	fileprivate var _dates: [DateType: Date] = [DateType: Date]() {
		didSet { updateAttributeValuesWithDates() }
	}

	public var name: String
	public var description: String

	public var debugDescription: String {
		return "AnySample (\(_dates[.start]?.toString() ?? "nil") - \(_dates[.end]?.toString() ?? "nil") values: " + attributeValues.debugDescription
	}

	public var dataType: DataTypes { return .heartRate } // TODO - change this to custom once custom data types are supported
	public var attributes: [Attribute] {
		didSet {
			attributeValues = [String: Any]()
			for attribute in attributes {
				attributeValues[attribute.name] = ""
			}
		}
	}

	fileprivate var attributeValues: [String: Any]

	public init(name: String = "", description: String = "", attributes: [Attribute] = [Attribute](), attributeValues: [String: Any] = [String: Any]()) {
		self.name = name
		self.description = description
		self.attributes = attributes
		self.attributeValues = attributeValues
	}

	public func set(dates: [DateType: Date]) {
		self._dates = dates
		updateAttributeValuesWithDates()
	}

	public func dates() -> [DateType: Date] {
		return _dates
	}

	public func value(of attribute: Attribute) throws -> Any {
		guard let value = attributeValues[attribute.name] else { throw SampleError.unknownAttribute }
		return value
	}

	public func set(attribute: Attribute, to value: Any) throws {
		guard let _ = attributes.first(where: { a in return a.name == attribute.name }) else { throw SampleError.unknownAttribute }
		attributeValues[attribute.name] = value
	}

	fileprivate func updateAttributeValuesWithDates() {
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

	fileprivate func isAttribute(_ attribute: Attribute) -> Bool {
		return attributes.contains(where: { $0.equalTo(attribute) })
	}
}
