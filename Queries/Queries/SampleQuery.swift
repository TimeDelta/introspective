//
//  BaseSampleQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import BooleanAlgebra
import Common
import DependencyInjection
import Samples

public protocol SampleQuery: Query {
	associatedtype SampleType: Sample

	var mostRecentEntryOnly: Bool { get set }

	func runQuery(callback: @escaping (SampleQueryResult<SampleType>?, Error?) -> Void)
}

public class SampleQueryImpl<SampleType: Sample>: SampleQuery {
	public final var expression: BooleanExpression?
	public final var mostRecentEntryOnly: Bool
	public final var subQuery: (matcher: SubQueryMatcher, query: Query)?

	final var stopped = false

	private final var callback: ((SampleQueryResult<SampleType>?, Error?) -> Void)!

	private final var subQueryCallbackParameters: (result: QueryResult?, error: Error?)?
	private final var queryCallbackParameters: (result: SampleQueryResult<SampleType>?, error: Error?)?

	private final let log = Log()

	public init() {
		expression = nil
		mostRecentEntryOnly = false
	}

	public required init(parts: [BooleanExpressionPart]) throws {
		if !parts.isEmpty {
			expression = try DependencyInjector.get(BooleanExpressionParser.self).parse(parts)
		} else {
			expression = nil
		}
		mostRecentEntryOnly = false
	}

	public final func runQuery(callback: @escaping (SampleQueryResult<SampleType>?, Error?) -> Void) {
		self.callback = callback
		subQuery?.query.runQuery(callback: { (result: QueryResult?, error: Error?) in
			self.subQueryCallbackParameters = (result, error)
			if self.queryCallbackParameters != nil {
				self.filterAndCallBack()
			}
		})
		run()
	}

	public final func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
		runQuery { (result: SampleQueryResult<SampleType>?, error: Error?) in
			callback(result, error)
		}
	}

	func run() {
		log.error("Must override and call queryDone() when finished")
	}

	public func stop() {
		stopped = true
		subQuery?.query.stop()
	}

	public final func resetStoppedState() {
		stopped = false
		subQuery?.query.resetStoppedState()
	}

	/// This should be called by any subclasses after finishing the query.
	final func queryDone(_ result: SampleQueryResult<SampleType>?, _ error: Error?) {
		queryCallbackParameters = (result, error)
		if subQuery == nil || subQueryCallbackParameters != nil {
			filterAndCallBack()
		}
	}

	func samplePassesFilters(_ sample: Sample) throws -> Bool {
		guard !stopped else { return false }
		guard let expression = expression else {
			return true
		}
		guard expression.predicate() == nil else { return true }
		return try expression.evaluate([.sample: sample])
	}

	private final func filterAndCallBack() {
		if let error = subQueryCallbackParameters?.error {
			callback(nil, error)
			return
		}
		if let error = queryCallbackParameters?.error {
			callback(nil, error)
			return
		}

		do {
			callback(try filterResults(), nil)
		} catch {
			log.error("Failed to filter query results: %@", errorInfo(error))
			callback(nil, error)
		}
		// could capture surrounding context (from e.g. view controller) so set to nil to avoid retain cycles, which
		// cause memory leaks
		callback = nil
	}

	private final func filterResults() throws -> SampleQueryResult<SampleType>? {
		guard let queryResult = queryCallbackParameters?.result else {
			throw GenericError("query result is nil")
		}

		guard let subQuery = subQuery else {
			return queryResult
		}
		let querySamples = queryResult.typedSamples
		guard let subQuerySamples = subQueryCallbackParameters?.result?.samples else {
			throw GenericError("cannot retrieve subQuery samples")
		}

		let filteredSamples = try subQuery.matcher.getSamples(from: querySamples, matching: subQuerySamples)
		let filteredResult = SampleQueryResult<SampleType>(filteredSamples)

		return filteredResult
	}
}
