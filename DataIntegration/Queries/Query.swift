//
//  Query.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol Query {

	var timeConstraints: [TimeConstraint] { get set }
	var attributeRestrictions: [AttributeRestriction] { get set }
	var mostRecentEntryOnly: Bool { get set }
	var numberOfDatesPerSample: Int { get }

	/// The timestamps from the results of the sub-query will be used to limit the results of this query
	var subQuery: (matcher: SubQueryMatcher, query: Query)? { get set }

	func runQuery(callback: @escaping (QueryResult?, Error?) -> ())
}

public protocol TypedQuery: Query {

	associatedtype SampleType: Sample

	func runQuery(callback: @escaping (SampleQueryResult<SampleType>?, Error?) -> ())
}

extension TypedQuery {

	public func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
		runQuery { (result: SampleQueryResult<SampleType>?, error: Error?) in
			callback(result, error)
		}
	}
}
