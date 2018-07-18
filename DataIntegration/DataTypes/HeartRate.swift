//
//  HeartRate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class HeartRate: SampleBase {

	fileprivate typealias Me = HeartRate
	fileprivate static let unit: HKUnit = HKUnit(from: "count/min")

	public static let heartRate = DoubleAttribute(name: "Heart rate", pluralName: "Heart rates")
	public static let attributes: [Attribute] = [heartRate, startDate]

	public override var name: String { return "Heart rate" }
	public override var description: String { return "A measurement of how fast your heart is beating (in beats per minute)." }
	public override var dataType: DataTypes { return .heartRate }
	public override var attributes: [Attribute] { return Me.attributes }

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
		if attribute.name == Me.heartRate.name {
			return heartRate
		}
		if attribute.name == Me.startDate.name {
			return dates[.start]!
		}
		throw SampleError.unknownAttribute
	}

	public override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name == Me.heartRate.name {
			guard let castedValue = value as? Double else { throw SampleError.typeMismatch }
			heartRate = castedValue
			return
		}
		if attribute.name == Me.startDate.name {
			guard let castedValue = value as? Date else { throw SampleError.typeMismatch }
			dates[.start] = castedValue
			return
		}
		throw SampleError.unknownAttribute
	}

	public override func equalTo(_ otherSample: Sample) -> Bool {
		guard let otherHeartRate = otherSample as? HeartRate else { return false }
		return dates[.start]! == otherHeartRate.dates[.start]! && heartRate == otherHeartRate.heartRate
	}
}
