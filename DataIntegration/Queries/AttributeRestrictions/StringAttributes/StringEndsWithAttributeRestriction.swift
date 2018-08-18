//
//  StringEndsWithAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class StringEndsWithAttributeRestriction: AnyAttributeRestriction, StringAttributeRestriction, PredicateAttributeRestriction {

	fileprivate typealias Me = StringEndsWithAttributeRestriction

	public static let suffixAttribute = TextAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		suffixAttribute,
	]

	public override var name: String { return "Text ends with" }
	public override var description: String {
		return restrictedAttribute.name + " ends with '" + suffix + "'"
	}

	public var suffix: String

	public required init(attribute: Attribute) {
		suffix = String()
		super.init(attribute: attribute, attributes: Me.attributes)
	}

	public override func value(of attribute: Attribute) throws -> Any {
		if attribute.name == Me.suffixAttribute.name { return suffix }
		throw AttributeError.unknownAttribute
	}

	public override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.suffixAttribute.name { throw AttributeError.unknownAttribute }
		guard let castedValue = value as? String else { throw AttributeError.typeMismatch }
		suffix = castedValue
	}

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		let value = try sample.value(of: restrictedAttribute) as! String
		return value.starts(with: suffix)
	}

	public func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K ENDSWITH[cd] %@", restrictedAttribute.variableName, suffix)
	}
}


