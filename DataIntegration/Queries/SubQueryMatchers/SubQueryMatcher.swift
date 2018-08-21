//
//  SubQueryMatcher.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SubQueryMatcher: Attributed {

	var mostRecentOnly: Bool { get set }

	init()

	func getSamples<QuerySampleType: Sample>(from querySamples: [QuerySampleType], matching subQuerySamples: [Sample]) -> [QuerySampleType]
	func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool
}

extension SubQueryMatcher {

	public func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
		if type(of: self) != type(of: otherMatcher) { return false }
		if mostRecentOnly != otherMatcher.mostRecentOnly { return false }
		return true
	}
}

public class CommonSubQueryMatcherAttributes {

	public static let mostRecentOnly = BooleanAttribute(name: "Most recent only", description: "Use only the most recent enty that matches the given restrictions.")
}
