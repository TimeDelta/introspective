//
//  QuantityRestriction.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import NaturalLanguage

public struct AttributeRestriction: CustomStringConvertible {

	public enum ComparisonType: CustomStringConvertible {
		public enum ErrorTypes: Error {
			case UnknownComparisonType
		}

		case greaterThan
		case greaterThanOrEqual
		case lessThanOrEqual
		case lessThan

		case equals
		case isOneOf

		case contains
		case matches
		case startsWith
		case endsWith

		public static func from(tag: NLTag) throws -> ComparisonType {
			switch(tag) {
				case Tags.greaterThan:
					return .greaterThan
				case Tags.greaterThanOrEqual:
					return .greaterThanOrEqual
				case Tags.equal:
					return .equals
				case Tags.lessThanOrEqual:
					return .lessThanOrEqual
				case Tags.lessThan:
					return .lessThan
				default:
					throw ErrorTypes.UnknownComparisonType
			}
		}

		public static func typesFor(attribute: Attributes) -> [ComparisonType] {
			return typesFor(attributeType: attribute.type)
		}

		public static func typesFor(attributeType: Attributes.AttributeType) -> [ComparisonType] {
			switch(attributeType) {
				case .quantity: return [greaterThan, greaterThanOrEqual, equals, lessThanOrEqual, lessThan, isOneOf]
				case .string: return [equals, isOneOf, contains, matches, startsWith, endsWith]
			}
		}

		public var description: String {
			switch (self) {
				case .greaterThan: return ">"
				case .greaterThanOrEqual: return "≥"
				case .lessThanOrEqual: return "≤"
				case .lessThan: return "<"
				case .equals: return "="
				case .isOneOf: return "is one of"
				case .contains: return "contains"
				case .matches: return "matches"
				case .startsWith: return "starts with"
				case .endsWith: return "ends with"
			}
		}
	}

	public var operation: QueryOperation?
	public var attribute: Attributes
	public var comparison: ComparisonType = .equals
	public var values: [Any]

	public init(_ attribute: Attributes) {
		self.attribute = attribute
		self.values = [Any]()
	}

	public var description: String {
		var description = ""
		if operation != nil {
			description += operation!.kind.description + " "
		}

		description += attribute.description + " "

		if operation != nil && operation!.aggregationUnit != nil {
			description += "per " + CalendarUtil.componentNames[operation!.aggregationUnit!]! + " "
		}

		description += comparison.description + " "

		for v in values {
			if attribute.type == .string {
				description += "\""
			}
			description += String(describing: v)
			if attribute.type == .string {
				description += "\""
			}
			description += ", "
		}
		description.removeLast()
		description.removeLast()

		return description
	}
}
