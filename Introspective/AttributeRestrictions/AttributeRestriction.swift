//
//  AttributeRestriction.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol AttributeRestriction: Attributed, BooleanExpression {

	var restrictedAttribute: Attribute { get set }

	init(restrictedAttribute: Attribute)

	func samplePasses(_ sample: Sample) throws -> Bool
	func equalTo(_ otherRestriction: AttributeRestriction) -> Bool
}

extension AttributeRestriction {

	public func evaluate(_ parameters: [UserInfoKey: Any]?) throws -> Bool {
		guard let sample = parameters?[.sample] as? Sample else {
			throw GenericError("Missing sample parameter for evaluation of attribute restriction: \(String(describing: parameters))")
		}
		return try samplePasses(sample)
	}

	public func equalTo(_ otherExpression: BooleanExpression) -> Bool {
		guard let restriction = otherExpression as? AttributeRestriction else {
			return false
		}
		return equalTo(restriction)
	}
}

public class AnyAttributeRestriction: AttributeRestriction {

	// MARK: - Static Variables

	private typealias Me = AnyAttributeRestriction
	public static let selectAnAttribute = TextAttribute(name:"Atribute", pluralName: "Attributes")

	// MARK: - Instance Variables

	public var attributedName: String {
		get {
			log.error("Must override name")
			return ""
		}
	}
	public var description: String {
		get {
			log.error("Must override description")
			return ""
		}
	}
	public final var attributes: [Attribute]
	public final var restrictedAttribute: Attribute {
		didSet { restrictedAttributeWasSet() }
	}

	private final let log = Log()

	// MARK: - Initializers

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

	// MARK: - Functions

	public func samplePasses(_ sample: Sample) throws -> Bool { throw NotOverriddenError(functionName: "samplePasses") }
	public func value(of attribute: Attribute) throws -> Any? { throw NotOverriddenError(functionName: "value(of:)") }
	public func set(attribute: Attribute, to value: Any?) throws { throw NotOverriddenError(functionName: "set(attribute:to:)") }
	public func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		log.error("Must override equalTo()")
		return type(of: self) == type(of: otherRestriction)
	}

	/// Do not call this function. It is only meant to be used internally but cannot be declared as private because it must be overridable by subclasses
	func restrictedAttributeWasSet() {}
}
