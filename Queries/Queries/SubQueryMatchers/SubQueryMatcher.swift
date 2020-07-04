//
//  SubQueryMatcher.swift
//  Introspective
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Samples

public protocol SubQueryMatcher: Attributed {
	var mostRecentOnly: Bool { get set }

	init()

	func getSamples<QuerySampleType: Sample>(from querySamples: [QuerySampleType], matching subQuerySamples: [Sample])
		throws -> [QuerySampleType]
	func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool
}

public extension SubQueryMatcher {
	func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
		if type(of: self) != type(of: otherMatcher) { return false }
		if mostRecentOnly != otherMatcher.mostRecentOnly { return false }
		return true
	}
}

public class CommonSubQueryMatcherAttributes {
	public static let mostRecentOnly = BooleanAttribute(
		name: "Most recent only",
		description: "Use only the most recent entry that matches the given restrictions."
	)
}
