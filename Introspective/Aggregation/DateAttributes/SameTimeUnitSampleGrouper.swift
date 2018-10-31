//
//  SameTimeUnitSampleGrouper.swift
//  Introspective
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public final class SameTimeUnitSampleGrouper: SampleGrouper {

	private typealias Me = SameTimeUnitSampleGrouper

	public static let timeUnitAttribute = CalendarComponentAttribute(description: "Combine all samples within the same time unit")
	public static let attributes: [Attribute] = [
		timeUnitAttribute,
	]

	public final let attributedName = "Same time unit"
	public final let attributes: [Attribute] = Me.attributes
	public final var description: String {
		return "per " + timeUnit.description.localizedLowercase
	}

	public final var timeUnit: Calendar.Component = .day

	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SameTimeUnitSampleGrouper"))

	public required init() {}

	public init(_ timeUnit: Calendar.Component) {
		self.timeUnit = timeUnit
	}

	public final func group(samples: [Sample], by attribute: Attribute) -> [(Any, [Sample])] {
		// TODO - support grouping by day of week, hour of day, etc.
		signpost.begin(name: "Aggregation", "Aggregating %d samples", samples.count)
		let samplesByTimeUnit = DependencyInjector.util.sample.aggregate(samples: samples, by: timeUnit, for: attribute)
		signpost.end(name: "Aggregation", "Aggregated %d samples into %d groups", samples.count, samplesByTimeUnit.count)

		signpost.begin(name: "Sort aggregated samples")
		let sortedSamplesByTimeUnit = samplesByTimeUnit.sorted(by: { (entry1, entry2) in return entry1.key.isBeforeDate(entry2.key, granularity: timeUnit) })
		signpost.end(name: "Sort aggregated samples")
		return sortedSamplesByTimeUnit.map({ (key, value) in return (key, value) })
	}

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.timeUnitAttribute) {
			return timeUnit
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.timeUnitAttribute) {
			guard let castedValue = value as? Calendar.Component else { throw AttributeError.typeMismatch }
			timeUnit = castedValue
		}
		throw AttributeError.unknownAttribute
	}
}
