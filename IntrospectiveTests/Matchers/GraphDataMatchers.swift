//
//  GraphDataMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
import AAInfographics

@testable import Introspective

func hasSeriesWithName(_ expectedName: String) -> Matcher<GraphData> {
	return Matcher("has series named '\(expectedName)'") { graphData -> Bool in
		for series in graphData {
			if let name = series.name {
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
			if let data = series.data {
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

func hasSeriesWithDataInAnyOrder(_ expectedDataMatchers: [Matcher<AADataElement>]) -> Matcher<GraphData> {
	return Matcher("has series with data: \(expectedDataMatchers.debugDescription)") { graphData -> MatchResult in
		if graphData.count == 0 {
			return .mismatch("No series")
		}
		var matched = [Bool]()
		for _ in 0 ..< expectedDataMatchers.count {
			matched.append(false)
		}

		for series in graphData {
			if let data = series.data {
				guard let dataElements = data as? [AADataElement] else {
					return .mismatch("Unable to cast actual data as expected type")
				}

				var matcherIndex = 0
				for matcher in expectedDataMatchers {
					for element in dataElements {
						if matcher.matches(element).boolValue {
							matched[matcherIndex] = true
							break
						}
					}
					if !matched[matcherIndex] {
						return .mismatch("No match found for \(matcher.description)")
					}
					matcherIndex += 1
				}
				if matched.index(of: false) == nil {
					return .match
				}
			}
		}
		return .mismatch(nil)
	}
}

func point(x: Float, y: Float) -> Matcher<AADataElement> {
	return point(x: equalTo(x), y: equalTo(y))
}

func point(x xMatcher: Matcher<Float>, y yMatcher: Matcher<Float>) -> Matcher<AADataElement> {
	return Matcher("(x: \(xMatcher.description), y: \(yMatcher.description))") { pointData -> MatchResult in
		guard let x = pointData.x else {
			return .mismatch("no x-value")
		}
		guard let y = pointData.y else {
			return .mismatch("no y-value")
		}
		if !xMatcher.matches(x).boolValue {
			return .mismatch("x-value was \(x)")
		}
		if !yMatcher.matches(y).boolValue {
			return .mismatch("y-value was \(y)")
		}
		return .match
	}
}
