//
//  AttributeRestriction.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import BooleanAlgebra
import Common
import Persistence
import Samples

public protocol AttributeRestriction: Attributed, BooleanExpression {
	var restrictedAttribute: Attribute { get set }

	init(restrictedAttribute: Attribute)

	func samplePasses(_ sample: Sample) throws -> Bool
	func copy() -> AttributeRestriction
	func equalTo(_ otherRestriction: AttributeRestriction) -> Bool
}

public extension AttributeRestriction {
	func evaluate(_ parameters: [UserInfoKey: Any]?) throws -> Bool {
		guard let sample = parameters?[.sample] as? Sample else {
			throw GenericError(
				"Missing sample parameter for evaluation of attribute restriction: \(String(describing: parameters))"
			)
		}
		return try samplePasses(sample)
	}

	// from BooleanExpression
	func isValid() -> Bool {
		attributeValuesAreValid()
	}

	func copy() -> BooleanExpression {
		copy() as AttributeRestriction
	}
}

public class AnyAttributeRestriction: AttributeRestriction {
	// MARK: - Static Variables

	private typealias Me = AnyAttributeRestriction

	public static let selectAnAttribute = TextAttribute(id: 0, name: "Atribute", pluralName: "Attributes")

	private static let log = Log()

	// MARK: - Instance Variables

	public var attributedName: String {
		Me.log.error("Must override attributedName")
		return ""
	}

	public var description: String {
		Me.log.error("Must override description")
		return ""
	}

	public final var attributes: [Attribute]
	public final var restrictedAttribute: Attribute {
		didSet { restrictedAttributeWasSet() }
	}

	// MARK: - Initializers

	public init(attributes: [Attribute]) {
		restrictedAttribute = Me.selectAnAttribute
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

	public func predicate() -> NSPredicate? {
		Me.log.error("predicate() not overriden")
		return nil
	}

	public func samplePasses(_: Sample) throws -> Bool { throw NotOverriddenError(functionName: "samplePasses") }
	public func value(of _: Attribute) throws -> Any? { throw NotOverriddenError(functionName: "value(of:)") }
	public func set(attribute _: Attribute, to _: Any?) throws {
		throw NotOverriddenError(functionName: "set(attribute:to:)")
	}

	public func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		Me.log.error("Must override equalTo()")
		return type(of: self) == type(of: otherRestriction)
	}

	// Leave this here instead of as a default implementation on the protocol because there is
	// a bug with the SwiftyMocky framework where the generated AttributeRestrictionMock causes
	// a compiler error about a re-implementation of this method
	public func equalTo(_ otherExpression: BooleanExpression) -> Bool {
		guard let restriction = otherExpression as? AttributeRestriction else {
			return false
		}
		return equalTo(restriction)
	}

	public func copy() -> AttributeRestriction {
		let typeDescription = String(describing: type(of: self))
		Me.log.error("Did not override copy() for %@", typeDescription)
		return self
	}

	public func stored(for sampleType: Sample.Type, using transaction: Transaction?) throws -> StoredBooleanExpression {
		let typeDescription = String(describing: type(of: self))
		Me.log.error("Did not override copy() for %@", typeDescription)
		throw GenericError("must override \(typeDescription).stored()")
	}

	/// Do not call this function. It is only meant to be used internally but cannot be declared as private because it must be overridable by subclasses
	func restrictedAttributeWasSet() {}
}
