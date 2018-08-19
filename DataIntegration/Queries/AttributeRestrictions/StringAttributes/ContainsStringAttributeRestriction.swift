//
//  ContainsStringAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class ContainsStringAttributeRestriction: AnyAttributeRestriction, StringAttributeRestriction, PredicateAttributeRestriction {

	fileprivate typealias Me = ContainsStringAttributeRestriction

	public static let substringAttribute = TextAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		substringAttribute,
	]

	public override var name: String { return "Text contains" }
	public override var description: String {
		return restrictedAttribute.name + " contains '" + substring + "'"
	}

	public var substring: String

	public required init(attribute: Attribute) {
		substring = String()
		super.init(attribute: attribute, attributes: Me.attributes)
	}

	public override func value(of attribute: Attribute) throws -> Any {
		if attribute.name == Me.substringAttribute.name { return substring }
		throw AttributeError.unknownAttribute
	}

	public override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.substringAttribute.name { throw AttributeError.unknownAttribute }
		guard let castedValue = value as? String else { throw AttributeError.typeMismatch }
		substring = castedValue
	}

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		let value = try sample.value(of: restrictedAttribute) as! String
		return value.contains(substring)
	}

	public func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K CONTAINS[cd] %@", restrictedAttribute.variableName, substring)
	}
}
