//
//  LeanBodyMass.swift
//  Introspective
//
//  Created by Bryan Nova on 9/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public final class LeanBodyMass: HealthKitQuantitySample {

	private typealias Me = LeanBodyMass

	// MARK: - HealthKit Stuff

	public static let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .leanBodyMass)!
	public static let sampleType: HKSampleType = quantityType
	public static var readPermissions: Set<HKObjectType> = Set([sampleType])
	public static var writePermissions: Set<HKSampleType> = Set([sampleType])
	public static let unit: HKUnit = HKUnit(from: .pound)
	public final let unitString: String = Me.unit.unitString

	// MARK: - Display Information

	public static let name: String = "Lean Body Mass"
	public static let description: String = "Lean body mass is the weight of your body minus your body fat"

	// MARK: - Attributes

	public static let leanBodyMass = DoubleAttribute(name: "Lean body mass", pluralName: "Lean body masses", variableName: HKPredicateKeyPathQuantity)
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitTimestamp, leanBodyMass]
	public static let defaultDependentAttribute: Attribute = leanBodyMass
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitTimestamp
	public final var attributes: [Attribute] { return Me.attributes }

	// MARK: - Instance Variables

	public final var attributedName: String = Me.name
	public final var description: String = Me.description
	public final var timestamp: Date
	public final var leanBodyMass: Double

	// MARK: - Initializers

	public init(_ value: Double = Double(), _ timestamp: Date = Date()) {
		leanBodyMass = value
		self.timestamp = timestamp
	}

	public required init(_ sample: HKQuantitySample) {
		leanBodyMass = sample.quantity.doubleValue(for: Me.unit)
		timestamp = sample.startDate
	}

	// MARK: - HealthKitSample Functions

	public func hkSample() -> HKSample {
		let quantity = HKQuantity(unit: Me.unit, doubleValue: quantityValue())
		return HKQuantitySample(type: Me.quantityType, quantity: quantity, start: timestamp, end: timestamp)
	}

	// MARK: - HealthKitQuantitySample Functions

	public func quantityValue() -> Double {
		return leanBodyMass
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.leanBodyMass) {
			return leanBodyMass
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			return timestamp
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.leanBodyMass) {
			guard let castedValue = value as? Double else { throw AttributeError.typeMismatch }
			leanBodyMass = castedValue
			return
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
			timestamp = castedValue
			return
		}
		throw AttributeError.unknownAttribute
	}
}

// MARK: - Equatable

extension LeanBodyMass: Equatable {

	public static func ==(lhs: LeanBodyMass, rhs: LeanBodyMass) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is LeanBodyMass) { return false }
		let other = otherAttributed as! LeanBodyMass
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is LeanBodyMass) { return false }
		let other = otherSample as! LeanBodyMass
		return equalTo(other)
	}

	public final func equalTo(_ other: LeanBodyMass) -> Bool {
		return timestamp == other.timestamp && leanBodyMass == other.leanBodyMass
	}
}

// MARK: - Debug

extension LeanBodyMass: CustomDebugStringConvertible {

	public final var debugDescription: String {
		return "LeanBodyMass of \(leanBodyMass) at " + DependencyInjector.util.calendarUtil.string(for: timestamp)
	}
}
