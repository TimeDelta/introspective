//
//  QuantityRestriction.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import NaturalLanguage

public struct AttributeRestriction {

	public enum ComparisonType {
		public enum ErrorTypes: Error {
			case UnknownComparisonType
		}

		case greaterThan
		case greaterThanOrEqual
		case lessThanOrEqual
		case lessThan

		case equal
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
					return .equal
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
				case .quantity: return [greaterThan, greaterThanOrEqual, equal, lessThanOrEqual, lessThan, isOneOf]
				case .string: return [equal, isOneOf, contains, matches, startsWith, endsWith]
			}
		}
	}

	public var attribute: Attributes
	public var comparison: ComparisonType
	public var value: [Any]
	public var aggregationUnit: Calendar.Component?
	public var operation: QueryOperation?
}
