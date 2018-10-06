//
//  RestingHeartRate.swift
//  Introspective
//
//  Created by Bryan Nova on 10/5/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class RestingHeartRate: HealthKitQuantitySample {

	private typealias Me = RestingHeartRate

	// MARK: - HealthKit Stuff

	public static let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
	public static let sampleType: HKSampleType = quantityType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])
	public static let unit: HKUnit = HKUnit(from: "count/min")
	public final let unitString: String = "bpm"

	// MARK: - Display Information

	public static let name: String = "Resting Heart Rate"
	public static let description: String = "A measurement of how fast your heart is beating (in beats per minute)."

	// MARK: - Attributes

	public static let restingHeartRate = DoubleAttribute(name: "Resting heart rate", pluralName: "Resting heart rates", variableName: HKPredicateKeyPathQuantity)
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitTimestamp, restingHeartRate]
	public static let defaultDependentAttribute: Attribute = restingHeartRate
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitTimestamp
	public final var attributes: [Attribute] { return Me.attributes }

	// MARK: - Instance Member Variables

	public final var name: String = Me.name
	public final var description: String = Me.description
	public final var timestamp: Date
	public final var restingHeartRate: Double

	// MARK: - Initializers

	public init(_ value: Double = Double(), _ timestamp: Date = Date()) {
		restingHeartRate = value
		self.timestamp = timestamp
	}

	public required init(_ sample: HKQuantitySample) {
		restingHeartRate = sample.quantity.doubleValue(for: Me.unit)
		timestamp = sample.startDate
	}

	// MARK: - HealthKitSample Functions

	public func hkSample() -> HKSample {
		let quantity = HKQuantity(unit: Me.unit, doubleValue: quantityValue())
		return HKQuantitySample(type: Me.quantityType, quantity: quantity, start: timestamp, end: timestamp)
	}

	// MARK: - HealthKitQuantitySample Functions

	public func quantityValue() -> Double {
		return restingHeartRate
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(Me.restingHeartRate) {
			return restingHeartRate
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			return timestamp
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any) throws {
		if attribute.equalTo(Me.restingHeartRate) {
			guard let castedValue = value as? Double else { throw AttributeError.typeMismatch }
			restingHeartRate = castedValue
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

extension RestingHeartRate: Equatable {

	public static func ==(lhs: RestingHeartRate, rhs: RestingHeartRate) -> Bool {
		return lhs.equalTo(rhs)
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
		return timestamp == other.timestamp && restingHeartRate == other.restingHeartRate
	}
}

// MARK: - Debug

extension RestingHeartRate: CustomDebugStringConvertible {

	public final var debugDescription: String {
		return "RestingHeartRate of \(restingHeartRate) at " + DependencyInjector.util.calendarUtil.string(for: timestamp)
	}
}
