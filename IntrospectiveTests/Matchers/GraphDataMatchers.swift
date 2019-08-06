//
//  GraphDataMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective

func hasSeriesWithName(_ expectedName: String) -> Matcher<GraphData> {
	return Matcher("has series named '\(expectedName)'") { graphData -> Bool in
		for series in graphData {
			if let name = series["name"] as? String {
				if name == expectedName {
					return true
				}
			}
		}
		return false
	}
}

func hasSeriesWithData<Type: Equatable>(_ expectedData: [[Type]]) -> Matcher<GraphData> {
	return Matcher("has series with data: \(expectedData.debugDescription)") { graphData -> MatchResult in
		for series in graphData {
			if let data = series["data"] {
				guard let castedData = data as? [[Type]] else {
					return .mismatch("Unable to cast actual data as expected type")
				}
				if castedData.elementsEqual(expectedData) {
					return .match
				}
			}
		}
		return .mismatch(nil)
	}
}
