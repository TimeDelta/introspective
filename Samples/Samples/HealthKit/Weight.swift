//
//  Weight.swift
//  Introspective
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Attributes
import Common
import DependencyInjection

public final class Weight: HealthKitQuantitySample {
	private typealias Me = Weight

	// MARK: - HealthKit Stuff

	public static let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
	public static let sampleType: HKSampleType = quantityType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])
	public static var unit: HKUnit = HKUnit(from: .pound)
	public final var unitString: String {
		Me.unit.unitString
	}

	public static func initUnits() {
		unit = injected(HealthKitUtil.self).preferredUnitFor(.bodyMass) ?? HKUnit(from: .pound)
	}

	// MARK: - Display Information

	public static let name: String = "Weight"
	public static let description: String = "A measurement of body mass."

	// MARK: - Attributes

	public static let weight = DoubleAttribute(
		name: "Weight",
		pluralName: "Weights",
		variableName: HKPredicateKeyPathQuantity
	)
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitTimestamp, weight]
	public static let defaultDependentAttribute: Attribute = weight
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitTimestamp
	public final var attributes: [Attribute] { Me.attributes }
	public static var dateAttributes: [DateType: DateAttribute] = [
		.start: CommonSampleAttributes.healthKitTimestamp,
	]

	// MARK: - Instance Variables

	public final var attributedName: String = Me.name
	public final var description: String = Me.description
	public final var timestamp: Date
	public final var weight: Double

	// MARK: - Initializers

	public init(_ value: Double = Double(), _ timestamp: Date = Date()) {
		weight = value
		self.timestamp = timestamp
	}

	public required init(_ sample: HKQuantitySample) {
		weight = sample.quantity.doubleValue(for: Me.unit)
		timestamp = sample.startDate
		injected(HealthKitUtil.self).setTimeZoneIfApplicable(for: &timestamp, from: sample)
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
		weight
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		[.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.weight) {
			return weight
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			return timestamp
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.weight) {
			guard let castedValue = value as? Double else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			weight = castedValue
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

extension Weight: Equatable {
	public static func == (lhs: Weight, rhs: Weight) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is Weight) { return false }
		let other = otherAttributed as! Weight
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is Weight) { return false }
		let other = otherSample as! Weight
		return equalTo(other)
	}

	public final func equalTo(_ other: Weight) -> Bool {
		timestamp == other.timestamp && weight == other.weight
	}
}

// MARK: - Debug

extension Weight: CustomDebugStringConvertible {
	public final var debugDescription: String {
		"Weight of \(weight) at " + timestamp.debugDescription
	}
}
