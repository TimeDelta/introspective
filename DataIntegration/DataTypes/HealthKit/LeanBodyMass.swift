//
//  LeanBodyMass.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public final class LeanBodyMass: HealthKitQuantitySample, Equatable, CustomDebugStringConvertible {

	public static func ==(lhs: LeanBodyMass, rhs: LeanBodyMass) -> Bool {
		return lhs.equalTo(rhs)
	}

	private typealias Me = LeanBodyMass

	public static let pounds: HKUnit = HKUnit(from: .pound)
	public static let unit = HealthManager.preferredUnitFor(.leanBodyMass) ?? Me.pounds

	public static let leanBodyMass = DoubleAttribute(name: "Lean body mass", pluralName: "Lean body masses", variableName: HKPredicateKeyPathQuantity)
	public static let timestamp = DateTimeAttribute(name: "Timestamp", pluralName: "Timestamps", variableName: HKPredicateKeyPathStartDate)
	public static let attributes: [Attribute] = [timestamp, leanBodyMass]

	public final var debugDescription: String {
		return "LeanBodyMass of \(leanBodyMass) at " + DependencyInjector.util.calendarUtil.string(for: timestamp)
	}

	public final var name: String { return "Lean body mass" }
	public final var description: String { return "Lean body mass is the weight of your body minus your body fat" } // TODO
	public final var dataType: DataTypes { return .leanBodyMass }
	public final var attributes: [Attribute] { return Me.attributes }
	public final var timestamp: Date

	public final var leanBodyMass: Double

	public init() {
		leanBodyMass = Double()
		timestamp = Date()
	}

	public init(_ timestamp: Date) {
		leanBodyMass = Double()
		self.timestamp = timestamp
	}

	public init(_ value: Double) {
		leanBodyMass = value
		timestamp = Date()
	}

	public init(_ value: Double, _ timestamp: Date) {
		leanBodyMass = value
		self.timestamp = timestamp
	}

	public init(_ sample: HKQuantitySample) {
		leanBodyMass = sample.quantity.doubleValue(for: Me.unit)
		timestamp = sample.startDate
	}

	public final func quantityUnit() -> HKUnit {
		return Me.unit
	}

	public final func quantityValue() -> Double {
		return leanBodyMass
	}

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	public final func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(Me.leanBodyMass) {
			return leanBodyMass
		}
		if attribute.equalTo(Me.timestamp) {
			return timestamp
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any) throws {
		if attribute.equalTo(Me.leanBodyMass) {
			guard let castedValue = value as? Double else { throw AttributeError.typeMismatch }
			leanBodyMass = castedValue
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
