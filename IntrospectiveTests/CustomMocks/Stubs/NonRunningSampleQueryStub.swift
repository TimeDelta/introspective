//
//  NonRunningSampleQueryStub.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/23/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
@testable import Introspective

class NonRunningSampleQueryStub<SampleType: Sample>: SampleQuery {

	public final var attributeRestrictions = [AttributeRestriction]()
	public final var mostRecentEntryOnly: Bool = false
	public final var subQuery: (matcher: SubQueryMatcher, query: Query)?

	public init() {
	}

	public final func runQuery(callback: @escaping (SampleQueryResult<SampleType>?, Error?) -> ()) {
	}

	public final func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
	}

	public func stop() {
	}

	public final func resetStoppedState() {
	}
}
