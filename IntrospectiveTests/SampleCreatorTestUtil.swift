//
//  SampleCreatorTestUtil.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
@testable import Introspective

public class SampleCreatorTestUtil {

	/// Create a mock sample
	static func createSample(startDate: Date? = nil, endDate: Date? = nil, withAttributes passedAttributes: [Attribute] = [Attribute]()) -> AnySample {
		let sample = AnySample()
		var dates = [DateType: Date]()
		var finalAttributes = passedAttributes
		if !attributes(finalAttributes, contains: CommonSampleAttributes.startDate) && !attributes(finalAttributes, contains: CommonSampleAttributes.timestamp) {
			finalAttributes.append(CommonSampleAttributes.startDate)
		}
		if startDate != nil {
			dates[.start] = startDate!
		} else {
			dates[.start] = Date()
		}
		if endDate != nil {
			dates[.end] = endDate!
			if !finalAttributes.contains(where: { $0.equalTo(CommonSampleAttributes.endDate) }) {
				finalAttributes.append(CommonSampleAttributes.endDate)
			}
		}
		sample.attributes = finalAttributes
		sample.set(dates: dates)
		return sample
	}

	/// Create a single sample with the specified value for the given attribute
	static func createSample(withValue value: Any, for attribute: Attribute, otherAttributes: [Attribute] = [Attribute]()) -> AnySample {
		var finalAttributes = otherAttributes
		finalAttributes.append(attribute)
		let sample = SampleCreatorTestUtil.createSample(withAttributes: finalAttributes)
		try! sample.set(attribute: attribute, to: value)
		return sample
	}

	/// Create a single sample with the specified values for the given attributes
	static func createSample(withValues values: [(Any, Attribute)]) -> AnySample {
		let attributes = values.map({ (_, attribute) in return attribute })
		let sample = SampleCreatorTestUtil.createSample(withAttributes: attributes)
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
			samples.append(SampleCreatorTestUtil.createSample(withAttributes: attributes))
		}
		return samples
	}

	/// Create a new sample for each given value, assigning the value to the given attribute
	static func createSamples(withValues values: [Any], for attribute: Attribute, otherAttributes: [Attribute] = [Attribute]()) -> [AnySample] {
		var samples = [AnySample]()
		for value in values {
			samples.append(SampleCreatorTestUtil.createSample(withValue: value, for: attribute))
		}
		return samples
	}

	static func createSamples(withDates dates: [(startDate: Date, endDate: Date)]) -> [AnySample] {
		var samples = [AnySample]()
		for (startDate, endDate) in dates {
			samples.append(SampleCreatorTestUtil.createSample(startDate: startDate, endDate: endDate))
		}
		return samples
	}

	static func createSamples(withDates dates: [Date]) -> [AnySample] {
		var samples = [AnySample]()
		for date in dates {
			samples.append(SampleCreatorTestUtil.createSample(startDate: date))
		}
		return samples
	}

	static func createSamples<ValueType: Any>(_ sampleValues: [(startDate: Date, value: ValueType)], for attribute: Attribute, otherAttributes: [Attribute] = [Attribute]()) -> [AnySample] {
		var finalAttributes = otherAttributes
		finalAttributes.append(attribute)
		var samples = [AnySample]()
		for values in sampleValues {
			let sample = SampleCreatorTestUtil.createSample(startDate: values.startDate, withAttributes: finalAttributes)
			try! sample.set(attribute: attribute, to: values.value)
			samples.append(sample)
		}
		return samples
	}

	private static func attributes(_ attributes: [Attribute], contains attribute: Attribute) -> Bool {
		return attributes.contains(where: { $0.equalTo(attribute) })
	}
}
