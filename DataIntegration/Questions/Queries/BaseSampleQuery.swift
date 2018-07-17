//
//  BaseSampleQuery.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class BaseSampleQuery<TypeOfSample: Sample>: NSObject, SampleQuery {

	public typealias SampleType = TypeOfSample

	public var timeConstraints: Set<TimeConstraint>
	public var attributeRestrictions: [AttributeRestriction]
	public var mostRecentEntryOnly: Bool
	public fileprivate(set) var numberOfDatesPerSample: Int = 2
	public var subQuery: (matcher: SubQueryMatcher, query: Query<AnySample>)?

	fileprivate var callback: ((QueryResult<SampleType>?, Error?) -> ())!

	fileprivate var subQueryCallbackParameters: (result: QueryResult<AnySample>?, error: Error?)? = nil
	fileprivate var queryCallbackParameters: (result: QueryResult<TypeOfSample>?, error: Error?)? = nil

	public override init() {
		timeConstraints = Set<TimeConstraint>()
		attributeRestrictions = [AttributeRestriction]()
		mostRecentEntryOnly = false
	}

	public func runQuery(callback: @escaping (QueryResult<SampleType>?, Error?) -> ()) {
		self.callback = callback
		subQuery?.query.runQuery(callback: { (result: QueryResult<AnySample>?, error: Error?) in
			self.subQueryCallbackParameters = (result, error)
			if self.queryCallbackParameters != nil {
				self.filterAndCallBack()
			}
		})
		run()
	}

	func run() {
		fatalError("Must override and call queryDone() when finished")
	}

	func queryDone(_ result: QueryResult<TypeOfSample>?, _ error: Error?) {
		assert(subQueryCallbackParameters != nil, "sub-query callback parameters is nil")
		assert(queryCallbackParameters != nil, "query callback parameters is nil")

		queryCallbackParameters = (result, error)
		if subQuery == nil || subQueryCallbackParameters != nil {
			filterAndCallBack()
		}
	}

	fileprivate func filterAndCallBack() {
		if subQueryCallbackParameters?.error != nil {
			callback(nil, subQueryCallbackParameters!.error)
		}
		if queryCallbackParameters!.error != nil {
			callback(nil, queryCallbackParameters!.error)
		}
		callback(filterResults(), nil)
	}

	fileprivate func filterResults() -> QueryResult<TypeOfSample>? {
		assert(queryCallbackParameters!.result != nil, "query result is nil")

		if subQuery == nil {
			return queryCallbackParameters!.result
		}
		let queryResult = queryCallbackParameters!.result!
		let querySamples = queryResult.samples
		let subQuerySamples = subQueryCallbackParameters!.result!.samples

		let filteredSamples = subQuery!.matcher.getSamples(from: querySamples, matching: subQuerySamples)
		let filteredResult = QueryResult<TypeOfSample>(filteredSamples)
		for information in queryResult.extraInformation {
			filteredResult.addExtraInformation(information)
		}

		return filteredResult
	}
}
