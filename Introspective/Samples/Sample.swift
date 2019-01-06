//
//  Sample.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit
import os

public enum DateType {
	case start
	case end
}

public protocol Sample: Attributed {

	static var name: String { get }

	static var attributes: [Attribute] { get }
	static var defaultDependentAttribute: Attribute { get }
	static var defaultIndependentAttribute: Attribute { get }

	func graphableValue(of attribute: Attribute) throws -> Any?

	func dates() -> [DateType: Date]
	func equalTo(_ otherSample: Sample) -> Bool
}

extension Sample {

	public func graphableValue(of attribute: Attribute) throws -> Any? {
		return try value(of: attribute)
	}

	public func equalTo(_ otherSample: Sample) -> Bool {
		if attributedName != otherSample.attributedName { return false }
		if description != otherSample.description { return false }
		if dates() != otherSample.dates() { return false }
		if type(of: self) != type(of: otherSample) { return false }
		if attributes.count != otherSample.attributes.count { return false }
		for attribute in attributes {
			let index = otherSample.attributes.index(where: { (a: Attribute) -> Bool in return a.equalTo(attribute) })
			if index == nil { return false }
		}
		for attribute in attributes {
			switch (attribute) {
				case is BooleanAttribute:
					if !safeEqualityCheck(attribute, otherSample, as: Bool.self) { return false }
					break
				case is CalendarComponentAttribute:
					if !safeEqualityCheck(attribute, otherSample, as: Calendar.Component.self) { return false }
					break
				case is DateAttribute:
					if !safeEqualityCheck(attribute, otherSample, as: Date.self) { return false }
					break
				case is DayOfWeekAttribute:
					if !safeEqualityCheck(attribute, otherSample, as: DayOfWeek.self) { return false }
					break
				case is DoubleAttribute:
					if !safeEqualityCheck(attribute, otherSample, as: Double.self) { return false }
					break
				case is DurationAttribute:
					if !safeEqualityCheck(attribute, otherSample, as: Duration.self) { return false }
					break
				case is FrequencyAttribute:
					if !safeEqualityCheck(attribute, otherSample, as: Frequency.self) { return false }
					break
				case is IntegerAttribute:
					if !safeEqualityCheck(attribute, otherSample, as: Int.self) { return false }
					break
				case is TagAttribute:
					if !safeEqualityCheck(attribute, otherSample, as: Tag.self) { return false }
					break
				case is TextAttribute:
					if !safeEqualityCheck(attribute, otherSample, as: String.self) { return false }
					break
				case is TimeOfDayAttribute:
					if !safeEqualityCheck(attribute, otherSample, as: TimeOfDay.self) { return false }
					break
				default:
					os_log("Sample - Need to include equal comparison for attribute type: %@", type: .debug, String(describing: type(of: attribute)))
			}
		}
		return true
	}

	private func safeEqualityCheck<Type: Equatable>(_ attribute: Attribute, _ otherSample: Sample, as type: Type.Type) -> Bool {
		do {
			let myValue = try value(of: attribute)
			if !(myValue is Type) && !(myValue is Optional<Type> && attribute.optional) { return false }
			let otherValue = try otherSample.value(of: attribute)
			if !(otherValue is Type) && !(otherValue is Optional<Type> && attribute.optional) { return false }
			return myValue as? Type == otherValue as? Type
		} catch {
			os_log("Failed to safely check equality of sample attribute '%@': %@", attribute.name, errorInfo(error))
			return false
		}
	}
}

public class CommonSampleAttributes {

	public static let timestamp = DateTimeAttribute(name: "Timestamp", pluralName: "Timestamps", variableName: "timestamp")
	public static let startDate = DateTimeAttribute(name: "Start Date", pluralName: "Start dates", variableName: "startDate")
	public static let endDate = DateTimeAttribute(name: "End Date", pluralName: "End dates", variableName: "endDate")

	public static let healthKitTimestamp = DateTimeAttribute(name: timestamp.name, pluralName: timestamp.pluralName, variableName: HKPredicateKeyPathStartDate)
	public static let healthKitStartDate = DateTimeAttribute(name: startDate.name, pluralName: startDate.pluralName, variableName: HKPredicateKeyPathStartDate)
	public static let healthKitEndDate = DateTimeAttribute(name: endDate.name, pluralName: endDate.pluralName, variableName: HKPredicateKeyPathEndDate)
}
