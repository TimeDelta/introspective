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

	public static let heartRate = DoubleAttribute(name: "Heart rate")
	public static let attributes: [Attribute] = [heartRate]

	public override var name: String { return "Heart rate" }
	public override var description: String { return "A measurement of how fast your heart is beating (in beats per minute)." }

	public var heartRate: Double

	public required init() {
		heartRate = Double()
		super.init()
	}

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

	public override func value(of attribute: Attribute) throws -> Any {
		if attribute.name != Me.heartRate.name { throw SampleError.unknownAttribute }
		return heartRate
	}

	public override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.heartRate.name { throw SampleError.unknownAttribute }
		guard let castedValue = value as? Double else { throw SampleError.typeMismatch }
		heartRate = castedValue
	}
}
