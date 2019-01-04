//
//  AttributeRestriction.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public protocol AttributeRestriction: Attributed {

	var restrictedAttribute: Attribute { get set }

	init(restrictedAttribute: Attribute)

	func samplePasses(_ sample: Sample) throws -> Bool
	func equalTo(_ otherRestriction: AttributeRestriction) -> Bool
}

public class AnyAttributeRestriction: AttributeRestriction {

	private typealias Me = AnyAttributeRestriction

	public static let selectAnAttribute = TextAttribute(name:"Atribute", pluralName: "Attributes")

	public var attributedName: String {
		get {
			os_log("Must override name", type: .error)
			return ""
		}
	}
	public var description: String {
		get {
			os_log("Must override description", type: .error)
			return ""
		}
	}
	public final var attributes: [Attribute]
	public final var restrictedAttribute: Attribute {
		didSet { restrictedAttributeWasSet() }
	}

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

	public func samplePasses(_ sample: Sample) throws -> Bool { throw NotOverridenError(functionName: "samplePasses") }
	public func value(of attribute: Attribute) throws -> Any? { throw NotOverridenError(functionName: "value(of:)") }
	public func set(attribute: Attribute, to value: Any?) throws { throw NotOverridenError(functionName: "set(attribute:to:)") }
	public func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		os_log("Must override equalTo()", type: .error)
		return type(of: self) == type(of: otherRestriction)
	}

	/// Do not call this function. It is only meant to be used internally but cannot be declared as private because it must be overridable by subclasses
	func restrictedAttributeWasSet() {}
}
