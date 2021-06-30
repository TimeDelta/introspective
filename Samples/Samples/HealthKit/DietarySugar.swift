//
//  DietarySugar.swift
//  Samples
//
//  Created by Bryan Nova on 6/18/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Attributes
import Common
import DependencyInjection

public final class DietarySugar: HealthKitQuantitySample {
	private typealias Me = DietarySugar

	// MARK: - HealthKit Stuff

	public static let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .dietarySugar)!
	public static let sampleType: HKSampleType = quantityType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])
	public static var unit: HKUnit = HKUnit(from: .gram)
	public final var unitString: String {
		Me.unit.unitString
	}

	public static func initUnits() {
		unit = injected(HealthKitUtil.self).preferredUnitFor(.dietarySugar) ?? HKUnit(from: .gram)
	}

	// MARK: - Display Information

	public static let name: String = "Dietary Sugar"
	public final let attributedName: String = Me.name
	public static let description: String = "How much sugar you eat."
	public final let description: String = Me.description

	// MARK: - Attributes

	public static let dietarySugar = DoubleAttribute(
		id: 0,
		name: "Dietary sugar",
		pluralName: "Dietary sugar",
		variableName: HKPredicateKeyPathQuantity
	)
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitTimestamp, dietarySugar]
	public static var dateAttributes: [DateType: DateAttribute] = [
		.start: CommonSampleAttributes.healthKitTimestamp,
	]
	public static let defaultDependentAttribute: Attribute = dietarySugar
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitTimestamp
	public final var attributes: [Attribute] { Me.attributes }

	// MARK: - Instance Variables

	public final var timestamp: Date
	public final var dietarySugar: Double

	// MARK: - Initializers

	public init(_ value: Double = Double(), _ timestamp: Date = Date()) {
		dietarySugar = value
		self.timestamp = timestamp
	}

	public required init(_ sample: HKQuantitySample) {
		dietarySugar = sample.quantity.doubleValue(for: Me.unit)
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
		dietarySugar
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		[.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.dietarySugar) {
			return dietarySugar
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			return timestamp
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.dietarySugar) {
			guard let castedValue = value as? Double else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			dietarySugar = castedValue
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

extension DietarySugar: Equatable {
	public static func == (lhs: DietarySugar, rhs: DietarySugar) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is DietarySugar) { return false }
		let other = otherAttributed as! DietarySugar
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is DietarySugar) { return false }
		let other = otherSample as! DietarySugar
		return equalTo(other)
	}

	public final func equalTo(_ other: DietarySugar) -> Bool {
		timestamp == other.timestamp && dietarySugar == other.dietarySugar
	}
}

// MARK: - Debug

extension DietarySugar: CustomDebugStringConvertible {
	public final var debugDescription: String {
		"DietarySugar of \(dietarySugar) at " + timestamp.debugDescription
	}
}
