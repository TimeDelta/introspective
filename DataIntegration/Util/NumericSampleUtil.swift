//
//  NumericSampleUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class NumericSampleUtil {

	/// - Precondition: The provided samples array is not empty.
	public func compute<SampleType: NumericSample>(operation: QueryOperation, over samples: [SampleType]) -> [(date: Date?, value: Double)] {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		switch(operation.kind) {
			case .average:
				return average(over: samples, per: operation.aggregationUnit)
			case .count:
				return count(over: samples, per: operation.aggregationUnit)
			case .max:
				return max(over: samples, per: operation.aggregationUnit)
			case .min:
				return min(over: samples, per: operation.aggregationUnit)
			case .sum:
				return sum(over: samples, per: operation.aggregationUnit)
		}
	}

	/// - Precondition: The provided samples array is not empty.
	public func average<SampleType: NumericSample>(over samples: [SampleType], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Double)] {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: average(over: samples))]
		} else {
			var sampleAggregationAverages = [(date: Date?, value: Double)]()
			for (aggregationDate, samples) in DependencyInjector.util.sampleUtil.sort(samples: samples, by: aggregationUnit!) {
				sampleAggregationAverages.append((date: aggregationDate, value: average(over: samples)))
			}
			return sampleAggregationAverages
		}
	}

	/// - Precondition: The provided samples array is not empty.
	public func average<SampleType: NumericSample>(over samples: [SampleType]) -> Double {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		var average: Double = 0.0
		for sample in samples {
			average += sample.value
		}
		return average / Double(samples.count)
	}

	/// - Precondition: The provided samples array is not empty.
	public func count<SampleType: NumericSample>(over samples: [SampleType], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Double)] {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: Double(samples.count))]
		} else {
			var sampleAggregationCounts = [(date: Date?, value: Double)]()
			for (aggregationDate, samples) in DependencyInjector.util.sampleUtil.sort(samples: samples, by: aggregationUnit!) {
				sampleAggregationCounts.append((date: aggregationDate, value: Double(samples.count)))
			}
			return sampleAggregationCounts
		}
	}

	/// - Precondition: The provided samples array is not empty.
	public func max<SampleType: NumericSample>(over samples: [SampleType], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Double)] {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: max(over: samples))]
		} else {
			var sampleAggregationMaxs = [(date: Date?, value: Double)]()
			for (aggregationDate, samples) in DependencyInjector.util.sampleUtil.sort(samples: samples, by: aggregationUnit!) {
				sampleAggregationMaxs.append((date: aggregationDate, value: max(over: samples)))
			}
			return sampleAggregationMaxs
		}
	}

	/// - Precondition: The provided samples array is not empty.
	public func max<SampleType: NumericSample>(over samples: [SampleType]) -> Double {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		return samples.max(by: { (sample1: SampleType, sample2: SampleType) -> Bool in
			return sample1.value < sample2.value
		})!.value
	}

	/// - Precondition: The provided samples array is not empty.
	public func min<SampleType: NumericSample>(over samples: [SampleType], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Double)] {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: min(over: samples))]
		} else {
			var sampleAggregationMins = [(date: Date?, value: Double)]()
			for (aggregationDate, samples) in DependencyInjector.util.sampleUtil.sort(samples: samples, by: aggregationUnit!) {
				sampleAggregationMins.append((date: aggregationDate, value: min(over: samples)))
			}
			return sampleAggregationMins
		}
	}

	/// - Precondition: The provided samples array is not empty.
	public func min<SampleType: NumericSample>(over samples: [SampleType]) -> Double {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		return samples.min(by: { (sample1: SampleType, sample2: SampleType) -> Bool in
			return sample1.value < sample2.value
		})!.value
	}

	/// - Precondition: The provided samples array is not empty.
	public func sum<SampleType: NumericSample>(over samples: [SampleType], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Double)] {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: sum(over: samples))]
		} else {
			var sampleAggregationSums = [(date: Date?, value: Double)]()
			for (aggregationDate, samples) in DependencyInjector.util.sampleUtil.sort(samples: samples, by: aggregationUnit!) {
				sampleAggregationSums.append((date: aggregationDate, value: sum(over: samples)))
			}
			return sampleAggregationSums
		}
	}

	/// - Precondition: The provided samples array is not empty.
	public func sum<SampleType: NumericSample>(over samples: [SampleType]) -> Double {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		var sum = 0.0
		for sample in samples {
			sum += sample.value
		}
		return sum
	}
}
