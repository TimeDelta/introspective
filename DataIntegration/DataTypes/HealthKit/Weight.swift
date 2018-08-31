//
//  Weight.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public final class Weight: HealthKitQuantitySample, Equatable, CustomDebugStringConvertible {

	public static func ==(lhs: Weight, rhs: Weight) -> Bool {
		return lhs.equalTo(rhs)
	}

	private typealias Me = Weight

	public static let pounds: HKUnit = HKUnit(from: .pound)
	public static let kilograms: HKUnit = HKUnit(from: .kilogram)

	public static let weight = DoubleAttribute(name: "weight", pluralName: "weights", variableName: HKPredicateKeyPathQuantity)
	public static let timestamp = DateTimeAttribute(name: "timestamp", pluralName: "timestamps", variableName: HKPredicateKeyPathStartDate)
	public static let attributes: [Attribute] = [timestamp, weight]

	public final var debugDescription: String {
		return "Weight of \(weight) at " + DependencyInjector.util.calendarUtil.string(for: timestamp)
	}

	public final var name: String { return "Weight" }
	public final var description: String { return "A measurement of body mass." }
	public final var dataType: DataTypes { return .weight }
	public final var attributes: [Attribute] { return Me.attributes }
	public final var timestamp: Date

	public final var weight: Double

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

	public init(_ sample: HKQuantitySample) {
		weight = sample.quantity.doubleValue(for: Me.pounds)
		timestamp = sample.startDate
	}

	public final func quantityUnit() -> HKUnit {
		return Me.pounds
	}

	public final func quantityValue() -> Double {
		return weight
	}

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

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
