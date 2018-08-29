//
//  Weight.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class Weight: Sample, Equatable, CustomDebugStringConvertible {

	public static func ==(lhs: Weight, rhs: Weight) -> Bool {
		return lhs.equalTo(rhs)
	}

	fileprivate typealias Me = Weight
	public static let pounds: HKUnit = HKUnit(from: .pound)
	public static let kilograms: HKUnit = HKUnit(from: .kilogram)

	public static let weight = DoubleAttribute(name: "weight", pluralName: "weights", variableName: HKPredicateKeyPathQuantity)
	public static let timestamp = DateTimeAttribute(name: "timestamp", pluralName: "timestamps", variableName: HKPredicateKeyPathStartDate)
	public static let attributes: [Attribute] = [timestamp, weight]

	public var debugDescription: String {
		return "Weight of \(weight) at " + DependencyInjector.util.calendarUtil.string(for: timestamp)
	}

	public var name: String { return "Weight" }
	public var description: String { return "A measurement of body mass." }
	public var dataType: DataTypes { return .weight }
	public var attributes: [Attribute] { return Me.attributes }
	public var timestamp: Date

	public var weight: Double

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

	public func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	public func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(Me.weight) {
			return weight
		}
		if attribute.equalTo(CommonSampleAttributes.timestamp) {
			return timestamp
		}
		throw AttributeError.unknownAttribute
	}

	public func set(attribute: Attribute, to value: Any) throws {
		if attribute.name == Me.weight.name {
			guard let castedValue = value as? Double else { throw AttributeError.typeMismatch }
			weight = castedValue
			return
		}
		if attribute.name == CommonSampleAttributes.timestamp.name {
			guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
			timestamp = castedValue
			return
		}
		throw AttributeError.unknownAttribute
	}

	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is Weight) { return false }
		let other = otherAttributed as! Weight
		return equalTo(other)
	}

	public func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is Weight) { return false }
		let other = otherSample as! Weight
		return equalTo(other)
	}

	public func equalTo(_ other: Weight) -> Bool {
		return timestamp == other.timestamp && weight == other.weight
	}
}
