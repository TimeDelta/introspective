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

	fileprivate static let timeUnitParam = CalendarComponentAggregationParameter(
		name: "Time Unit",
		description: "Combine all samples within the same _")

	public static let name = "Per time unit"
	public static let parameters: [Parameter] = [
		timeUnitParam,
	]

	public override var description: String {
		return "per " + timeUnit.description.localizedLowercase
	}

	public fileprivate(set) var timeUnit: Calendar.Component = .day

	public override required init() {}

	public func aggregate(samples: [Sample]) throws -> [(Aggregatable, [Sample])] {
		return []
	}

	public func get(parameter: Parameter) throws -> String {
		if parameter.name == Me.timeUnitParam.name {
			return timeUnit.description
		} else {
			throw AggregationError.unknownParameter
		}
	}

	public func set(parameter: Parameter, to value: Any) throws {
		if parameter.name == Me.timeUnitParam.name {
			guard let castedValue = value as? Calendar.Component else { throw AggregationError.typeMismatch }
			timeUnit = castedValue
		} else {
			throw AggregationError.unknownParameter
		}
	}
}
