//
//  HeartRate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public final class HeartRate: HealthKitQuantitySample, Equatable, CustomDebugStringConvertible {

	public static func == (lhs: HeartRate, rhs: HeartRate) -> Bool {
		return lhs.equalTo(rhs)
	}

	private typealias Me = HeartRate

	public static let beatsPerMinute: HKUnit = HKUnit(from: "count/min")

	public static let heartRate = DoubleAttribute(name: "Heart rate", pluralName: "Heart rates", variableName: HKPredicateKeyPathQuantity)
	public static let timestamp = DateTimeAttribute(name: "Timestamp", pluralName: "Timestamps", variableName: HKPredicateKeyPathStartDate)
	public static let attributes: [Attribute] = [timestamp, heartRate]

	public final var debugDescription: String {
		return "HeartRate of \(heartRate) at " + DependencyInjector.util.calendarUtil.string(for: timestamp)
	}

	public final var name: String { return "Heart rate" }
	public final var description: String { return "A measurement of how fast your heart is beating (in beats per minute)." }
	public final var dataType: DataTypes { return .heartRate }
	public final var attributes: [Attribute] { return Me.attributes }
	public final var timestamp: Date

	public final var heartRate: Double

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
		heartRate = sample.quantity.doubleValue(for: Me.beatsPerMinute)
		timestamp = sample.startDate
	}

	public final func quantityUnit() -> HKUnit {
		return Me.beatsPerMinute
	}

	public final func quantityValue() -> Double {
		return heartRate
	}

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	public final func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(Me.heartRate) {
			return heartRate
		}
		if attribute.equalTo(Me.timestamp) {
			return timestamp
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any) throws {
		if attribute.equalTo(Me.heartRate) {
			guard let castedValue = value as? Double else { throw AttributeError.typeMismatch }
			heartRate = castedValue
			return
		}
		if attribute.equalTo(Me.timestamp) {
			guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
			timestamp = castedValue
			return
		}
		throw AttributeError.unknownAttribute
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is HeartRate) { return false }
		let other = otherAttributed as! HeartRate
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is HeartRate) { return false }
		let other = otherSample as! HeartRate
		return equalTo(other)
	}

	public final func equalTo(_ other: HeartRate) -> Bool {
		return timestamp == other.timestamp && heartRate == other.heartRate
	}
}
