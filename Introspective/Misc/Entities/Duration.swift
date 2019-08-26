//
//  Duration.swift
//  Introspective
//
//  Created by Bryan Nova on 11/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftDate

public final class Duration: Equatable, Comparable {

	// MARK: - Static Variables

	private typealias Me = Duration
	private static let unitMultipliers: [Calendar.Component: Double] = [
		.nanosecond: 1/100000000,
		.second: 1,
		.minute: 60,
		.hour: 3600,
		.day: 86400,
		.weekOfYear: 604800,
		.month: 2628000,
		.year: 31536000,
	]

	// MARK: - Instance Variables

	private final let interval: TimeInterval
	private final let log = Log()

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
				log.error("Missing multiplier for component type in Duration initializer: ", unit.description)
			}
		}
		interval = tempInterval
	}

	// MARK: - Calculations

	public final func units(_ units: Set<Calendar.Component> = Set([.day, .hour, .minute, .second])) -> [Calendar.Component: Int] {
		return interval.toUnits(units)
	}

	/// Supported units are: .second, .minute, .hour, .day, .weekOfYear
	public final func inUnit(_ unit: Calendar.Component) -> Double {
		precondition(Me.unitMultipliers[unit] != nil, "Unsupported unit passed: \(unit.description)")

		return Double(interval) / Double(Me.unitMultipliers[unit]!)
	}

	// MARK: - Comparable

	public static func ==(lhs: Duration, rhs: Duration) -> Bool {
		return lhs.interval == rhs.interval
	}

	public static func <(lhs: Duration, rhs: Duration) -> Bool {
		return lhs.interval < rhs.interval
	}

	// MARK: - Math Operators

	public static func -(lhs: Duration, rhs: Duration) -> Duration {
		return Duration(lhs.interval - rhs.interval)
	}

	public static func -(lhs: Duration, rhs: Double) -> Duration {
		return Duration(lhs.interval - rhs)
	}

	public static func -(lhs: Duration, rhs: Int) -> Duration {
		return Duration(lhs.interval - Double(rhs))
	}

	public static func -(lhs: Duration, rhs: DateComponents) -> Duration {
		return Duration(lhs.interval - rhs.timeInterval)
	}

	public static func -(lhs: Date, rhs: Duration) -> Date {
		return lhs.addingTimeInterval(-rhs.interval)
	}

	public static func -=(lhs: inout Duration, rhs: Duration) {
		lhs = lhs - rhs
	}

	public static func -=(lhs: inout Duration, rhs: Double) {
		lhs = lhs - rhs
	}

	public static func -=(lhs: inout Duration, rhs: Int) {
		lhs = lhs - rhs
	}

	public static func -=(lhs: inout Duration, rhs: DateComponents) {
		lhs = lhs - rhs
	}

	public static func +(lhs: Duration, rhs: Duration) -> Duration {
		return Duration(lhs.interval + rhs.interval)
	}

	public static func +(lhs: Duration, rhs: Double) -> Duration {
		return Duration(lhs.interval + rhs)
	}

	public static func +(lhs: Duration, rhs: Int) -> Duration {
		return Duration(lhs.interval + Double(rhs))
	}

	public static func +(lhs: Duration, rhs: DateComponents) -> Duration {
		return Duration(lhs.interval + rhs.timeInterval)
	}

	public static func +(lhs: Date, rhs: Duration) -> Date {
		return lhs.addingTimeInterval(rhs.interval)
	}

	public static func +=(lhs: inout Duration, rhs: Duration) {
		lhs = lhs + rhs
	}

	public static func +=(lhs: inout Duration, rhs: Double) {
		lhs = lhs + rhs
	}

	public static func +=(lhs: inout Duration, rhs: Int) {
		lhs = lhs + rhs
	}

	public static func +=(lhs: inout Duration, rhs: DateComponents) {
		lhs = lhs + rhs
	}

	public static func /(lhs: Duration, rhs: Duration) -> Double {
		return lhs.interval / rhs.interval
	}

	public static func /(lhs: Duration, rhs: Int) -> Duration {
		return Duration(lhs.interval / Double(rhs))
	}

	public static func /(lhs: Duration, rhs: Double) -> Duration {
		return Duration(lhs.interval / rhs)
	}

	public static func /(lhs: Duration, rhs: DateComponents) -> Double {
		return lhs.interval / rhs.timeInterval
	}

	public static func /=(lhs: inout Duration, rhs: Int) {
		lhs = lhs / rhs
	}

	public static func /=(lhs: inout Duration, rhs: Double) {
		lhs = lhs / rhs
	}

	public static func *(lhs: Duration, rhs: Int) -> Duration {
		return Duration(lhs.interval * Double(rhs))
	}

	public static func *(lhs: Duration, rhs: Double) -> Duration {
		return Duration(lhs.interval * rhs)
	}

	public static func *(lhs: Int, rhs: Duration) -> Duration {
		return Duration(rhs.interval * Double(lhs))
	}

	public static func *(lhs: Double, rhs: Duration) -> Duration {
		return Duration(rhs.interval * lhs)
	}

	public static func *=(lhs: inout Duration, rhs: Int) {
		lhs = lhs * rhs
	}

	public static func *=(lhs: inout Duration, rhs: Double) {
		lhs = lhs * rhs
	}
}

// MARK: - CustomStringConvertible

extension Duration: CustomStringConvertible {

	public final var description: String {
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
}
