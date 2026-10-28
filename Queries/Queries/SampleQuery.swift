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
import Persistence
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
			expression = try injected(BooleanExpressionParser.self).parse(parts)
		} else {
			expression = nil
		}
		mostRecentEntryOnly = false
	}

	public final func runQuery(callback: @escaping (SampleQueryResult<SampleType>?, Error?) -> Void) {
		self.callback = callback
		queryCallbackParameters = nil
		subQueryCallbackParameters = nil
		stopped = false
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

	public final func stored(withName name: String, using transaction: Transaction? = nil) throws -> StoredQuery {
		let ownsTransaction = transaction == nil
		let transaction = try transaction ?? injected(Database.self).viewContextTransaction(for: StoredQuery.self, sortedBy: "name")
		let stored = try transaction.new(StoredQuery.self)
		try stored.populate(from: self, withName: name, using: transaction)
		if ownsTransaction { try transaction.commit() }
		return stored
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
		guard let completion = callback else { return }
		var result: SampleQueryResult<SampleType>?
		var failure = subQueryCallbackParameters?.error ?? queryCallbackParameters?.error
		if failure == nil {
			do { result = try filterResults() }
			catch { failure = error }
		}
		// Clear this run before calling client code, which may start another run.
		callback = nil
		queryCallbackParameters = nil
		subQueryCallbackParameters = nil
		completion(result, failure)
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
