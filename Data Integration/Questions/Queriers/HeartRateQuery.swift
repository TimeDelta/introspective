//
//  HeartRateQuery.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

class HeartRateQuery: NSObject, Query {

	enum ErrorTypes: Error {
		case Unauthorized
		case UnknownOperationType
	}

	var finalOperation: Operations?
	var startDate: Date?
	var endDate: Date?
	var daysOfWeek: Set<DayOfWeek>
	var quantityRestrictions: [QuantityRestriction<Double>]

	override init() {
		daysOfWeek = Set<DayOfWeek>()
		quantityRestrictions = [QuantityRestriction]()
	}

	func runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ()) throws {
		let authorized = try HeartRateQuerier.getAuthorization()
		if !authorized {
			throw ErrorTypes.Unauthorized
		}

		let predicate = getPredicate()

		if finalOperation != nil && finalOperation != Operations.Count {
			let statsOptions: HKStatisticsOptions = try getStatsOptions()

			HeartRateQuerier.getStatisticsFromHeartRates(predicate: predicate, statsOptions: statsOptions) {
				(stats: HKStatistics?, error: Error?) in

				if error != nil {
					callback(nil, error)
				}

				var returnValues = [String: NSObject]()
				if self.finalOperation == Operations.Average {
					returnValues[self.finalOperation!.stringRepresenation] = stats!.averageQuantity()
				} else if self.finalOperation == Operations.Max {
					returnValues[self.finalOperation!.stringRepresenation] = stats!.maximumQuantity()
				} else if self.finalOperation == Operations.Min {
					returnValues[self.finalOperation!.stringRepresenation] = stats!.minimumQuantity()
				} else if self.finalOperation == Operations.Sum {
					returnValues[self.finalOperation!.stringRepresenation] = stats!.sumQuantity()
				}

				callback(returnValues, nil)
			}
		} else {
		}
	}

	fileprivate func getStatsOptions() throws -> HKStatisticsOptions {
		switch (finalOperation) {
			case Operations.Average:
				return .discreteAverage
			case Operations.Max:
				return .discreteMax
			case Operations.Min:
				return .discreteMin
			case Operations.Sum:
				return .cumulativeSum
			default:
				throw ErrorTypes.UnknownOperationType
		}
	}

	fileprivate func getPredicate() -> NSPredicate {
		let datePredicate = getDatePredicate()
		let quantityPredicate = getQuantityPredicate()

		return NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, quantityPredicate])
	}

	fileprivate func getDatePredicate() -> NSPredicate {
		let startEndDatePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

		var daysOfWeekPredicate: NSCompoundPredicate?
		if !daysOfWeek.isEmpty {
			var predicates = [NSPredicate]()
			for dayOfWeek in daysOfWeek {
				let predicate = NSPredicate { (evaluatedObject, _) in
					print((evaluatedObject as! HKQuantitySample))
					return true
				}
				predicates.append(predicate)
			}
			daysOfWeekPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
		}

		var allSubpredicates = [NSPredicate]()
		allSubpredicates.append(startEndDatePredicate)
		if daysOfWeekPredicate != nil {
			allSubpredicates.append(daysOfWeekPredicate!)
		}

		return NSCompoundPredicate(andPredicateWithSubpredicates: allSubpredicates)
	}

	fileprivate func getQuantityPredicate() -> NSPredicate {
		var quantityPredicates = [NSComparisonPredicate]()
		for quantityRestriction in quantityRestrictions {
			let leftHandSide = NSExpression(forKeyPath: quantityRestriction.attribute)
			let rightHandSide = NSExpression(forConstantValue: quantityRestriction.value)
			let quantityPredicate = NSComparisonPredicate(leftExpression: leftHandSide, rightExpression: rightHandSide, modifier: .all, type: quantityRestriction.comparison, options: [])
			quantityPredicates.append(quantityPredicate)
		}
		return NSCompoundPredicate(andPredicateWithSubpredicates: quantityPredicates)
	}
}
