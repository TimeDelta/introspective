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

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to a `Double`
	/// - Precondition: The provided samples array is not empty.
	public func average(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Double)] {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: average(for: attribute, over: samples))]
		} else {
			var sampleAggregationAverages = [(date: Date?, value: Double)]()
			for (aggregationDate, samples) in DependencyInjector.util.sampleUtil.sort(samples: samples, by: aggregationUnit!) {
				sampleAggregationAverages.append((date: aggregationDate, value: average(for: attribute, over: samples)))
			}
			return sampleAggregationAverages
		}
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to a `Double`
	/// - Precondition: The provided samples array is not empty.
	public func average(for attribute: Attribute, over samples: [Sample]) -> Double {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		var average: Double = 0.0
		for sample in samples {
			average += try! sample.value(of: attribute)
		}
		return average / Double(samples.count)
	}

	/// - Precondition: The provided samples array is not empty.
	public func count(over samples: [Sample], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Int)] {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: samples.count)]
		} else {
			var sampleAggregationCounts = [(date: Date?, value: Int)]()
			for (aggregationDate, samples) in DependencyInjector.util.sampleUtil.sort(samples: samples, by: aggregationUnit!) {
				sampleAggregationCounts.append((date: aggregationDate, value: samples.count))
			}
			return sampleAggregationCounts
		}
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	public func max<Type: Comparable>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Type)] {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: max(for: attribute, over: samples))]
		} else {
			var sampleAggregationMaxs = [(date: Date?, value: Type)]()
			for (aggregationDate, samples) in DependencyInjector.util.sampleUtil.sort(samples: samples, by: aggregationUnit!) {
				sampleAggregationMaxs.append((date: aggregationDate, value: max(for: attribute, over: samples)))
			}
			return sampleAggregationMaxs
		}
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	public func max<Type: Comparable>(for attribute: Attribute, over samples: [Sample]) -> Type {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		return try! samples.max(by: { (sample1: Sample, sample2: Sample) -> Bool in
			let value1: Type = try! sample1.value(of: attribute)
			let value2: Type = try! sample2.value(of: attribute)
			return value1 < value2
		})!.value(of: attribute)
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	public func min<Type: Comparable>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Type)] {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: min(for: attribute, over: samples))]
		} else {
			var sampleAggregationMins = [(date: Date?, value: Type)]()
			for (aggregationDate, samples) in DependencyInjector.util.sampleUtil.sort(samples: samples, by: aggregationUnit!) {
				sampleAggregationMins.append((date: aggregationDate, value: min(for: attribute, over: samples)))
			}
			return sampleAggregationMins
		}
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	public func min<Type: Comparable>(for attribute: Attribute, over samples: [Sample]) -> Type {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		return try! samples.min(by: { (sample1: Sample, sample2: Sample) -> Bool in
			let value1: Type = try! sample1.value(of: attribute)
			let value2: Type = try! sample2.value(of: attribute)
			return value1 < value2
		})!.value(of: attribute)
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	public func sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Type)] {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: sum(for: attribute, over: samples))]
		} else {
			var sampleAggregationSums = [(date: Date?, value: Type)]()
			for (aggregationDate, samples) in DependencyInjector.util.sampleUtil.sort(samples: samples, by: aggregationUnit!) {
				sampleAggregationSums.append((date: aggregationDate, value: sum(for: attribute, over: samples)))
			}
			return sampleAggregationSums
		}
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	public func sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample]) -> Type {
		assert(samples.count > 0, "Precondition violated: provided samples array must not be empty")

		var sum: Type = 0
		for sample in samples {
			sum += try! sample.value(of: attribute)
		}
		return sum
	}
}
