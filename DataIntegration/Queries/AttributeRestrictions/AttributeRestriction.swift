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

	init(restrictedAttribute: Attribute)

	func samplePasses(_ sample: Sample) throws -> Bool
	func equalTo(_ otherRestriction: AttributeRestriction) -> Bool
}

public class AnyAttributeRestriction: AttributeRestriction {

	private typealias Me = AnyAttributeRestriction

	public static let selectAnAttribute = TextAttribute(name:"Atribute", pluralName: "Attributes")

	public var name: String { get { fatalError("Must override name") } }
	public var description: String { get { fatalError("Must override description") } }
	public final var attributes: [Attribute]
	public final var restrictedAttribute: Attribute

	public init(attributes: [Attribute]) {
		self.restrictedAttribute = Me.selectAnAttribute
		self.attributes = attributes
	}

	public init(restrictedAttribute: Attribute, attributes: [Attribute]) {
		self.restrictedAttribute = restrictedAttribute
		self.attributes = attributes
	}

	public required init(restrictedAttribute: Attribute) {
		self.restrictedAttribute = restrictedAttribute
		attributes = [Attribute]()
	}

	public func samplePasses(_ sample: Sample) throws -> Bool { fatalError("Must override samplePasses()") }
	public func value(of attribute: Attribute) throws -> Any { fatalError("Must override value(of:)") }
	public func set(attribute: Attribute, to value: Any) throws { fatalError("Must override set(attribute:to:)") }
	public func equalTo(_ otherRestriction: AttributeRestriction) -> Bool { fatalError("Must override equalTo()")}
}
