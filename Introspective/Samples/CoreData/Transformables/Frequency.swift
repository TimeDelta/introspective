//
//  Frequency.swift
//  Introspective
//
//  Created by Bryan Nova on 10/8/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class Frequency: NSObject, NSCoding, Codable, Comparable {

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
	private static let nanosecondsPerSecond: Double = 100000000
	private static let secondsPerMinute: Double = 60
	private static let secondsPerHour: Double = 3600
	private static let secondsPerDay: Double = 86400
	private static let secondsPerWeek: Double = 604800
	private static let secondsPerMonth: Double = 2.628e+6
	private static let secondsPerQuarter: Double = 31535965.4396976 / 4
	private static let secondsPerYear: Double = 31535965.4396976

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

	// MARK: - Comparable

	public static func ==(lhs: Frequency, rhs: Frequency) -> Bool {
		do {
			let left = try lhs.timesPerSecond()
			do {
				let right = try rhs.timesPerSecond()
				return left == right
			} catch {
				Log().error("Could not convert frequency (%@) to times per second: %@", rhs.description, errorInfo(error))
			}
		} catch {
			Log().error("Could not convert frequency (%@) to times per second: %@", lhs.description, errorInfo(error))
		}
		return lhs.timesPerTimeUnit == rhs.timesPerTimeUnit && lhs.timeUnit == rhs.timeUnit // best guess as last resort
	}

	public static func <(lhs: Frequency, rhs: Frequency) -> Bool {
		do {
			let left = try lhs.timesPerSecond()
			do {
				let right = try rhs.timesPerSecond()
				return left < right
			} catch {
				Log().error("Could not convert frequency (%@) to times per second: %@", rhs.description, errorInfo(error))
			}
		} catch {
			Log().error("Could not convert frequency (%@) to times per second: %@", lhs.description, errorInfo(error))
		}
		return lhs.timesPerTimeUnit < rhs.timesPerTimeUnit // best guess as last resort
	}

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

	// MARK: - Initializers

	public init(_ timesPerTimeUnit: Double, _ timeUnit: Calendar.Component) {
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
		switch (newTimeUnit) {
			case .nanosecond: return try timesPerSecond() * Me.nanosecondsPerSecond
			case .second: return try timesPerSecond()
			case .minute: return try timesPerSecond() / Me.secondsPerMinute
			case .hour: return try timesPerSecond() / Me.secondsPerHour
			case .day: return try timesPerSecond() / Me.secondsPerDay
			case .weekOfYear: return try timesPerSecond() / Me.secondsPerWeek
			case .month: return try timesPerSecond() / Me.secondsPerMonth
			case .quarter: return try timesPerSecond() / Me.secondsPerQuarter
			case .year: return try timesPerSecond() / Me.secondsPerYear
			default: throw Errors.cannotConvertToTimesPerSecond
		}
	}

	// MARK: - NSObject Overrides

	public override func isEqual(_ object: Any?) -> Bool {
		guard let other = object as? Frequency else { return false }
		return self == other
	}

	// MARK: - Helper Functions

	private final func timesPerSecond() throws -> Double {
		switch (timeUnit) {
			case .nanosecond: return timesPerTimeUnit * Me.nanosecondsPerSecond
			case .second: return timesPerTimeUnit
			case .minute: return timesPerTimeUnit / Me.secondsPerMinute
			case .hour: return timesPerTimeUnit / Me.secondsPerHour
			case .day: return timesPerTimeUnit / Me.secondsPerDay
			case .weekOfYear: return timesPerTimeUnit / Me.secondsPerWeek
			case .month: return timesPerTimeUnit / Me.secondsPerMonth
			case .quarter: return timesPerTimeUnit / Me.secondsPerQuarter
			case .year: return timesPerTimeUnit / Me.secondsPerYear
			default: throw Errors.cannotConvertToTimesPerSecond
		}
	}
}
