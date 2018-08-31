//
//  AttributeRestriction.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol AttributeRestriction: Attributed {

	var restrictedAttribute: Attribute { get set }

	init(attribute: Attribute)

	func samplePasses(_ sample: Sample) throws -> Bool
	func equalTo(_ otherRestriction: AttributeRestriction) -> Bool
}

extension AttributeRestriction {

	public func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if type(of: self) != type(of: otherRestriction) { return false }
		if !restrictedAttribute.equalTo(otherRestriction.restrictedAttribute) { return false }
		if !equalTo(otherRestriction as Attributed) { return false }
		return true
	}
}

public class AnyAttributeRestriction: AttributeRestriction {

	private typealias Me = AnyAttributeRestriction

	public static let selectAnAttribute = TextAttribute(name:"Atribute", pluralName: "Attributes")

	public var name: String { get { fatalError("Must override") } }
	public var description: String { get { fatalError("Must override") } }
	public final var attributes: [Attribute]
	public final var restrictedAttribute: Attribute {
		didSet {
			assert(isValid(attribute: restrictedAttribute))
		}
	}

	public init(attributes: [Attribute]) {
		self.restrictedAttribute = Me.selectAnAttribute
		self.attributes = attributes
	}

	public init(attribute: Attribute, attributes: [Attribute]) {
		self.restrictedAttribute = attribute
		self.attributes = attributes
	}

	public required init(attribute: Attribute) {
		self.restrictedAttribute = attribute
		attributes = [Attribute]()
	}

	public func samplePasses(_ sample: Sample) throws -> Bool { fatalError("Must override") }
	public func value(of attribute: Attribute) throws -> Any { fatalError("Must override") }
	public func set(attribute: Attribute, to value: Any) throws { fatalError("Must override") }

	func isValid(attribute: Attribute) -> Bool { fatalError("Must override") }
}
