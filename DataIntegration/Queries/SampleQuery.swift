//
//  BaseSampleQuery.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SampleQuery<SampleType: Sample>: TypedQuery {

	public var attributeRestrictions: [AttributeRestriction]
	public var mostRecentEntryOnly: Bool
	public let numberOfDatesPerSample: Int = 2
	public var subQuery: (matcher: SubQueryMatcher, query: Query)?

	fileprivate var callback: ((SampleQueryResult<SampleType>?, Error?) -> ())!

	fileprivate var subQueryCallbackParameters: (result: QueryResult?, error: Error?)? = nil
	fileprivate var queryCallbackParameters: (result: SampleQueryResult<SampleType>?, error: Error?)? = nil

	public init() {
		attributeRestrictions = [AttributeRestriction]()
		mostRecentEntryOnly = false
	}

	public func runQuery(callback: @escaping (SampleQueryResult<SampleType>?, Error?) -> ()) {
		self.callback = callback
		subQuery?.query.runQuery(callback: { (result: QueryResult?, error: Error?) in
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

	func queryDone(_ result: SampleQueryResult<SampleType>?, _ error: Error?) {
		queryCallbackParameters = (result, error)
		if subQuery == nil || subQueryCallbackParameters != nil {
			filterAndCallBack()
		}
	}

	fileprivate func filterAndCallBack() {
		if subQueryCallbackParameters?.error != nil {
			callback(nil, subQueryCallbackParameters!.error)
			return
		}
		if queryCallbackParameters!.error != nil {
			callback(nil, queryCallbackParameters!.error)
			return
		}
		callback(filterResults(), nil)
	}

	fileprivate func filterResults() -> SampleQueryResult<SampleType>? {
		assert(queryCallbackParameters!.result != nil, "query result is nil")

		if subQuery == nil {
			return queryCallbackParameters!.result
		}
		let queryResult = queryCallbackParameters!.result!
		let querySamples = queryResult.typedSamples
		let subQuerySamples = subQueryCallbackParameters!.result!.samples as! [SampleBase]

		let filteredSamples: [SampleType] = subQuery!.matcher.getSamples(from: querySamples, matching: subQuerySamples)
		let filteredResult = SampleQueryResult<SampleType>(filteredSamples)

		return filteredResult
	}
}
