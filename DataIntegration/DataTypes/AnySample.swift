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

	fileprivate var _dates: [DateType : Date] = [DateType: Date]()

	public var name: String = ""
	public var description: String = ""

	public var dataType: DataTypes { return .heartRate } // TODO - change this to custom once custom data types are supported
	public var attributes: [Attribute] = [Attribute]()

	fileprivate var attributeValues: [String: Any]

	public init() {
		attributeValues = [String: Any]()
	}

	public init(name: String, description: String = "", attributes: [Attribute], attributeValues: [String: Any] = [String: Any]()) {
		self.attributes = attributes
		self.attributeValues = attributeValues
	}

	public func set(dates: [DateType: Date]) {
		self._dates = dates
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
}
