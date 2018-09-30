//
//  Query.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol Query: class {

	var attributeRestrictions: [AttributeRestriction] { get set }
	var mostRecentEntryOnly: Bool { get set }

	/// The timestamps from the results of the sub-query will be used to limit the results of this query
	var subQuery: (matcher: SubQueryMatcher, query: Query)? { get set }

	func runQuery(callback: @escaping (QueryResult?, Error?) -> ())
	func stop()
	func equalTo(_ otherQuery: Query) -> Bool
}

extension Query {

	public func equalTo(_ otherQuery: Query) -> Bool {
		if type(of: self) != type(of: otherQuery) { return false }
		if !attributeRestrictions.elementsEqual(otherQuery.attributeRestrictions, by: { l,r in return l.equalTo(r) }) { return false }
		if mostRecentEntryOnly != otherQuery.mostRecentEntryOnly { return false }
		if subQuery == nil && otherQuery.subQuery != nil { return false }
		if subQuery != nil && otherQuery.subQuery == nil { return false }
		if subQuery != nil && !subQuery!.query.equalTo(otherQuery.subQuery!.query) { return false }
		if subQuery != nil && !subQuery!.matcher.equalTo(otherQuery.subQuery!.matcher) { return false }
		return true
	}
}
