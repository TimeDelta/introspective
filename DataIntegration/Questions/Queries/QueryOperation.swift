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

	public enum ErrorTypes: Error {
		case UnknownOperationType
	}

	public static let supportedAggregationUnits: [(aggregation: Calendar.Component, description: String)] = [
		(.year, "Year"),
		(.month, "Month"),
		(.weekOfYear, "Week"),
		(.day, "Day"),
		(.hour, "Hour"),
		(.minute, "Minute"),
		(.second, "Second"),
	]

	fileprivate static let map: [NLTag: Kind] = [Tags.average: .average, Tags.count: .count, Tags.max: .max, Tags.min: .min, Tags.sum: .sum]

	public var kind: Kind
	public var aggregationUnit: Calendar.Component?

	override public var description: String {
		var str = kind.description
		if aggregationUnit != nil {
			for entry in Me.supportedAggregationUnits {
				if entry.aggregation == aggregationUnit {
					str += " per " + entry.description
				}
			}
		}
		return str
	}

	public init(_ kind: Kind) {
		self.kind = kind
	}

	public static func from(tag: NLTag) throws -> QueryOperation {
		let operationKind = map[tag]
		if operationKind == nil {
			throw ErrorTypes.UnknownOperationType
		}
		return QueryOperation(operationKind!)
	}
}
