//
//  BodyMassIndex.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public final class BodyMassIndex: HealthKitQuantitySample, Equatable, CustomDebugStringConvertible {

	public static func ==(lhs: BodyMassIndex, rhs: BodyMassIndex) -> Bool {
		return lhs.equalTo(rhs)
	}

	private typealias Me = BodyMassIndex

	public static let unit: HKUnit = HKUnit.count()

	public static let bmi = DoubleAttribute(name: "BMI", pluralName: "BMIs", variableName: HKPredicateKeyPathQuantity)
	public static let timestamp = DateTimeAttribute(name: "timestamp", pluralName: "timestamps", variableName: HKPredicateKeyPathStartDate)
	public static let attributes: [Attribute] = [timestamp, bmi]

	public final var debugDescription: String {
		return "bmi of \(bmi) at " + DependencyInjector.util.calendarUtil.string(for: timestamp)
	}

	public final var name: String { return "Body Mass Index" }
	public final var description: String { return "Body Mass Index (BMI) is an indicator of your body fat. It's calculated from your height and weight, and can tell you whether you are underweight, normal, overweight, or obese. It can also help you gauge your risk for diseases that can occur with more body fat." }
	public final var dataType: DataTypes { return .bmi }
	public final var attributes: [Attribute] { return Me.attributes }
	public final var timestamp: Date

	public final var bmi: Double

	public init() {
		bmi = Double()
		timestamp = Date()
	}

	public init(_ timestamp: Date) {
		bmi = Double()
		self.timestamp = timestamp
	}

	public init(_ value: Double) {
		bmi = value
		timestamp = Date()
	}

	public init(_ value: Double, _ timestamp: Date) {
		bmi = value
		self.timestamp = timestamp
	}

	public init(_ sample: HKQuantitySample) {
		bmi = sample.quantity.doubleValue(for: Me.unit)
		timestamp = sample.startDate
	}

	public final func quantityUnit() -> HKUnit {
		return Me.unit
	}

	public final func quantityValue() -> Double {
		return bmi
	}

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	public final func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(Me.bmi) {
			return bmi
		}
		if attribute.equalTo(Me.timestamp) {
			return timestamp
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any) throws {
		if attribute.equalTo(Me.bmi) {
			guard let castedValue = value as? Double else { throw AttributeError.typeMismatch }
			bmi = castedValue
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
