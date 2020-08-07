//
//  NumericSampleUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Attributes
import DependencyInjection

// sourcery: AutoMockable
public protocol NumericSampleUtil {
	/// - Parameter attribute: The attribute of each sample to average
	func average(
		for attribute: Attribute,
		over samples: [Sample],
		per aggregationUnit: Calendar.Component?
	) throws -> [(date: Date?, value: Double)]
	/// - Parameter attribute: The attribute of each sample to average
	func average(for attribute: Attribute, over samples: [Sample]) throws -> Double

	func count(over samples: [Sample], per aggregationUnit: Calendar.Component?) throws -> [(date: Date?, value: Int)]

	// these all need the "as: Type.Type" parameter because there's a bug with SwitfyMocky
	// see https://github.com/MakeAWishFoundation/SwiftyMocky/issues/163 for more info

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	func max<Type: Comparable>(
		for attribute: Attribute,
		over samples: [Sample],
		per aggregationUnit: Calendar.Component?,
		as: Type.Type
	) throws -> [(date: Date?, value: Type)]
	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	func max<Type: Comparable>(for attribute: Attribute, over samples: [Sample], as: Type.Type) throws -> Type
	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	func min<Type: Comparable>(
		for attribute: Attribute,
		over samples: [Sample],
		per aggregationUnit: Calendar.Component?,
		as: Type.Type
	) throws -> [(date: Date?, value: Type)]
	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	func min<Type: Comparable>(for attribute: Attribute, over samples: [Sample], as: Type.Type) throws -> Type

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	func sum<Type: Numeric>(
		for attribute: Attribute,
		over samples: [Sample],
		per aggregationUnit: Calendar.Component?,
		as: Type.Type
	) throws -> [(date: Date?, value: Type)]
	func sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample], as: Type.Type) throws -> Type
}

public extension NumericSampleUtil {
	func count(
		over samples: [Sample],
		per aggregationUnit: Calendar.Component? = nil
	) throws -> [(date: Date?, value: Int)] {
		try count(over: samples, per: aggregationUnit)
	}
}

