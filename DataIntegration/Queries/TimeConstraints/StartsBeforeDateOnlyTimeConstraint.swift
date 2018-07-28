//
//  StartsBeforeDateOnlyTimeConstraint.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class StartsBeforeDateOnlyTimeConstraint: TimeConstraint {

	public static var name: String = "Starts before date"

	fileprivate typealias Me = StartsBeforeDateOnlyTimeConstraint

	public static let dateParameter = DateOnlyParameter(name: "Date")
	public static var parameters: [Parameter] = [
		dateParameter,
	]

	public var description: String {
		let dateText = try! Me.dateParameter.convertToString(from: date)
		return "Starts before " + dateText
	}

	public var date: Date {
		didSet {
			date = DependencyInjector.util.calendarUtil.start(of: .day, in: date)
		}
	}

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
