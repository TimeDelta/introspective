//
//  BodyMassIndex.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Attributes
import Common
import DependencyInjection

public final class BodyMassIndex: HealthKitQuantitySample {
	private typealias Me = BodyMassIndex

	// MARK: - HealthKit Stuff

	public static let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!
	public static let sampleType: HKSampleType = quantityType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])
	public static var unit: HKUnit = HKUnit.count()
	public final var unitString: String {
		Me.unit.unitString
	}

	public static func initUnits() {
		unit = injected(HealthKitUtil.self).preferredUnitFor(.bodyMassIndex) ?? HKUnit.count()
	}

	// MARK: - Display Information

	public static let name: String = "Body Mass Index"
	public static let description: String =
		"Body Mass Index (BMI) is an indicator of your body fat. It's calculated from your height and weight, and can tell you whether you are underweight, normal, overweight, or obese. It can also help you gauge your risk for diseases that can occur with more body fat."

	// MARK: - Attributes

	public static let bmi = DoubleAttribute(
		id: 0,
		name: "BMI",
		pluralName: "BMIs",
		variableName: HKPredicateKeyPathQuantity
	)
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitTimestamp, bmi]
	public static let defaultDependentAttribute: Attribute = bmi
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitTimestamp
	public final var attributes: [Attribute] { Me.attributes }
	public static var dateAttributes: [DateType: DateAttribute] = [
		.start: CommonSampleAttributes.healthKitTimestamp,
	]

	// MARK: - Instance Variables

	public final var attributedName: String = Me.name
	public final var description: String = Me.description
	public final var timestamp: Date
	public final var bmi: Double

	// MARK: - Initializers

	public init(_ value: Double = Double(), _ timestamp: Date = Date()) {
		bmi = value
		self.timestamp = timestamp
	}

	public required init(_ sample: HKQuantitySample) {
		bmi = sample.quantity.doubleValue(for: Me.unit)
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
		bmi
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		[.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.bmi) {
			return bmi
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			return timestamp
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.bmi) {
			guard let castedValue = value as? Double else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			bmi = castedValue
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

extension BodyMassIndex: Equatable {
	public static func == (lhs: BodyMassIndex, rhs: BodyMassIndex) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is BodyMassIndex) { return false }
		let other = otherAttributed as! BodyMassIndex
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is BodyMassIndex) { return false }
		let other = otherSample as! BodyMassIndex
		return equalTo(other)
	}

	public final func equalTo(_ other: BodyMassIndex) -> Bool {
		timestamp == other.timestamp && bmi == other.bmi
	}
}

// MARK: - Debug

extension BodyMassIndex: CustomDebugStringConvertible {
	public final var debugDescription: String {
		"BodyMassIndex of \(bmi) at " + timestamp.debugDescription
	}
}
