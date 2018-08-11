//
//  SubQueryMatch.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum ParamType {
	case integer
	case timeUnit
}

public enum ParamErrors: Error {
	case invalidIdentifier
	case typeMismatch
}

public protocol SubQueryMatcher: CustomStringConvertible {

	static var genericDescription: String { get }
	static var parameters: [(id: Int, type: ParamType)] { get }

	var mostRecentOnly: Bool { get set }

	init()

	func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample]
	) -> [QuerySampleType]

	func setParameter<T>(id: Int, value: T) throws

	func getParameterValue<T>(id: Int) throws -> T
}
