//
//  HeartRate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public final class HeartRate: HealthKitQuantitySample {

	private typealias Me = HeartRate

	// MARK: - HealthKit Stuff

	public static let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
	public static let sampleType: HKSampleType = quantityType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])
	public static let unit: HKUnit = HealthManager.preferredUnitFor(.heartRate) ?? HKUnit(from: "count/min")
	public final let unitString: String = "bpm"

	// MARK: - Display Information

	public static let name: String = "Heart Rate"
	public static let description: String = "A measurement of how fast your heart is beating (in beats per minute)."

	// MARK: - Attributes

	public static let heartRate = DoubleAttribute(name: "Heart rate", pluralName: "Heart rates", variableName: HKPredicateKeyPathQuantity)
	public static let timestamp = DateTimeAttribute(name: "Timestamp", pluralName: "Timestamps", variableName: HKPredicateKeyPathStartDate)
	public static let attributes: [Attribute] = [timestamp, heartRate]
	public static let defaultDependentAttribute: Attribute = heartRate
	public static let defaultIndependentAttribute: Attribute = timestamp
	public final var attributes: [Attribute] { return Me.attributes }

	// MARK: - Instance Member Variables

	public final var name: String = Me.name
	public final var description: String = Me.description
	public final var timestamp: Date
	public final var heartRate: Double

	// MARK: - Initializers

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

	public required init(_ sample: HKQuantitySample) {
		heartRate = sample.quantity.doubleValue(for: Me.unit)
		timestamp = sample.startDate
	}

	// MARK: - HealthKitSample Functions

	public func hkSample() -> HKSample {
		let quantity = HKQuantity(unit: Me.unit, doubleValue: quantityValue())
		return HKQuantitySample(type: Me.quantityType, quantity: quantity, start: timestamp, end: timestamp)
	}

	// MARK: - HealthKitQuantitySample Functions

	public func quantityValue() -> Double {
		return heartRate
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	// MARK: - Attributed Functions

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
}

// MARK: - Equatable

extension HeartRate: Equatable {

	public static func ==(lhs: HeartRate, rhs: HeartRate) -> Bool {
		return lhs.equalTo(rhs)
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

// MARK: - Debug

extension HeartRate: CustomDebugStringConvertible {

	public final var debugDescription: String {
		return "HeartRate of \(heartRate) at " + DependencyInjector.util.calendarUtil.string(for: timestamp)
	}
}
