//
//  TimeDuration.swift
//  Introspective
//
//  Created by Bryan Nova on 11/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftDate

public final class TimeDuration: NSObject, NSSecureCoding, Comparable {
	// MARK: - Static Variables

	private typealias Me = TimeDuration
	private static let unitMultipliers: [Calendar.Component: Double] = [
		.nanosecond: 1 / 100_000_000,
		.second: 1,
		.minute: 60,
		.hour: 3600,
		.day: 86400,
		.weekOfYear: 604_800,
		.month: 2_628_000,
		.year: 31_536_000,
	]

	private static let log = Log()

	// MARK: - Display Information

	public final override var description: String {
		var clockTime = interval.toIntervalString(options: {
			$0.collapsesLargestUnit = false
			$0.maximumUnitCount = 0
			$0.unitsStyle = .positional
			$0.locale = Locales.englishUnitedStatesComputer
			$0.zeroFormattingBehavior = [.dropLeading]
		})
		if clockTime.count < 2 {
			clockTime = "0:00:0" + clockTime
		} else if clockTime.count < 3 {
			clockTime = "0:00:" + clockTime
		} else if clockTime.count < 5 {
			clockTime = "0:0" + clockTime
		} else if clockTime.count < 6 {
			clockTime = "0:" + clockTime
		}
		return clockTime
	}

	// MARK: - Instance Variables

	private final let interval: TimeInterval

	// MARK: - Initializers

	public init(start: Date, end: Date?) {
		let end = end ?? Date()
		interval = (end - start).timeInterval
	}

	public init(_ interval: TimeInterval) {
		self.interval = interval
	}

	public convenience init(_ dateComponents: DateComponents) {
		self.init(dateComponents.timeInterval)
	}

	public init(_ units: [Calendar.Component: Int]) {
		var tempInterval: TimeInterval = 0
		for (unit, amount) in units {
			if let multiplier = Me.unitMultipliers[unit] {
				tempInterval.addProduct(multiplier, Double(amount))
			} else {
				Me.log.error("Missing multiplier for component type in TimeDuration initializer: ", unit.description)
			}
		}
		interval = tempInterval
	}

	public init?(coder decoder: NSCoder) {
		interval = decoder.decodeDouble(forKey: CodingKeys.interval.rawValue)
	}

	// MARK: - NSObject Overrides

	public override func isEqual(_ object: Any?) -> Bool {
		guard let other = object as? TimeDuration else { return false }
		return self == other
	}

	// MARK: - NSSecureCoding

	private enum CodingKeys: String, CodingKey {
		case interval
	}

	public static let supportsSecureCoding = true

	public final func encode(with encoder: NSCoder) {
		encoder.encode(interval, forKey: CodingKeys.interval.rawValue)
	}

	// MARK: - Calculations

	public final func units(
		_ units: Set<Calendar.Component> = Set([.day, .hour, .minute, .second])
	) -> [Calendar.Component: Int] {
		interval.toUnits(units)
	}

	/// Supported units are: .second, .minute, .hour, .day, .weekOfYear, .month, .year
	public final func inUnit(_ unit: Calendar.Component) -> Double {
		precondition(Me.unitMultipliers[unit] != nil, "Unsupported unit passed: \(unit.description)")

		return Double(interval) / Double(Me.unitMultipliers[unit]!)
	}

	// MARK: - Comparable

	public static func == (lhs: TimeDuration, rhs: TimeDuration) -> Bool {
		lhs.interval == rhs.interval
	}

	public static func < (lhs: TimeDuration, rhs: TimeDuration) -> Bool {
		lhs.interval < rhs.interval
	}

	// MARK: - Math Operators

	// MARK: Subtraction

	public static func - (lhs: TimeDuration, rhs: TimeDuration) -> TimeDuration {
		TimeDuration(lhs.interval - rhs.interval)
	}

	public static func - (lhs: TimeDuration, rhs: Double) -> TimeDuration {
		TimeDuration(lhs.interval - rhs)
	}

	public static func - (lhs: TimeDuration, rhs: Int) -> TimeDuration {
		TimeDuration(lhs.interval - Double(rhs))
	}

	public static func - (lhs: TimeDuration, rhs: DateComponents) -> TimeDuration {
		TimeDuration(lhs.interval - rhs.timeInterval)
	}

