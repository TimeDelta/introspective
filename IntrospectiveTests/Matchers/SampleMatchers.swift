//
//  SampleMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/15/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective
@testable import Samples

func equals(_ expected: Sample) -> Matcher<Sample?> {
	return Matcher("\(expected.description)") { actual -> MatchResult in
		guard let actual = actual else {
			return .mismatch("is nil")
		}
		if expected.equalTo(actual) {
			return .match
		}
		return .mismatch(nil)
	}
}

func onlyHasExpectedSamples(_ expectedSamples: [Sample]) -> Matcher<[Sample]> {
	return Matcher("\(expectedSamples.description)") { actualSamples -> MatchResult in
		let unexpectedSamples = actualSamples.filter({ sample in
			return !expectedSamples.contains(where: { sample.equalTo($0) })
		})
		if unexpectedSamples.count > 0 {
			return .mismatch("Found \(unexpectedSamples.count) unexpected samples: \(unexpectedSamples.debugDescription)")
		}
		let missingSamples = expectedSamples.filter({ sample in
			return !actualSamples.contains(where: { sample.equalTo($0) })
		})
		if missingSamples.count > 0 {
			return .mismatch("Missing \(missingSamples.count) expected samples: \(missingSamples.debugDescription)")
		}
		return .match
	}
}
