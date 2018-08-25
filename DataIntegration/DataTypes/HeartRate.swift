//
//  HeartRate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class HeartRate: Sample, Equatable, CustomDebugStringConvertible {

	public static func == (lhs: HeartRate, rhs: HeartRate) -> Bool {
		return lhs.equalTo(rhs)
	}

	fileprivate typealias Me = HeartRate
	fileprivate static let unit: HKUnit = HKUnit(from: "count/min")

	public static let heartRate = DoubleAttribute(name: "Heart rate", pluralName: "Heart rates", variableName: HKPredicateKeyPathQuantity)
	public static let timestamp = DateTimeAttribute(name: "Timestamp", pluralName: "Timestamps", variableName: HKPredicateKeyPathStartDate)
	public static let attributes: [Attribute] = [timestamp, heartRate]

	public var debugDescription: String {
		return "HeartRate of \(heartRate) at " + DependencyInjector.util.calendarUtil.string(for: timestamp)
	}

	public var name: String { return "Heart rate" }
	public var description: String { return "A measurement of how fast your heart is beating (in beats per minute)." }
	public var dataType: DataTypes { return .heartRate }
	public var attributes: [Attribute] { return Me.attributes }
	public var timestamp: Date

	public var heartRate: Double

	public init() {
		heartRate = Double()
		timestamp = Date()
	}

	public init(_ timestamp: Date) {
		heartRate = Double()
		self.timestamp = timestamp
	}

	public init(_ value: Double) {
		heartRate = value
		timestamp = Date()
	}

	public init(_ value: Double, _ timestamp: Date) {
		heartRate = value
		self.timestamp = timestamp
	}

	public init(_ sample: HKQuantitySample) {
		heartRate = sample.quantity.doubleValue(for: Me.unit)
		timestamp = sample.startDate
	}

	public func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	public func value(of attribute: Attribute) throws -> Any {
		if attribute.name == Me.heartRate.name {
			return heartRate
		}
		if attribute.name == CommonSampleAttributes.timestamp.name {
			return timestamp
		}
		throw SampleError.unknownAttribute
	}

	public func set(attribute: Attribute, to value: Any) throws {
		if attribute.name == Me.heartRate.name {
			guard let castedValue = value as? Double else { throw SampleError.typeMismatch }
			heartRate = castedValue
			return
		}
		if attribute.name == CommonSampleAttributes.timestamp.name {
			guard let castedValue = value as? Date else { throw SampleError.typeMismatch }
			timestamp = castedValue
			return
		}
		throw SampleError.unknownAttribute
	}

	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is HeartRate) { return false }
		let other = otherAttributed as! HeartRate
		return equalTo(other)
	}

	public func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is HeartRate) { return false }
		let other = otherSample as! HeartRate
		return equalTo(other)
	}

	public func equalTo(_ other: HeartRate) -> Bool {
		return timestamp == other.timestamp && heartRate == other.heartRate
	}
}