	public static func - (lhs: Date, rhs: TimeDuration) -> Date {
		lhs.addingTimeInterval(-rhs.interval)
	}

	// MARK: Subtractive Assignment

	public static func -= (lhs: inout TimeDuration, rhs: TimeDuration) {
		lhs = lhs - rhs
	}

	public static func -= (lhs: inout TimeDuration, rhs: Double) {
		lhs = lhs - rhs
	}

	public static func -= (lhs: inout TimeDuration, rhs: Int) {
		lhs = lhs - rhs
	}

	public static func -= (lhs: inout TimeDuration, rhs: DateComponents) {
		lhs = lhs - rhs
	}

	// MARK: Addition

	public static func + (lhs: TimeDuration, rhs: TimeDuration) -> TimeDuration {
		TimeDuration(lhs.interval + rhs.interval)
	}

	public static func + (lhs: TimeDuration, rhs: Double) -> TimeDuration {
		TimeDuration(lhs.interval + rhs)
	}

	public static func + (lhs: TimeDuration, rhs: Int) -> TimeDuration {
		TimeDuration(lhs.interval + Double(rhs))
	}

	public static func + (lhs: TimeDuration, rhs: DateComponents) -> TimeDuration {
		TimeDuration(lhs.interval + rhs.timeInterval)
	}

	public static func + (lhs: Date, rhs: TimeDuration) -> Date {
		lhs.addingTimeInterval(rhs.interval)
	}

	// MARK: Additive Assignment

	public static func += (lhs: inout TimeDuration, rhs: TimeDuration) {
		lhs = lhs + rhs
	}

	public static func += (lhs: inout TimeDuration, rhs: Double) {
		lhs = lhs + rhs
	}

	public static func += (lhs: inout TimeDuration, rhs: Int) {
		lhs = lhs + rhs
	}

	public static func += (lhs: inout TimeDuration, rhs: DateComponents) {
		lhs = lhs + rhs
	}

	// MARK: Division

	public static func / (lhs: TimeDuration, rhs: TimeDuration) -> Double {
		lhs.interval / rhs.interval
	}

	public static func / (lhs: TimeDuration, rhs: Int) -> TimeDuration {
		TimeDuration(lhs.interval / Double(rhs))
	}

	public static func / (lhs: TimeDuration, rhs: Double) -> TimeDuration {
		TimeDuration(lhs.interval / rhs)
	}

	public static func / (lhs: TimeDuration, rhs: DateComponents) -> Double {
		lhs.interval / rhs.timeInterval
	}

	// MARK: Division Assignment

	public static func /= (lhs: inout TimeDuration, rhs: Int) {
		lhs = lhs / rhs
	}

	public static func /= (lhs: inout TimeDuration, rhs: Double) {
		lhs = lhs / rhs
	}

	// MARK: Multiplication

	public static func * (lhs: TimeDuration, rhs: Int) -> TimeDuration {
		TimeDuration(lhs.interval * Double(rhs))
	}

	public static func * (lhs: TimeDuration, rhs: Double) -> TimeDuration {
		TimeDuration(lhs.interval * rhs)
	}

	public static func * (lhs: Int, rhs: TimeDuration) -> TimeDuration {
		TimeDuration(rhs.interval * Double(lhs))
	}

	public static func * (lhs: Double, rhs: TimeDuration) -> TimeDuration {
		TimeDuration(rhs.interval * lhs)
	}

	// MARK: Multiplicative Assignment

	public static func *= (lhs: inout TimeDuration, rhs: Int) {
		lhs = lhs * rhs
	}

	public static func *= (lhs: inout TimeDuration, rhs: Double) {
		lhs = lhs * rhs
	}
}

@objc(TimeDurationValueTransformer)
public final class TimeDurationValueTransformer: NSSecureUnarchiveFromDataTransformer {
	/// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
	public static let name = NSValueTransformerName(rawValue: String(describing: TimeDurationValueTransformer.self))

	public static override var allowedTopLevelClasses: [AnyClass] {
		[TimeDuration.self]
	}

	/// Registers the transformer.
	public static func register() {
		ValueTransformer.setValueTransformer(TimeDurationValueTransformer(), forName: name)
	}
}
