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

func hasSeries(_ seriesMatcher: Matcher<AASeriesElement>) -> Matcher<GraphData> {
	return Matcher("has series \(seriesMatcher.description)") { graphData -> MatchResult in
		for series in graphData {
			let matchResult = seriesMatcher.matches(series)
			if matchResult.boolValue {
				return matchResult
			}
		}
		return .mismatch(nil)
	}
}

func with(name: String) -> Matcher<AASeriesElement> {
	return has(name: name)
}

func with(name nameMatcher: Matcher<String>) -> Matcher<AASeriesElement> {
	return has(name: nameMatcher)
}

func has(name: String) -> Matcher<AASeriesElement> {
	return has(name: equalTo(name))
}

func has(name nameMatcher: Matcher<String>) -> Matcher<AASeriesElement> {
	return Matcher("with name \(nameMatcher.description)") { series -> MatchResult in
		guard let name = series.name else {
			return .mismatch("Series has no name")
		}
		return nameMatcher.matches(name)
	}
}

func with<Type: Equatable>(data expectedData: [[Type]]) -> Matcher<AASeriesElement> {
	return has(data: expectedData)
}

func has<Type: Equatable>(data expectedData: [[Type]]) -> Matcher<AASeriesElement> {
	return Matcher("has data: \(expectedData.debugDescription)") { series -> MatchResult in
		if let data = series.data {
			guard let castedData = data as? [[Type]] else {
				return .mismatch("Unable to cast actual data as expected type")
			}
			if castedData.elementsEqual(expectedData) {
				return .match
			}
			return .mismatch(nil)
		}
		return .mismatch("has no data")
	}
}

func withNoData() -> Matcher<AASeriesElement> {
	return hasNoData()
}

func hasNoData() -> Matcher<AASeriesElement> {
	return Matcher("has no data") { series -> MatchResult in
		guard let data = series.data else {
			return .match
		}
		if data.count == 0 {
			return .match
		}
		return .mismatch("had \(data.count) data points")
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
