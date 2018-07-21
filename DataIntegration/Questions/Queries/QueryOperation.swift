//
//  Operations.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import NaturalLanguage

public class QueryOperation: NSObject {

	fileprivate typealias Me = QueryOperation

	public enum Kind: CustomStringConvertible {
		case average
		case count
		case max
		case min
		case sum

		public static var allTypes: [Kind] {
			return [average, count, max, min, sum]
		}

		public var description: String {
			switch (self) {
				case .average: return "Average"
				case .count: return "Count"
				case .max: return "Maximum"
				case .min: return "Minimum"
				case .sum: return "Sum of"
			}
		}
	}

	public enum Errors: Error {
		case UnknownOperationType
	}

	public static let supportedAggregationUnits: [Calendar.Component] = [
		.year,
		.month,
		.weekOfYear,
		.day,
		.hour,
		.minute,
		.second,
	]

	public static func from(tag: NLTag, for attribute: Attribute) throws -> QueryOperation {
		let operationKind = map[tag]
		if operationKind == nil {
			throw Errors.UnknownOperationType
		}
		return QueryOperation(operationKind!, attribute)
	}

	fileprivate static let map: [NLTag: Kind] = [Tags.average: .average, Tags.count: .count, Tags.max: .max, Tags.min: .min, Tags.sum: .sum]

	public var kind: Kind
	public var attribute: Attribute
	public var aggregationUnit: Calendar.Component?

	override public var description: String {
		var str = kind.description
		if aggregationUnit != nil {
			for component in Me.supportedAggregationUnits {
				if component == aggregationUnit {
					str += " per " + CalendarUtil.componentNames[component]!
				}
			}
		}
		return str
	}

	public init(_ kind: Kind, _ attribute: Attribute) {
		self.kind = kind
		self.attribute = attribute
	}
}
