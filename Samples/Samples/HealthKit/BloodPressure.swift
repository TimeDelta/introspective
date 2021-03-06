//
//  BloodPressure.swift
//  Introspective
//
//  Created by Bryan Nova on 9/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Attributes
import Common
import DependencyInjection

public final class BloodPressure: HealthKitCorrelationSample {
	private typealias Me = BloodPressure

	// MARK: - HealthKit Stuff

	public static let systolicQuantityType: HKQuantityType = HKQuantityType
		.quantityType(forIdentifier: .bloodPressureSystolic)!
	public static let diastolicQuantityType: HKQuantityType = HKQuantityType
		.quantityType(forIdentifier: .bloodPressureDiastolic)!
	public static let correlationType: HKCorrelationType = HKCorrelationType
		.correlationType(forIdentifier: .bloodPressure)!
	public static let sampleType: HKSampleType = correlationType
	public static var readPermissions: Set<HKObjectType> = Set([systolicQuantityType, diastolicQuantityType])
	public static var writePermissions: Set<HKSampleType> = Set([systolicQuantityType, diastolicQuantityType])
	public static var systolicUnit: HKUnit = HKUnit.millimeterOfMercury()
	public static var diastolicUnit: HKUnit = HKUnit.millimeterOfMercury()

	public static func initUnits() {
		systolicUnit = injected(HealthKitUtil.self).preferredUnitFor(.bloodPressureSystolic) ?? HKUnit
			.millimeterOfMercury()
		diastolicUnit = injected(HealthKitUtil.self).preferredUnitFor(.bloodPressureDiastolic) ?? HKUnit
			.millimeterOfMercury()
	}

	// MARK: - Display Information

	public static let name: String = "Blood Pressure"
	public static let description: String =
		"Blood pressure is the force of blood pushing against the walls of the arteries as your heart pumps blood. It includes two measurements. \"Systolic\" is your blood pressure when your heart beats while pumping blood. \"Diastolic\" is your blood pressure when the heart is at rest between beats. You usually see blood pressure numbers written with the systolic number above or before the diastolic number."

	// MARK: - Attributes

	public static let systolic = DoubleAttribute(
		name: "Systolic blood pressure",
		pluralName: "Systolic blood pressures",
		variableName: HKPredicateKeyPathQuantity
	)
	public static let diastolic = DoubleAttribute(
		name: "Diastolic blood pressure",
		pluralName: "Diastolic blood pressures",
		variableName: HKPredicateKeyPathQuantity
	)
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitTimestamp, systolic, diastolic]
	public static let defaultDependentAttribute: Attribute = diastolic
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitTimestamp
	public final var attributes: [Attribute] { Me.attributes }
	public static var dateAttributes: [DateType: DateAttribute] = [
		.start: CommonSampleAttributes.healthKitTimestamp,
	]

	// MARK: - Instance Variables

	public final var attributedName: String = Me.name
	public final var description: String = Me.description
	public final var timestamp: Date
	public final var systolic: Double
	public final var diastolic: Double

	// MARK: - Initializers

	public init(systolic: Double = Double(), diastolic: Double = Double(), _ timestamp: Date = Date()) {
		self.systolic = systolic
		self.diastolic = diastolic
		self.timestamp = timestamp
	}

	public required init(_ sample: HKCorrelation) {
		let systolics = sample.objects(for: Me.systolicQuantityType)
		let systolicSample = systolics.first! as! HKQuantitySample
		systolic = systolicSample.quantity.doubleValue(for: Me.systolicUnit)

		let diastolics = sample.objects(for: Me.diastolicQuantityType)
		let diastolicSample = diastolics.first! as! HKQuantitySample
		diastolic = diastolicSample.quantity.doubleValue(for: Me.diastolicUnit)

		let systolicStart = systolicSample.startDate
		let diastolicStart = diastolicSample.startDate
		if diastolicStart < systolicStart {
			timestamp = diastolicStart
			injected(HealthKitUtil.self).setTimeZoneIfApplicable(for: &timestamp, from: diastolicSample)
		} else {
			timestamp = systolicStart
			injected(HealthKitUtil.self).setTimeZoneIfApplicable(for: &timestamp, from: systolicSample)
		}
	}

	// MARK: - HealthKitSample Functions

	public func hkSample() -> HKSample {
		let systolicPressure = HKQuantity(unit: Me.systolicUnit, doubleValue: systolic)
		let systolicSample = HKQuantitySample(
			type: Me.systolicQuantityType,
			quantity: systolicPressure,
			start: timestamp,
			end: timestamp,
			metadata: [HKMetadataKeyTimeZone: TimeZone.autoupdatingCurrent.identifier]
		)
		let diastolicPressure = HKQuantity(unit: Me.diastolicUnit, doubleValue: diastolic)
		let diastolicSample = HKQuantitySample(
			type: Me.diastolicQuantityType,
			quantity: diastolicPressure,
			start: timestamp,
			end: timestamp,
			metadata: [HKMetadataKeyTimeZone: TimeZone.autoupdatingCurrent.identifier]
		)
		return HKCorrelation(
			type: Me.correlationType,
			start: timestamp,
			end: timestamp,
			objects: Set([systolicSample, diastolicSample])
		)
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		[.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.systolic) {
			return systolic
		}
		if attribute.equalTo(Me.diastolic) {
			return diastolic
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			return timestamp
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.systolic) {
			guard let castedValue = value as? Double else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			systolic = castedValue
			return
		}
		if attribute.equalTo(Me.diastolic) {
			guard let castedValue = value as? Double else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			diastolic = castedValue
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

extension BloodPressure: Equatable {
	public static func == (lhs: BloodPressure, rhs: BloodPressure) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is BloodPressure) { return false }
		let other = otherAttributed as! BloodPressure
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is BloodPressure) { return false }
		let other = otherSample as! BloodPressure
		return equalTo(other)
	}

	public final func equalTo(_ other: BloodPressure) -> Bool {
		timestamp == other.timestamp && diastolic == other.diastolic && systolic == other.systolic
	}
}

// MARK: - Debug

extension BloodPressure: CustomDebugStringConvertible {
	public final var debugDescription: String {
		"BloodPressure of \(diastolic) at " + timestamp.debugDescription
	}
}
