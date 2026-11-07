//
//  RestingHeartRate.swift
//  Introspective
//
//  Created by Bryan Nova on 10/5/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Attributes
import Common
import DependencyInjection

public class RestingHeartRate: HealthKitQuantitySample {
	private typealias Me = RestingHeartRate

	// MARK: - HealthKit Stuff

	public static let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
	public static let sampleType: HKSampleType = quantityType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])
	public static var unit: HKUnit = HKUnit(from: "count/min")
	public final var unitString: String {
		valueUnit.unitString
	}

	public static func initUnits() {
		unit = injected(HealthKitUtil.self)
			.preferredUnitFor(.restingHeartRate) ?? HKUnit(from: "count/min")
	}

	// MARK: - Display Information

	public static let name: String = "Resting Heart Rate"
	public static let description: String = "A measurement of how fast your heart is beating (in beats per minute)."

	// MARK: - Attributes

	public static let restingHeartRate = DoubleAttribute(
		id: 0,
		name: "Resting heart rate",
		pluralName: "Resting heart rates",
		variableName: HKPredicateKeyPathQuantity
	)
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitTimestamp, restingHeartRate]
	public static let defaultDependentAttribute: Attribute = restingHeartRate
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitTimestamp
	public final var attributes: [Attribute] { Me.attributes }
	public static var dateAttributes: [DateType: DateAttribute] = [
		.start: CommonSampleAttributes.healthKitTimestamp,
	]

	// MARK: - Instance Variables

	public private(set) var sourceIdentifier: UUID? = nil
	public private(set) var originalHealthSample: HKSample? = nil
	private var valueUnit: HKUnit = Me.unit

	public final var attributedName: String = Me.name
	public final var description: String = Me.description
	public final var timestamp: Date
	public final var restingHeartRate: Double

	// MARK: - Initializers

	public init(_ value: Double = Double(), _ timestamp: Date = Date()) {
		restingHeartRate = value
		self.timestamp = timestamp
	}

	public required convenience init(_ sample: HKQuantitySample) {
		self.init(sample, unit: Me.unit)
	}

	/// Use a captured read unit instead of mutable global unit preferences.
	public required init(_ sample: HKQuantitySample, unit: HKUnit) {
		sourceIdentifier = sample.uuid
		originalHealthSample = sample
		valueUnit = unit
		restingHeartRate = sample.quantity.doubleValue(for: unit)
		timestamp = sample.startDate
		injected(HealthKitUtil.self).setTimeZoneIfApplicable(for: &timestamp, from: sample)
	}

	// MARK: - HealthKitSample Functions

	public func hkSample() -> HKSample {
		let quantity = HKQuantity(unit: valueUnit, doubleValue: quantityValue())
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
		restingHeartRate
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		[.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.restingHeartRate) {
			return restingHeartRate
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			return timestamp
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.restingHeartRate) {
			guard let castedValue = value as? Double else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			restingHeartRate = castedValue
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

extension RestingHeartRate: Equatable {
	public static func == (lhs: RestingHeartRate, rhs: RestingHeartRate) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is RestingHeartRate) { return false }
		let other = otherAttributed as! RestingHeartRate
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is RestingHeartRate) { return false }
		let other = otherSample as! RestingHeartRate
		return equalTo(other)
	}

	public final func equalTo(_ other: RestingHeartRate) -> Bool {
		timestamp == other.timestamp && restingHeartRate == other.restingHeartRate
	}
}

// MARK: - Debug

extension RestingHeartRate: CustomDebugStringConvertible {
	public final var debugDescription: String {
		"RestingHeartRate of \(restingHeartRate) at " + timestamp.debugDescription
	}
}
