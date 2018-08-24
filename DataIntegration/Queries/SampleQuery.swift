//
//  BaseSampleQuery.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SampleQuery: Query {
	associatedtype SampleType: Sample

	var attributeRestrictions: [AttributeRestriction] { get set }
	var mostRecentEntryOnly: Bool { get set }

	func runQuery(callback: @escaping (SampleQueryResult<SampleType>?, Error?) -> ())
}

public class SampleQueryImpl<SampleType: Sample>: SampleQuery {

	public var attributeRestrictions: [AttributeRestriction]
	public var mostRecentEntryOnly: Bool
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

	public func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
		runQuery { (result: SampleQueryResult<SampleType>?, error: Error?) in
			callback(result, error)
		}
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

	func getPredicate() -> NSPredicate {
		var subPredicates = [NSPredicate]()
		for attributeRestriction in attributeRestrictions {
			if let predicateRestriction = attributeRestriction as? PredicateAttributeRestriction {
				subPredicates.append(predicateRestriction.toPredicate())
			}
		}
		return NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
	}

	func samplePassesFilters(_ sample: Sample) -> Bool {
		for attributeRestriction in attributeRestrictions {
			if !(attributeRestriction is PredicateAttributeRestriction) {
				if try! !attributeRestriction.samplePasses(sample) {
					return false
				}
			}
		}
		return true
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
		let subQuerySamples = subQueryCallbackParameters!.result!.samples

		let filteredSamples: [SampleType] = subQuery!.matcher.getSamples(from: querySamples, matching: subQuerySamples)
		let filteredResult = SampleQueryResult<SampleType>(filteredSamples)

		return filteredResult
	}
}