public final class NumericSampleUtilImpl: NumericSampleUtil {
	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to a `Double`
	/// - Precondition: The provided samples array is not empty.
	public final func average(
		for attribute: Attribute,
		over samples: [Sample],
		per aggregationUnit: Calendar.Component?
	) throws -> [(date: Date?, value: Double)] {
		precondition(!samples.isEmpty, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: try average(for: attribute, over: samples))]
		}

		var sampleAggregationAverages = [(date: Date?, value: Double)]()
		for (aggregationDate, samples) in try injected(SampleUtil.self)
			.sort(samples: samples, by: aggregationUnit!) {
			sampleAggregationAverages.append((date: aggregationDate, value: try average(for: attribute, over: samples)))
		}
		return sampleAggregationAverages
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to a `Double`
	/// - Precondition: The provided samples array is not empty.
	public final func average(for attribute: Attribute, over samples: [Sample]) throws -> Double {
		precondition(!samples.isEmpty, "Precondition violated: provided samples array must not be empty")

		var average: Double = 0.0
		var totalNonNilSamples = 0.0
		for sample in samples {
			let value = try sample.value(of: attribute)
			if let castedValue = value as? Double {
				average += castedValue
				totalNonNilSamples += 1
			} else if let castedValue = value as? Int {
				average += Double(castedValue)
				totalNonNilSamples += 1
			} else if !attribute.optional {
				throw TypeMismatchError(attribute: attribute, of: sample, wasA: type(of: value))
			}
		}
		return average / totalNonNilSamples
	}

	/// - Precondition: The provided samples array is not empty.
	public final func count(
		over samples: [Sample],
		per aggregationUnit: Calendar.Component? = nil
	) throws -> [(date: Date?, value: Int)] {
		precondition(!samples.isEmpty, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: samples.count)]
		}

		var sampleAggregationCounts = [(date: Date?, value: Int)]()
		for (aggregationDate, samples) in try injected(SampleUtil.self)
			.sort(samples: samples, by: aggregationUnit!) {
			sampleAggregationCounts.append((date: aggregationDate, value: samples.count))
		}
		return sampleAggregationCounts
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	public final func max<Type: Comparable>(
		for attribute: Attribute,
		over samples: [Sample],
		per aggregationUnit: Calendar.Component?,
		as _: Type.Type
	) throws -> [(date: Date?, value: Type)] {
		precondition(!samples.isEmpty, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: try max(for: attribute, over: samples, as: Type.self))]
		}

		var sampleAggregationMaxs = [(date: Date?, value: Type)]()
		for (aggregationDate, samples) in try injected(SampleUtil.self)
			.sort(samples: samples, by: aggregationUnit!) {
			sampleAggregationMaxs
				.append((date: aggregationDate, value: try max(for: attribute, over: samples, as: Type.self)))
		}
		return sampleAggregationMaxs
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	public final func max<Type: Comparable>(
		for attribute: Attribute,
		over samples: [Sample],
		as _: Type.Type
	) throws -> Type {
		precondition(!samples.isEmpty, "Precondition violated: provided samples array must not be empty")

		return try samples.max(by: { (sample1: Sample, sample2: Sample) -> Bool in
			let value1 = try sample1.value(of: attribute)
			guard let castedValue1 = value1 as? Type else {
				throw TypeMismatchError(attribute: attribute, of: sample1, wasA: type(of: value1))
			}
			let value2 = try sample2.value(of: attribute)
			guard let castedValue2 = value2 as? Type else {
				throw TypeMismatchError(attribute: attribute, of: sample2, wasA: type(of: value2))
			}
			return castedValue1 < castedValue2
		})!.value(of: attribute) as! Type
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	public final func min<Type: Comparable>(
		for attribute: Attribute,
		over samples: [Sample],
		per aggregationUnit: Calendar.Component?,
		as _: Type.Type
	) throws -> [(date: Date?, value: Type)] {
		precondition(!samples.isEmpty, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: try min(for: attribute, over: samples, as: Type.self))]
		}

		var sampleAggregationMins = [(date: Date?, value: Type)]()
		for (aggregationDate, samples) in try injected(SampleUtil.self)
			.sort(samples: samples, by: aggregationUnit!) {
			sampleAggregationMins
				.append((date: aggregationDate, value: try min(for: attribute, over: samples, as: Type.self)))
		}
		return sampleAggregationMins
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	public final func min<Type: Comparable>(
		for attribute: Attribute,
		over samples: [Sample],
		as _: Type.Type
	) throws -> Type {
		precondition(!samples.isEmpty, "Precondition violated: provided samples array must not be empty")

		return try samples.min(by: { (sample1: Sample, sample2: Sample) -> Bool in
			let value1 = try sample1.value(of: attribute)
			guard let castedValue1 = value1 as? Type else {
				throw TypeMismatchError(attribute: attribute, of: sample1, wasA: type(of: value1))
			}
			let value2 = try sample2.value(of: attribute)
			guard let castedValue2 = value2 as? Type else {
				throw TypeMismatchError(attribute: attribute, of: sample2, wasA: type(of: value2))
			}
			return castedValue1 < castedValue2
		})!.value(of: attribute) as! Type
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	public final func sum<Type: Numeric>(
		for attribute: Attribute,
		over samples: [Sample],
		per aggregationUnit: Calendar.Component?,
		as _: Type.Type
	) throws -> [(date: Date?, value: Type)] {
		precondition(!samples.isEmpty, "Precondition violated: provided samples array must not be empty")

		if aggregationUnit == nil {
			return [(date: nil, value: try sum(for: attribute, over: samples, as: Type.self))]
		}

		var sampleAggregationSums = [(date: Date?, value: Type)]()
		for (aggregationDate, samples) in try injected(SampleUtil.self)
			.sort(samples: samples, by: aggregationUnit!) {
			sampleAggregationSums
				.append((date: aggregationDate, value: try sum(for: attribute, over: samples, as: Type.self)))
		}
		return sampleAggregationSums
	}

	/// - Note: It is the caller's job to make sure that the specified attribute can be cast to the specified type.
	/// - Precondition: The provided samples array is not empty.
	public final func sum<Type: Numeric>(
		for attribute: Attribute,
		over samples: [Sample],
		as _: Type.Type
	) throws -> Type {
		precondition(!samples.isEmpty, "Precondition violated: provided samples array must not be empty")

		var sum: Type = 0
		for sample in samples {
			let value = try sample.value(of: attribute)
			if let castedValue = value as? Type {
				sum += castedValue
			} else if !attribute.optional {
				throw TypeMismatchError(attribute: attribute, of: sample, wasA: type(of: value))
			}
		}
		return sum
	}
}
