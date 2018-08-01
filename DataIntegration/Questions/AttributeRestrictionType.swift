//
//  AttributeRestrictionType.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os
import NaturalLanguage

public enum AttributeRestrictionType: CustomStringConvertible {

	public enum Errors: Error {
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

	public static func from(tag: NLTag) throws -> AttributeRestrictionType {
		switch (tag) {
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
				throw Errors.UnknownComparisonType
		}
	}

	public static func typesFor(attribute: Attribute) -> [AttributeRestrictionType] {
		return typesFor(attributeType: type(of: attribute))
	}

	public static func typesFor(attributeType: Attribute.Type) -> [AttributeRestrictionType] {
		if attributeType == DoubleAttribute.self {
			return [greaterThan, greaterThanOrEqual, equals, lessThanOrEqual, lessThan, isOneOf]
		}
		if attributeType == TextAttribute.self {
			return [equals, isOneOf, contains, matches, startsWith, endsWith]
		}

		os_log("Unexpected attribute type: $@", type: .error, String(describing: attributeType))
		return []
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
