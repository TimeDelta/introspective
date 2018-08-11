//
//  GreaterThanOrEqualToAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class GreaterThanOrEqualToAttributeRestriction: AnyAttributeRestriction {

	fileprivate typealias Me = GreaterThanOrEqualToAttributeRestriction

	public static let valueAttribute = DoubleAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		valueAttribute,
	]

	public override var name: String { return "≥" }
	public override var description: String {
		return restrictedAttribute.name + " ≥ " + String(value)
	}

	public var value: Double

	public required init(attribute: Attribute) {
		value = Double()
		super.init(attribute: attribute, attributes: Me.attributes)
	}

	public override func value(of attribute: Attribute) throws -> Any {
		if attribute.name != Me.valueAttribute.name { throw AttributeError.unknownAttribute }
		return value
	}

	public override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.valueAttribute.name { throw AttributeError.unknownAttribute }
		guard let castedValue = value as? Double else { throw AttributeError.typeMismatch }
		self.value = castedValue
	}

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		var castedSampleValue: Double
		if sampleValue is Int {
			castedSampleValue = Double(sampleValue as! Int)
		} else if sampleValue is Double {
			castedSampleValue = sampleValue as! Double
		} else {
			throw AttributeError.typeMismatch
		}

		return castedSampleValue >= value
	}
}
