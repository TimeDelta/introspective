//
//  Frequency.swift
//  Introspective
//
//  Created by Bryan Nova on 10/8/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection

public final class Frequency: NSObject, NSSecureCoding, Codable, Comparable {
	// MARK: - Enums

	public enum Errors: String, Error {
		case cannotConvertToTimesPerSecond
	}

	private enum CodingKeys: String, CodingKey {
		case timesPerTimeUnit
		case timeUnit
	}

	// MARK: - Static Variables

	private typealias Me = Frequency

	private static let nanosecondsPerMinute: Double = 6_000_000_000
	private static let minutesPerSecond: Double = 1 / 60
	private static let minutesPerHour: Double = 60
	private static let minutesPerDay: Double = minutesPerHour * 24
	private static let minutesPerWeek: Double = minutesPerDay * 7
	private static let minutesPerYear: Double = 525_600
	private static let minutesPerQuarter: Double = minutesPerYear / 4
	private static let minutesPerMonth: Double = minutesPerYear / 12

	private static let nonNumbersRegex = try! NSRegularExpression(pattern: "[^0-9.]+", options: [])

	public static let supportsSecureCoding = true
	public static let supportedTimeUnits: [Calendar.Component] = [
		.nanosecond,
		.second,
		.minute,
		.hour,
		.day,
		.weekOfYear,
		.month,
		.quarter,
		.year,
	]

	// MARK: - Instance Variables

	public final var timesPerTimeUnit: Double
	public final var timeUnit: Calendar.Component

	public final override var description: String {
		var text = String(timesPerTimeUnit)
		if text.hasSuffix(".0") {
			text = String(text.prefix(text.count - 2))
		}
		text += " time"
		if timesPerTimeUnit != 1 {
			text += "s"
		}
		text += " per " + timeUnit.description.localizedLowercase
		return text
	}

	private final let log = Log()

	// MARK: - Initializers

	public init?(_ text: String) {
		guard let unit = Me.getTimeUnit(text) else { return nil }
		timeUnit = unit
		let numbersOnly = Me.nonNumbersRegex.stringByReplacingMatches(
			in: text,
			options: [],
			range: NSMakeRange(0, text.count),
			withTemplate: ""
		)
		if DependencyInjector.get(StringUtil.self).isNumber(numbersOnly) {
			timesPerTimeUnit = Double(numbersOnly)!
		} else {
			return nil
		}
	}

	public init?(_ timesPerTimeUnit: Double, _ timeUnit: Calendar.Component) {
		guard Me.supportedTimeUnits.contains(timeUnit) else {
			log.error("Tried to initialize frequency with invalid time unit: %@", timeUnit.description)
			return nil
		}
		self.timesPerTimeUnit = timesPerTimeUnit
		self.timeUnit = timeUnit
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		timesPerTimeUnit = try values.decode(Double.self, forKey: .timesPerTimeUnit)
		let timeUnitInt = try values.decode(Int.self, forKey: .timeUnit)
		timeUnit = Calendar.Component.fromInt(timeUnitInt)
	}

	public init(coder decoder: NSCoder) {
		timesPerTimeUnit = decoder.decodeDouble(forKey: CodingKeys.timesPerTimeUnit.rawValue)
		let timeUnitInt = decoder.decodeInteger(forKey: CodingKeys.timeUnit.rawValue)
		timeUnit = Calendar.Component.fromInt(timeUnitInt)
	}

	// MARK: - Encodable

