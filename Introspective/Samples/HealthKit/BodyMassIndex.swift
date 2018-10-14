//
//  BodyMassIndex.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public final class BodyMassIndex: HealthKitQuantitySample {

	private typealias Me = BodyMassIndex

	// MARK: - HealthKit Stuff

	public static let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!
	public static let sampleType: HKSampleType = quantityType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])
	public static let unit: HKUnit = HKUnit.count()
	public final let unitString: String = ""

	// MARK: - Display Information

	public static let name: String = "Body Mass Index"
	public static let description: String = "Body Mass Index (BMI) is an indicator of your body fat. It's calculated from your height and weight, and can tell you whether you are underweight, normal, overweight, or obese. It can also help you gauge your risk for diseases that can occur with more body fat."

	// MARK: - Attributes

	public static let bmi = DoubleAttribute(name: "BMI", pluralName: "BMIs", variableName: HKPredicateKeyPathQuantity)
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitTimestamp, bmi]
	public static let defaultDependentAttribute: Attribute = bmi
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitTimestamp
	public final var attributes: [Attribute] { return Me.attributes }

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
	}

	// MARK: - HealthKitSample Functions

	public func hkSample() -> HKSample {
		let quantity = HKQuantity(unit: Me.unit, doubleValue: quantityValue())
		return HKQuantitySample(type: Me.quantityType, quantity: quantity, start: timestamp, end: timestamp)
	}

	// MARK: - HealthKitQuantitySample Functions

	public func quantityValue() -> Double {
		return bmi
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.bmi) {
			return bmi
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			return timestamp
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.bmi) {
			guard let castedValue = value as? Double else { throw AttributeError.typeMismatch }
			bmi = castedValue
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

extension BodyMassIndex: Equatable {

	public static func ==(lhs: BodyMassIndex, rhs: BodyMassIndex) -> Bool {
		return lhs.equalTo(rhs)
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
		return timestamp == other.timestamp && bmi == other.bmi
	}
}

// MARK: - Debug

extension BodyMassIndex: CustomDebugStringConvertible {

	public final var debugDescription: String {
		return "BodyMassIndex of \(bmi) at " + DependencyInjector.util.calendarUtil.string(for: timestamp)
	}
}
