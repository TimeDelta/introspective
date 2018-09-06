//
//  Weight.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public final class Weight: HealthKitQuantitySample {

	private typealias Me = Weight

	// MARK: - HealthKit Stuff

	public static let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
	public static let sampleType: HKSampleType = quantityType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])
	public static let unit: HKUnit = HKUnit(from: .pound)
	public final let unitString: String = Me.unit.unitString

	// MARK: - Display Information

	public static let name: String = "Weight"
	public static let description: String = "A measurement of body mass."

	// MARK: - Attributes

	public static let weight = DoubleAttribute(name: "Weight", pluralName: "Weights", variableName: HKPredicateKeyPathQuantity)
	public static let timestamp = DateTimeAttribute(name: "Timestamp", pluralName: "Timestamps", variableName: HKPredicateKeyPathStartDate)
	public static let attributes: [Attribute] = [timestamp, weight]
	public static let defaultDependentAttribute: Attribute = weight
	public static let defaultIndependentAttribute: Attribute = timestamp
	public final var attributes: [Attribute] { return Me.attributes }

	// MARK: - Instance Member Variables

	public final var name: String = Me.name
	public final var description: String = Me.description
	public final var timestamp: Date
	public final var weight: Double

	// MARK: - Initializers

	public init() {
		weight = Double()
		timestamp = Date()
	}

	public init(_ timestamp: Date) {
		weight = Double()
		self.timestamp = timestamp
	}

	public init(_ value: Double) {
		weight = value
		timestamp = Date()
	}

	public init(_ value: Double, _ timestamp: Date) {
		weight = value
		self.timestamp = timestamp
	}

	public required init(_ sample: HKQuantitySample) {
		weight = sample.quantity.doubleValue(for: Me.unit)
		timestamp = sample.startDate
	}

	// MARK: - HealthKitSample Functions

	public func hkSample() -> HKSample {
		let quantity = HKQuantity(unit: Me.unit, doubleValue: quantityValue())
		return HKQuantitySample(type: Me.quantityType, quantity: quantity, start: timestamp, end: timestamp)
	}

	// MARK: - HealthKitQuantitySample Functions

	public func quantityValue() -> Double {
		return weight
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(Me.weight) {
			return weight
		}
		if attribute.equalTo(Me.timestamp) {
			return timestamp
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any) throws {
		if attribute.equalTo(Me.weight) {
			guard let castedValue = value as? Double else { throw AttributeError.typeMismatch }
			weight = castedValue
			return
		}
		if attribute.equalTo(Me.timestamp) {
			guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
			timestamp = castedValue
			return
		}
		throw AttributeError.unknownAttribute
	}
}

// MARK: - Equatable

extension Weight: Equatable {

	public static func ==(lhs: Weight, rhs: Weight) -> Bool {
		return lhs.equalTo(rhs)
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
		return timestamp == other.timestamp && weight == other.weight
	}
}

// MARK: - Debug

extension Weight: CustomDebugStringConvertible {

	public final var debugDescription: String {
		return "Weight of \(weight) at " + DependencyInjector.util.calendarUtil.string(for: timestamp)
	}
}
