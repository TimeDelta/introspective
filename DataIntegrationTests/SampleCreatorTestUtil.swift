//
//  SampleCreatorTestUtil.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
@testable import DataIntegration

public class SampleCreatorTestUtil {

	/// Create a mock sample
	static func createSample(startDate: Date? = nil, endDate: Date? = nil, withAttributes attributes: [Attribute] = [Attribute]()) -> AnySample {
		let sample = AnySample()
		var dates = [DateType: Date]()
		if startDate != nil {
			dates[.start] = startDate!
		} else {
			dates[.start] = Date()
		}
		if endDate != nil {
			dates[.end] = endDate!
		}
		sample.set(dates: dates)
		sample.attributes = attributes
		return sample
	}

	/// Create a single sample with the specified value for the given attribute
	static func createSample(withValue value: Any, for attribute: Attribute) -> AnySample {
		let sample = createSample(withAttributes: [attribute])
		try! sample.set(attribute: attribute, to: value)
		return sample
	}

	/// Create a single sample with the specified values for the given attributes
	static func createSample(withValues values: [(Any, Attribute)]) -> AnySample {
		let attributes = values.map({ (_, attribute) in return attribute })
		let sample = createSample(withAttributes: attributes)
		for (value, attribute) in values {
			try! sample.set(attribute: attribute, to: value)
		}
		return sample
	}

	/// Create `count` mock samples
	/// - Parameter attributes: Optionally provide the attributes that each sample should have
	static func createSamples(count: Int, withAttributes attributes: [Attribute] = [Attribute]()) -> [AnySample] {
		var samples = [AnySample]()
		for _ in 1...count {
			samples.append(createSample(withAttributes: attributes))
		}
		return samples
	}

	/// Create a new sample for each given value, assigning the value to the given attribute
	static func createSamples(withValues values: [Any], for attribute: Attribute) -> [AnySample] {
		var samples = [AnySample]()
		for value in values {
			samples.append(createSample(withValue: value, for: attribute))
		}
		return samples
	}

	static func createSamples(withDates dates: [(startDate: Date, endDate: Date)]) -> [AnySample] {
		var samples = [AnySample]()
		for (startDate, endDate) in dates {
			samples.append(createSample(startDate: startDate, endDate: endDate))
		}
		return samples
	}

	static func createSamples(withDates dates: [Date]) -> [AnySample] {
		var samples = [AnySample]()
		for date in dates {
			samples.append(createSample(startDate: date))
		}
		return samples
	}

	static func createSamples<ValueType: Any>(_ sampleValues: [(startDate: Date, value: ValueType)], for attribute: Attribute) -> [AnySample] {
		var samples = [AnySample]()
		for values in sampleValues {
			let sample = createSample(startDate: values.startDate, withAttributes: [attribute])
			try! sample.set(attribute: attribute, to: values.value)
			samples.append(sample)
		}
		return samples
	}
}
