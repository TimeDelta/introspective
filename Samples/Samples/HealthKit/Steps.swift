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
	public static let durationAttribute = DurationAttribute()
	public static let attributes: [Attribute] = [
		durationAttribute,
		stepCount,
		CommonSampleAttributes.healthKitStartDate,
		CommonSampleAttributes.healthKitEndDate,
	]
	public static var dateAttributes: [DateType: DateAttribute] = [
		.start: CommonSampleAttributes.healthKitStartDate,
		.end: CommonSampleAttributes.healthKitEndDate,
	]
	public static let defaultDependentAttribute: Attribute = stepCount
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitStartDate
	public final var attributes: [Attribute] { Me.attributes }

	// MARK: - Instance Variables

	public final var start: Date
	public final var end: Date
	public final var steps: Double

	// MARK: - Initializers

	public init(_ value: Double = Double(), _ start: Date = Date(), _ end: Date = Date()) {
		steps = value
		self.start = start
		self.end = end
	}

	public required init(_ sample: HKQuantitySample) {
		steps = sample.quantity.doubleValue(for: Me.unit)
		start = sample.startDate
		end = sample.endDate
		injected(HealthKitUtil.self).setTimeZoneIfApplicable(for: &start, from: sample)
		injected(HealthKitUtil.self).setTimeZoneIfApplicable(for: &end, from: sample)
	}

	// MARK: - HealthKitSample Functions

	public func hkSample() -> HKSample {
		let quantity = HKQuantity(unit: Me.unit, doubleValue: quantityValue())
		return HKQuantitySample(
			type: Me.quantityType,
			quantity: quantity,
			start: start,
			end: end,
			metadata: [HKMetadataKeyTimeZone: TimeZone.autoupdatingCurrent.identifier]
		)
	}

	// MARK: - HealthKitQuantitySample Functions

	public func quantityValue() -> Double {
		steps
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		[
			.start: start,
			.end: end,
		]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.stepCount) {
			return steps
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitStartDate) {
			return start
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitEndDate) {
			return end
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
		if attribute.equalTo(CommonSampleAttributes.healthKitStartDate) {
			guard let castedValue = value as? Date else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			start = castedValue
			return
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitEndDate) {
			guard let castedValue = value as? Date else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			end = castedValue
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
		start == other.start && end == other.end && steps == other.steps
	}
}

// MARK: - Debug

extension Steps: CustomDebugStringConvertible {
	public final var debugDescription: String {
		"\(steps) steps from " + start.debugDescription + " to " + end.debugDescription
	}
}
