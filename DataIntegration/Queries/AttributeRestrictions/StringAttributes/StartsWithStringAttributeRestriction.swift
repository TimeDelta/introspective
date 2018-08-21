//
//  StartsWithStringAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class StartsWithStringAttributeRestriction: AnyAttributeRestriction, StringAttributeRestriction, PredicateAttributeRestriction, Equatable {

	fileprivate typealias Me = StartsWithStringAttributeRestriction

	public static func ==(lhs: StartsWithStringAttributeRestriction, rhs: StartsWithStringAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let prefixAttribute = TextAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		prefixAttribute,
	]

	public override var name: String { return "Text starts with" }
	public override var description: String {
		return restrictedAttribute.name + " starts with '" + prefix + "'"
	}

	public var prefix: String

	public required init(attribute: Attribute) {
		prefix = String()
		super.init(attribute: attribute, attributes: Me.attributes)
	}

	public override func value(of attribute: Attribute) throws -> Any {
		if attribute.name == Me.prefixAttribute.name { return prefix }
		throw AttributeError.unknownAttribute
	}

	public override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.prefixAttribute.name { throw AttributeError.unknownAttribute }
		guard let castedValue = value as? String else { throw AttributeError.typeMismatch }
		prefix = castedValue
	}

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		let value = try sample.value(of: restrictedAttribute) as! String
		return value.starts(with: prefix)
	}

	public func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K BEGINSWITH[cd] %@", restrictedAttribute.variableName, prefix)
	}

	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is StartsWithStringAttributeRestriction) { return false }
		let other = otherAttributed as! StartsWithStringAttributeRestriction
		return equalTo(other)
	}

	public func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is StartsWithStringAttributeRestriction) { return false }
		let other = otherRestriction as! StartsWithStringAttributeRestriction
		return equalTo(other)
	}

	public func equalTo(_ other: StartsWithStringAttributeRestriction) -> Bool {
		return prefix == other.prefix
	}
}

