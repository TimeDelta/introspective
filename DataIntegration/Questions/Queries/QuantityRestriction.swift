//
//  QuantityRestriction.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import NaturalLanguage

public class QuantityRestriction: NSObject {

	public enum ComparisonType {
		public enum ErrorTypes: Error {
			case UnknownComparisonType
		}

		case greaterThan
		case greaterThanOrEqual
		case equal
		case lessThanOrEqual
		case lessThan

		static func from(tag: NLTag) throws -> ComparisonType {
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
	}

	public fileprivate(set) var attribute: String
	public fileprivate(set) var comparison: ComparisonType
	public fileprivate(set) var value: Double
	public fileprivate(set) var aggregationUnit: Calendar.Component?
	public fileprivate(set) var operation: QueryOperation?

	public init(attribute: String, _ comparison: ComparisonType, value: Double) {
		self.attribute = attribute
		self.comparison = comparison
		self.value = value
	}
}
