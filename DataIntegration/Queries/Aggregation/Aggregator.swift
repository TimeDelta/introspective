//
//  Aggregation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum AggregationError: Error {
	case typeMismatch
	case unsupportedValue
	case unknownParameter
}

public protocol Aggregator: Parameterized {

	func aggregate(samples: [Sample]) throws -> [(Aggregatable, [Sample])]
}
