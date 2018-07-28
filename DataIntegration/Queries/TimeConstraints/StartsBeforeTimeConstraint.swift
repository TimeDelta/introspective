//
//  StartsBeforeTimeConstraint.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class StartsBeforeTimeConstraint: TimeConstraint {

	public static var name: String = "Starts before date and time"

	fileprivate typealias Me = StartsBeforeTimeConstraint

	public static let dateParameter = DateTimeParameter(name: "Date")
	public static var parameters: [Parameter] = [
		dateParameter,
	]

	public var description: String {
		return "Starts before " + DependencyInjector.util.calendarUtil.string(for: date)
	}

	public var date: Date

	public required init() {
		date = Date()
	}

	public func get(parameter: Parameter) throws -> Any {
		if parameter.name != Me.dateParameter.name {
			throw ParameterError.unknownParameter
		}
		return date
	}

	public func set(parameter: Parameter, to value: Any) throws {
		if parameter.name != Me.dateParameter.name {
			throw ParameterError.unknownParameter
		}
		guard let castedValue = value as? Date else { throw ParameterError.typeMismatch }
		date = castedValue
	}

	public func isValid() -> Bool {
		return true
	}

	public func sampleAdheres(_ sample: Sample) -> Bool {
		return sample.dates[.start]!.isBeforeDate(date, granularity: .second)
	}
}
