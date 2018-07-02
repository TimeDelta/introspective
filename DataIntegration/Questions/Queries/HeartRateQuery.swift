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

	public enum ErrorTypes: Error {
		case Unauthorized
		case UnknownOperationType
	}

	public enum CombinationType {
		case And
		case Or
	}

	public var finalOperation: Operations?
	public var startDate: Date?
	public var endDate: Date?
	public var daysOfWeek: Set<DayOfWeek>
	public var daysOfWeekCombinationType: CombinationType
	public var quantityRestrictions: [QuantityRestriction<Double>]

	public override init() {
		daysOfWeek = Set<DayOfWeek>()
		quantityRestrictions = [QuantityRestriction<Double>]()
		daysOfWeekCombinationType = .Or
	}

	public func runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ()) {
		do {
			let predicate = getPredicate()

			if finalOperation != nil && finalOperation != Operations.Count {
				let statsOptions: HKStatisticsOptions = try getStatsOptions()

				DependencyInjector.querierFactory().heartRateQuerier().getStatisticsFromHeartRates(predicate: predicate, statsOptions: statsOptions) {
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
				// TODO
			}
		} catch {
			callback(nil, error)
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

			if daysOfWeekCombinationType == .Or {
				daysOfWeekPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
			} else {
				daysOfWeekPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
			}
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
