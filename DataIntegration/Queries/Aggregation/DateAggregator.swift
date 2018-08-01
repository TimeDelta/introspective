//
//  DateAggregator.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DateAggregator: NSObject, Aggregator {

	fileprivate typealias Me = DateAggregator

	public static let timeUnitParam = CalendarComponentAttribute(
		name: "Time Unit",
		description: "Combine all samples within the same _")
	public static let attributes: [Attribute] = [
		timeUnitParam,
	]

	public let name = "Per time unit"
	public let attributes: [Attribute] = Me.attributes
	public override var description: String {
		return "per " + timeUnit.description.localizedLowercase
	}

	public fileprivate(set) var timeUnit: Calendar.Component = .day

	public override required init() {}

	public func aggregate(samples: [Sample]) throws -> [(Aggregatable, [Sample])] {
		return []
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
