//
//  HeartRateQuery.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class HeartRateQuery: NSObject, Query {

	fileprivate typealias Me = HeartRateQuery

	fileprivate static let countPerMinute = HKUnit(from: "count/min")

	public enum ErrorTypes: Error {
		case Unauthorized
		case NoSamplesFound
		case NoReturnTypeSpecified
		case ReturnTypeIsFinalOperationButNoOperationSpecified
	}

	public var finalOperation: QueryOperation?
	public var startDate: Date?
	public var endDate: Date?
	public var daysOfWeek: Set<DayOfWeek>
	public var attributeRestrictions: [AttributeRestriction]
	public var returnType: ReturnType?
	public var mostRecentEntryOnly: Bool

	public override init() {
		daysOfWeek = Set<DayOfWeek>()
		attributeRestrictions = [AttributeRestriction]()
		mostRecentEntryOnly = false
	}

	public func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
		if returnType == nil {
			callback(nil, ErrorTypes.NoReturnTypeSpecified)
		}
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

		DependencyInjector.querier.heartRateQuerier.getHeartRates(predicate: predicate) {
			(originalSamples: Array<HKQuantitySample>?, error: Error?) in

			if error != nil {
				callback(nil, error)
			}
			if originalSamples == nil || originalSamples!.count == 0 {
				callback(nil, ErrorTypes.NoSamplesFound)
			}

			let samples = originalSamples!.filter({ (sample: HKQuantitySample) in
				return self.matchesAttributeRestrictionCriteria(sample) && DependencyInjector.util.hkSampleUtil.sample(sample, occursOnOneOf: self.daysOfWeek)
			})

			var finalAnswer: Any? = nil
			do {
				switch(self.returnType!) {
					case .finalOperation:
						finalAnswer = try self.computeFinalOperation(samples)
						break
					case .startDates:
						finalAnswer = self.getStartDates(samples)
						break
					case .endDates:
						finalAnswer = self.getEndDates(samples)
						break
					case let .times(aggregationUnit):
						finalAnswer = self.getTimeIntervals(samples, aggregationUnit)
						break
					case .attributes:
						finalAnswer = self.getAttributes(samples)
						break
				}
			} catch {
				callback(nil, error)
			}

			callback(QueryResult(finalAnswer!, self.returnType!), nil)
		}
	}

	fileprivate func matchesAttributeRestrictionCriteria(_ sample: HKQuantitySample) -> Bool {
		return true // TODO
	}

	fileprivate func computeFinalOperation(_ samples: [HKQuantitySample]) throws -> [(date: Date?, value: Double)] {
		if self.finalOperation != nil {
			return DependencyInjector.util.hkQuantitySampleUtil.compute(operation: finalOperation!, over: samples, withUnit: Me.countPerMinute)
		} else {
			throw ErrorTypes.ReturnTypeIsFinalOperationButNoOperationSpecified
		}
	}

	fileprivate func getStartDates(_ samples: [HKQuantitySample]) -> [Date] {
		return samples.map({ (sample: HKQuantitySample) in
			return sample.startDate
		})
	}

	fileprivate func getEndDates(_ samples: [HKQuantitySample]) -> [Date] {
		return samples.map({ (sample: HKQuantitySample) in
			return sample.endDate
		})
	}

	fileprivate func getTimeIntervals(_ samples: [HKQuantitySample], _ aggregationUnit: Calendar.Component) -> [DateInterval] {
		return samples.map({ (sample: HKQuantitySample) in
			let calendar = Calendar.current
			return calendar.dateInterval(of: aggregationUnit, for: sample.endDate)!
		})
	}

	fileprivate func getAttributes(_ samples: [HKQuantitySample]) -> [[String: String]]{
		var sampleAttributeMaps = [[String: String]]()
		for sample in samples {
			let attributeMap: [String: String] = [
				"Start Date": String(describing: sample.startDate),
				"End Date": String(describing: sample.endDate),
				"Heart Rate": String(sample.quantity.doubleValue(for: Me.countPerMinute)),
			]
			sampleAttributeMaps.append(attributeMap)
		}
		return sampleAttributeMaps
	}
}
