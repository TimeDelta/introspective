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

	public enum Kind {
		case average
		case count
		case max
		case min
		case sum
	}

	fileprivate static let map: [NLTag: Kind] = [Tags.average: .average, Tags.count: .count, Tags.max: .max, Tags.min: .min, Tags.sum: .sum]

	public enum ErrorTypes: Error {
		case UnknownOperationType
	}

	public fileprivate(set) var kind: Kind
	public var aggregationUnit: Calendar.Component?

	fileprivate init(_ kind: Kind) {
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