	public final func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(timesPerTimeUnit, forKey: .timesPerTimeUnit)
		try container.encode(timeUnit.intValue(), forKey: .timeUnit)
	}

	public final func encode(with encoder: NSCoder) {
		encoder.encode(timesPerTimeUnit, forKey: CodingKeys.timesPerTimeUnit.rawValue)
		encoder.encode(timeUnit.intValue(), forKey: CodingKeys.timeUnit.rawValue)
	}

	// MARK: - Other

	public final func per(_ newTimeUnit: Calendar.Component) throws -> Double {
		switch newTimeUnit {
		case .nanosecond: return timesPerMinute() / Me.nanosecondsPerMinute
		case .second: return timesPerMinute() * Me.minutesPerSecond
		case .minute: return timesPerMinute()
		case .hour: return timesPerMinute() * Me.minutesPerHour
		case .day: return timesPerMinute() * Me.minutesPerDay
		case .weekOfYear: return timesPerMinute() * Me.minutesPerWeek
		case .month: return timesPerMinute() * Me.minutesPerMonth
		case .quarter: return timesPerMinute() * Me.minutesPerQuarter
		case .year: return timesPerMinute() * Me.minutesPerYear
		default: throw Errors.cannotConvertToTimesPerSecond
		}
	}

	// MARK: - NSObject Overrides

	public override func isEqual(_ object: Any?) -> Bool {
		guard let other = object as? Frequency else { return false }
		return self == other
	}

	// MARK: - Helper Functions

	private final func timesPerMinute() -> Double {
		switch timeUnit {
		case .nanosecond: return timesPerTimeUnit * Me.nanosecondsPerMinute
		case .second: return timesPerTimeUnit / Me.minutesPerSecond
		case .minute: return timesPerTimeUnit
		case .hour: return timesPerTimeUnit / Me.minutesPerHour
		case .day: return timesPerTimeUnit / Me.minutesPerDay
		case .weekOfYear: return timesPerTimeUnit / Me.minutesPerWeek
		case .month: return timesPerTimeUnit / Me.minutesPerMonth
		case .quarter: return timesPerTimeUnit / Me.minutesPerQuarter
		case .year: return timesPerTimeUnit / Me.minutesPerYear
		default: fatalError("Missing conversion for supported time unit: " + timeUnit.description)
		}
	}

	private static func getTimeUnit(_ text: String) -> Calendar.Component? {
		for unit in Me.supportedTimeUnits {
			if text.localizedCaseInsensitiveContains(unit.description) {
				return unit
			}
		}
		return nil
	}

	// MARK: - Comparable

	public static func == (lhs: Frequency, rhs: Frequency) -> Bool {
		let left = lhs.timesPerMinute()
		let right = rhs.timesPerMinute()
		return left == right
	}

	public static func < (lhs: Frequency, rhs: Frequency) -> Bool {
		let left = lhs.timesPerMinute()
		let right = rhs.timesPerMinute()
		return left < right
	}

	// MARK: - Math Operators

	public static func + (lhs: Frequency, rhs: Frequency) -> Frequency {
		math(lhs: lhs, rhs: rhs, operation: { $0 + $1 })
	}

	public static func += (lhs: inout Frequency, rhs: Frequency) {
		lhs = lhs + rhs
	}

	public static func - (lhs: Frequency, rhs: Frequency) -> Frequency {
		math(lhs: lhs, rhs: rhs, operation: { $0 - $1 })
	}

	public static func -= (lhs: inout Frequency, rhs: Frequency) {
		lhs = lhs - rhs
	}

	public static func / (lhs: Frequency, rhs: Double) -> Frequency {
		math(lhs: lhs, rhs: rhs, operation: { $0 / $1 })
	}

	public static func / (lhs: Frequency, rhs: Int) -> Frequency {
		math(lhs: lhs, rhs: rhs, operation: { $0 / $1 })
	}

	public static func /= (lhs: inout Frequency, rhs: Double) {
		lhs = lhs / rhs
	}

	public static func /= (lhs: inout Frequency, rhs: Int) {
		lhs = lhs / rhs
	}

	public static func * (lhs: Double, rhs: Frequency) -> Frequency {
		rhs * lhs // commutative
	}

	public static func * (lhs: Int, rhs: Frequency) -> Frequency {
		rhs * lhs // commutative
	}

	public static func * (lhs: Frequency, rhs: Double) -> Frequency {
		math(lhs: lhs, rhs: rhs, operation: { $0 * $1 })
	}

	public static func * (lhs: Frequency, rhs: Int) -> Frequency {
		math(lhs: lhs, rhs: rhs, operation: { $0 * $1 })
	}

	public static func *= (lhs: inout Frequency, rhs: Double) {
		lhs = lhs * rhs
	}

	public static func *= (lhs: inout Frequency, rhs: Int) {
		lhs = lhs * rhs
	}

	private static func math(lhs: Frequency, rhs: Frequency, operation: (Double, Double) -> Double) -> Frequency {
		math(lhs.timeUnit, lhs.timesPerMinute(), rhs.timesPerMinute(), operation)
	}

	private static func math(lhs: Frequency, rhs: Double, operation: (Double, Double) -> Double) -> Frequency {
		math(lhs.timeUnit, lhs.timesPerMinute(), rhs, operation)
	}

	private static func math(lhs: Frequency, rhs: Int, operation: (Double, Double) -> Double) -> Frequency {
		math(lhs.timeUnit, lhs.timesPerMinute(), Double(rhs), operation)
	}

	/// - Parameter left: The number of times per minute for the left operand
	/// - Parameter right: The number of times per minute for the right operand
	private static func math(
		_ unit: Calendar.Component,
		_ left: Double,
		_ right: Double,
		_ operation: (Double, Double) -> Double
	) -> Frequency {
		let frequency = Frequency(operation(left, right), .minute)!
		do {
			guard let result = Frequency(try frequency.per(unit), unit) else {
				// this cannot return nil because the time unit being passed in has already passed validation
				fatalError("Unable to construct frequency with supported time unit: " + unit.description)
			}
			return result
		} catch {
			return frequency
		}
	}
}
