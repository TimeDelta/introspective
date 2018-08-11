//
//  SameTimeUnitSampleGrouper.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SameTimeUnitSampleGrouper: SampleGrouper {

	fileprivate typealias Me = SameTimeUnitSampleGrouper

	public static let timeUnitParam = CalendarComponentAttribute(description: "Combine all samples within the same time unit")
	public static let attributes: [Attribute] = [
		timeUnitParam,
	]

	public let name = "Same time unit"
	public let attributes: [Attribute] = Me.attributes
	public var description: String {
		return "per " + timeUnit.description.localizedLowercase
	}

	public var timeUnit: Calendar.Component = .day

	public required init() {}

	public func group(samples: [Sample], by attribute: Attribute) -> [(Any, [Sample])] {
		var samplesByTimeUnit: [Date: [Sample]]
		if attribute.equalTo(CommonSampleAttributes.startDate) || attribute.equalTo(CommonSampleAttributes.timestamp) {
			samplesByTimeUnit = DependencyInjector.util.sampleUtil.aggregate(samples: samples, by: timeUnit, dateType: .start)
		} else if attribute.equalTo(CommonSampleAttributes.endDate) {
			samplesByTimeUnit = DependencyInjector.util.sampleUtil.aggregate(samples: samples, by: timeUnit, dateType: .end)
		} else {
			samplesByTimeUnit = DependencyInjector.util.sampleUtil.aggregate(samples: samples, by: timeUnit)
		}
		return samplesByTimeUnit
			.sorted(by: { (entry1, entry2) in return entry1.key.isBeforeDate(entry2.key, granularity: timeUnit) })
			.map({ (key, value) in return (key, value) })
	}

	public func value(of attribute: Attribute) throws -> Any {
		if attribute.name == Me.timeUnitParam.name {
			return timeUnit
		}
		throw AttributeError.unknownAttribute
	}

	public func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.timeUnitParam.name {
			throw AttributeError.unknownAttribute
		}
		guard let castedValue = value as? Calendar.Component else { throw AttributeError.typeMismatch }
		timeUnit = castedValue
	}
}
