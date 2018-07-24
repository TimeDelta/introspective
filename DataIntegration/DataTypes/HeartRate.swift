//
//  HeartRate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class HeartRate: AnySample {

	fileprivate typealias Me = HeartRate
	fileprivate static let unit: HKUnit = HKUnit(from: "count/min")

	public static var attributes: [Attribute] {
		return [.heartRate]
	}

	public var heartRate: Double

	public init(_ value: Double) {
		heartRate = value
		super.init()
	}

	public init(_ value: Double, _ dateType: DateType, _ date: Date) {
		heartRate = value
		super.init(dateType, date)
	}

	public init(_ value: Double, _ dates: [DateType: Date]) {
		heartRate = value
		super.init(dates)
	}

	public init(_ sample: HKQuantitySample) {
		heartRate = sample.quantity.doubleValue(for: Me.unit)
		super.init([.start: sample.startDate, .end: sample.endDate])
	}

	public override func value<ValueType>(of attribute: Attribute) throws -> ValueType {
		switch (attribute) {
			case .heartRate:
				guard let value = heartRate as? ValueType else { throw SampleError.typeMismatch }
				return value
			case .startDate:
				guard let value = dates[.start] as? ValueType else { throw SampleError.typeMismatch }
				return value
			default:
				throw SampleError.unknownAttribute
		}
	}

	public override func setValue<ValueType>(of attribute: Attribute, to value: ValueType) throws {
		switch (attribute) {
			case .heartRate:
				guard let castedValue = value as? Double else { throw SampleError.typeMismatch }
				heartRate = castedValue
				break
			case .startDate:
				guard let castedValue = value as? Date else { throw SampleError.typeMismatch }
				dates[.start] = castedValue
			default:
				throw SampleError.unknownAttribute
		}
	}
}
