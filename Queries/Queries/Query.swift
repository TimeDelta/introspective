//
//  Query.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import BooleanAlgebra

// sourcery: AutoMockable
/// Currently queries cannot have a brother or sister, only a direct subquery
public protocol Query: AnyObject {
	/// - Throws: If a valid query cannot be made from the provided parts
	init(parts: [BooleanExpressionPart]) throws

	var expression: BooleanExpression? { get set }
	var mostRecentEntryOnly: Bool { get set }

	/// The timestamps from the results of the sub-query will be used to limit the results of this query
	var subQuery: (matcher: SubQueryMatcher, query: Query)? { get set }

	func runQuery(callback: @escaping (QueryResult?, Error?) -> Void)
	func stop()
	/// This resets the stopped state so that the query can be ran again
	func resetStoppedState()
	func equalTo(_ otherQuery: Query) -> Bool
}

public extension Query {
	func equalTo(_ otherQuery: Query) -> Bool {
		if type(of: self) != type(of: otherQuery) { return false }
		if let myExpression = expression {
			guard let otherExpression = otherQuery.expression else { return false }
			if !myExpression.equalTo(otherExpression) { return false }
		} else if let _ = otherQuery.expression { return false }
		if mostRecentEntryOnly != otherQuery.mostRecentEntryOnly { return false }
		if subQuery == nil && otherQuery.subQuery != nil { return false }
		if subQuery != nil && otherQuery.subQuery == nil { return false }
		if subQuery != nil && !subQuery!.query.equalTo(otherQuery.subQuery!.query) { return false }
		if subQuery != nil && !subQuery!.matcher.equalTo(otherQuery.subQuery!.matcher) { return false }
		return true
	}
}
