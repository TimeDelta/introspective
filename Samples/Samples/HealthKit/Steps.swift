//
//  Steps.swift
//  Samples
//
//  Created by Bryan Nova on 11/6/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Attributes
import Common
import DependencyInjection

public final class Steps: HealthKitQuantitySample {
	private typealias Me = Steps

	// MARK: - HealthKit Stuff

	public static let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
	public static let sampleType: HKSampleType = quantityType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])
	public static var unit: HKUnit = HKUnit(from: "count")
	public final var unitString: String {
		Me.unit.unitString
	}

	public static func initUnits() {
		unit = injected(HealthKitUtil.self).preferredUnitFor(.stepCount) ?? HKUnit(from: "count")
	}

	// MARK: - Display Information

	public static let name: String = "Steps"
	public final let attributedName: String = Me.name
	public static let description: String = "Number of steps taken"
	public final let description: String = Me.description

	// MARK: - Attributes

	public static let stepCount = DoubleAttribute(
		name: "Step Count",
		pluralName: "Step Counts",
		variableName: HKPredicateKeyPathQuantity
	)
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitTimestamp, stepCount]
	public static var dateAttributes: [DateType: DateAttribute] = [
		.start: CommonSampleAttributes.healthKitTimestamp,
	]
	public static let defaultDependentAttribute: Attribute = stepCount
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitTimestamp
	public final var attributes: [Attribute] { Me.attributes }

	// MARK: - Instance Variables

	public final var timestamp: Date
	public final var steps: Double

	// MARK: - Initializers

	public init(_ value: Double = Double(), _ timestamp: Date = Date()) {
		steps = value
		self.timestamp = timestamp
	}

	public required init(_ sample: HKQuantitySample) {
		steps = sample.quantity.doubleValue(for: Me.unit)
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
		steps
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		[.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.stepCount) {
			return steps
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			return timestamp
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.stepCount) {
			guard let castedValue = value as? Double else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			steps = castedValue
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

extension Steps: Equatable {
	public static func == (lhs: Steps, rhs: Steps) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is Steps) { return false }
		let other = otherAttributed as! Steps
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is HeartRate) { return false }
		let other = otherSample as! HeartRate
		return equalTo(other)
	}

	public final func equalTo(_ other: Steps) -> Bool {
		timestamp == other.timestamp && steps == other.steps
	}
}

// MARK: - Debug

extension Steps: CustomDebugStringConvertible {
	public final var debugDescription: String {
		"\(steps) steps at " + timestamp.debugDescription
	}
}
