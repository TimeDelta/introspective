//
//  GroupDefinition.swift
//  Introspective
//
//  Created by Bryan Nova on 4/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol GroupDefinition: CustomStringConvertible {

	var name: String { get set }
	var description: String { get }
	var sampleType: Sample.Type { get }
	var attributeRestrictionExpression: BooleanExpression? { get }
	var expressionParts: [BooleanExpressionPart] { get set }

	init(_ sampleType: Sample.Type)

	func sampleBelongsInGroup(_ sample: Sample) throws -> Bool
	func isValid() -> Bool
	/// create and return a deep copy of this object
	func copy() -> GroupDefinition
	func equalTo(_ other: GroupDefinition) -> Bool
}

public final class GroupDefinitionImpl: GroupDefinition {

	// MARK: - Instance Variables

	public final var name: String = "Name this group"
	public final let sampleType: Sample.Type
	public final var attributeRestrictionExpression: BooleanExpression? {
		get {
			do {
				let parser = DependencyInjector.booleanAlgebra.parser()
				return try parser.parse(expressionParts)
			} catch {
				return nil
			}
		}
	}
	public final var expressionParts = [BooleanExpressionPart]()

	public final var description: String {
		return attributeRestrictionExpression?.description ?? ""
	}

	// MARK: - Initializers

	public init(_ sampleType: Sample.Type) {
		self.sampleType = sampleType
	}

	// MARK: - Functions

	public final func sampleBelongsInGroup(_ sample: Sample) throws -> Bool {
		let parser = DependencyInjector.booleanAlgebra.parser()
		let attributeRestrictionExpression = try parser.parse(expressionParts)
		return try attributeRestrictionExpression.evaluate([.sample: sample])
	}

	public final func isValid() -> Bool {
		guard !name.isEmpty else { return false }
		guard expressionParts.count > 0 else { return false }
		let parser = DependencyInjector.booleanAlgebra.parser()
		do {
			let _ = try parser.parse(expressionParts)
		} catch {
			return false
		}
		return true
	}

	public final func copy() -> GroupDefinition {
		let copy = GroupDefinitionImpl(sampleType)
		copy.name = name
		for part in expressionParts {
			copy.expressionParts.append((type: part.type, expression: part.expression?.copy()))
		}
		return copy
	}

	// MARK: - Equality

	public func equalTo(_ other: GroupDefinition) -> Bool {
		var expressionsEqual: Bool
		if
			let lExpression = attributeRestrictionExpression,
			let rExpression = other.attributeRestrictionExpression
		{
			expressionsEqual = lExpression.equalTo(rExpression)
		} else {
			expressionsEqual = expressionParts.elementsEqual(other.expressionParts, by: {
				if $0.type != $1.type {
					return false
				}
				if $0.expression == nil && $1.expression == nil {
					return true
				}
				guard let expression1 = $0.expression, let expression2 = $1.expression else {
					return false
				}
				return expression1.equalTo(expression2)
			})
		}
		return name == other.name &&
			sampleType == other.sampleType &&
			expressionsEqual
	}
}
