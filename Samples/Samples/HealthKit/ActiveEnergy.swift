//
//  ActiveEnergy.swift
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

public final class ActiveEnergy: HealthKitQuantitySample {
	private typealias Me = ActiveEnergy

	// MARK: - HealthKit Stuff

	public static let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
	public static let sampleType: HKSampleType = quantityType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set()
	public static let unit: HKUnit = HKUnit.kilocalorie()
	public final var unitString: String {
		Me.unit.unitString
	}

	public static func initUnits() {}

	// MARK: - Display Information

	public static let name: String = "Active Energy"
	public final let attributedName: String = Me.name
	public static let description: String = "Active energy burned in kilocalories"
	public final let description: String = Me.description

	// MARK: - Attributes

	public static let energyBurned = DoubleAttribute(
		id: 0,
		name: "Active Energy (kcal)",
		pluralName: "Active Energy (kcal)",
		variableName: HKPredicateKeyPathQuantity
	)
	public static let durationAttribute = DurationAttribute(id: 1)
	public static let attributes: [Attribute] = [
		durationAttribute,
		energyBurned,
		CommonSampleAttributes.healthKitStartDate,
		CommonSampleAttributes.healthKitEndDate,
	]
	public static var dateAttributes: [DateType: DateAttribute] = [
		.start: CommonSampleAttributes.healthKitStartDate,
		.end: CommonSampleAttributes.healthKitEndDate,
	]
	public static let defaultDependentAttribute: Attribute = energyBurned
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitStartDate
	public final var attributes: [Attribute] { Me.attributes }

	// MARK: - Instance Variables

	public final var start: Date
	public final var end: Date
	public final var energy: Double

	// MARK: - Initializers

	public init(_ value: Double = Double(), _ start: Date = Date(), _ end: Date = Date()) {
		energy = value
		self.start = start
		self.end = end
	}

	public required init(_ sample: HKQuantitySample) {
		energy = sample.quantity.doubleValue(for: Me.unit)
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
		energy
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
		if attribute.equalTo(Me.energyBurned) {
			return energy
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
		if attribute.equalTo(Me.energyBurned) {
			guard let castedValue = value as? Double else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			energy = castedValue
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

extension ActiveEnergy: Equatable {
	public static func == (lhs: ActiveEnergy, rhs: ActiveEnergy) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is ActiveEnergy) { return false }
		let other = otherAttributed as! ActiveEnergy
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		guard let other = otherSample as? ActiveEnergy else { return false }
		return equalTo(other)
	}

	public final func equalTo(_ other: ActiveEnergy) -> Bool {
		start == other.start && end == other.end && energy == other.energy
	}
}

// MARK: - Debug

extension ActiveEnergy: CustomDebugStringConvertible {
	public final var debugDescription: String {
		"\(energy) energy from " + start.debugDescription + " to " + end.debugDescription
	}
}
