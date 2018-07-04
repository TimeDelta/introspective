//
//  HKQuantitySampleUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class HKQuantitySampleUtil {

	public func compute(operation: Operation, over samples: [HKQuantitySample], withUnit unit: HKUnit) -> [Double] {
		switch(operation.kind) {
			case .average:
				return average(over: samples, per: operation.aggregationUnit, withUnit: unit)
			case .count:
				return count(over: samples, per: operation.aggregationUnit, withUnit: unit)
			case .max:
				return max(over: samples, per: operation.aggregationUnit, withUnit: unit)
			case .min:
				return min(over: samples, per: operation.aggregationUnit, withUnit: unit)
			case .sum:
				return sum(over: samples, per: operation.aggregationUnit, withUnit: unit)
		}
	}

	public func average(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit) -> [Double] {
		if aggregationUnit == nil {
			return [average(over: samples, withUnit: unit)]
		} else {
			var sampleAggregationAverages = [Double]()
			for (_, samples) in sortSamplesByAggregation(samples, aggregationUnit!) {
				sampleAggregationAverages.append(average(over: samples, withUnit: unit))
			}
			return sampleAggregationAverages
		}
	}

	public func average(over samples: [HKQuantitySample], withUnit unit: HKUnit) -> Double {
		var average: Double = 0.0
		for sample in samples {
			average += quantityValue(sample, unit)
		}
		return average / Double(samples.count)
	}

	public func count(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit) -> [Double] {
		if aggregationUnit == nil {
			return [Double(samples.count)]
		} else {
			var sampleAggregationCounts = [Double]()
			for (_, samples) in sortSamplesByAggregation(samples, aggregationUnit!) {
				sampleAggregationCounts.append(Double(samples.count))
			}
			return sampleAggregationCounts
		}
	}

	public func max(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit) -> [Double] {
		if aggregationUnit == nil {
			return [max(over: samples, withUnit: unit)]
		} else {
			var sampleAggregationMaxs = [Double]()
			for (_, samples) in sortSamplesByAggregation(samples, aggregationUnit!) {
				sampleAggregationMaxs.append(max(over: samples, withUnit: unit))
			}
			return sampleAggregationMaxs
		}
	}

	public func max(over samples: [HKQuantitySample], withUnit unit: HKUnit) -> Double{
		return quantityValue(
			samples.max(by: { (sample1: HKQuantitySample, sample2: HKQuantitySample) -> Bool in
				return quantityValue(sample1, unit) < quantityValue(sample2, unit)
			})!,
			unit)
	}

	public func min(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit) -> [Double] {
		if aggregationUnit == nil {
			return [min(over: samples, withUnit: unit)]
		} else {
			var sampleAggregationMins = [Double]()
			for (_, samples) in sortSamplesByAggregation(samples, aggregationUnit!) {
				sampleAggregationMins.append(min(over: samples, withUnit: unit))
			}
			return sampleAggregationMins
		}
	}

	public func min(over samples: [HKQuantitySample], withUnit unit: HKUnit) -> Double {
		return quantityValue(
			samples.min(by: { (sample1: HKQuantitySample, sample2: HKQuantitySample) -> Bool in
				return quantityValue(sample1, unit) < quantityValue(sample2, unit)
			})!,
			unit)
	}

	public func sum(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit) -> [Double] {
		if aggregationUnit == nil {
			return [sum(over: samples, withUnit: unit)]
		} else {
			var sampleAggregationSums = [Double]()
			for (_, samples) in sortSamplesByAggregation(samples, aggregationUnit!) {
				sampleAggregationSums.append(sum(over: samples, withUnit: unit))
			}
			return sampleAggregationSums
		}
	}

	public func sum(over samples: [HKQuantitySample], withUnit unit: HKUnit) -> Double {
		var sum = 0.0
		for sample in samples {
			sum += quantityValue(sample, unit)
		}
		return sum
	}

	public func sortSamplesByAggregation(_ samples: [HKQuantitySample], _ aggregationUnit: Calendar.Component) -> [(date: Date, samples: [HKQuantitySample])] {
		var samplesByAggregation = [Date: [HKQuantitySample]]()
		for sample in samples {
			let aggregationDate = DependencyInjector.util.calendarUtil.zeroAllComponents(toBeginningOf: aggregationUnit, in: sample.endDate)
			samplesByAggregation[aggregationDate]?.append(sample)
		}
		let sortedSamplesByAggregation = samplesByAggregation.sorted { (entry1: (key: Date, value: [HKQuantitySample]), entry2: (key: Date, value: [HKQuantitySample])) -> Bool in
			return entry1.key.compare(entry2.key) == ComparisonResult.orderedAscending
		}
		return sortedSamplesByAggregation.map({ (entry: (key: Date, value: [HKQuantitySample])) -> (date: Date, samples: [HKQuantitySample]) in
			return (date: entry.key, samples: entry.value)
		})
	}

	fileprivate func quantityValue(_ sample: HKQuantitySample, _ unit: HKUnit) -> Double {
		return sample.quantity.doubleValue(for: unit)
	}
}