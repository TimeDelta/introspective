//
//  HeartRate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Attributes
import Common
import DependencyInjection

public final class HeartRate: HealthKitQuantitySample {
	private typealias Me = HeartRate

	// MARK: - HealthKit Stuff

	public static let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
	public static let sampleType: HKSampleType = quantityType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])
	public static var unit: HKUnit = HKUnit(from: "count/min")
	public final var unitString: String {
		Me.unit.unitString
	}

	public static func initUnits() {
		unit = DependencyInjector.get(HealthKitUtil.self).preferredUnitFor(.heartRate) ?? HKUnit(from: "count/min")
	}

	// MARK: - Display Information

	public static let name: String = "Heart Rate"
	public final let attributedName: String = Me.name
	public static let description: String = "A measurement of how fast your heart is beating (in beats per minute)."
	public final let description: String = Me.description

	// MARK: - Attributes

	public static let heartRate = DoubleAttribute(
		name: "Heart rate",
		pluralName: "Heart rates",
		variableName: HKPredicateKeyPathQuantity
	)
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitTimestamp, heartRate]
	public static let defaultDependentAttribute: Attribute = heartRate
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitTimestamp
	public final var attributes: [Attribute] { Me.attributes }

	// MARK: - Instance Variables

	public final var timestamp: Date
	public final var heartRate: Double

	// MARK: - Initializers

	public init(_ value: Double = Double(), _ timestamp: Date = Date()) {
		heartRate = value
		self.timestamp = timestamp
	}

	public required init(_ sample: HKQuantitySample) {
		heartRate = sample.quantity.doubleValue(for: Me.unit)
		timestamp = sample.startDate
		DependencyInjector.get(HealthKitUtil.self).setTimeZoneIfApplicable(for: &timestamp, from: sample)
	}

	// MARK: - HealthKitSample Functions

	public func hkSample() -> HKSample {
		let quantity = HKQuantity(unit: Me.unit, doubleValue: quantityValue())
		return HKQuantitySample(
			type: Me.quantityType,
			quantity: quantity,
			start: timestamp,
			end: timestamp,
			metadata: [HKMetadataKeyTimeZone: TimeZone.autoupdatingCurrent.identifier]
		)
	}

	// MARK: - HealthKitQuantitySample Functions

	public func quantityValue() -> Double {
		heartRate
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		[.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.heartRate) {
			return heartRate
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			return timestamp
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.heartRate) {
			guard let castedValue = value as? Double else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			heartRate = castedValue
			return
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			guard let castedValue = value as? Date else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			timestamp = castedValue
			return
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}
}

// MARK: - Equatable

extension HeartRate: Equatable {
	public static func == (lhs: HeartRate, rhs: HeartRate) -> Bool {
		lhs.equalTo(rhs)
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
		timestamp == other.timestamp && heartRate == other.heartRate
	}
}

// MARK: - Debug

extension HeartRate: CustomDebugStringConvertible {
	public final var debugDescription: String {
		"HeartRate of \(heartRate) at " + DependencyInjector.get(CalendarUtil.self).string(for: timestamp)
	}
}
