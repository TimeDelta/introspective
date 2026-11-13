import Foundation

public struct ActivityBackdateError: LocalizedError, Equatable {
	public let message: String
	public init(_ message: String) { self.message = message }
	public var errorDescription: String? { message }
}

/// An explicitly estimated offset keeps the requested unit and clears every lower unit.
/// Automatic Now captures and unchanged values must not pass through this helper.
public enum ActivityBackdate {
	public static func unit(named name: String) throws -> Calendar.Component {
		let normalized = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		switch normalized {
		case "second", "seconds": return .second
		case "minute", "minutes": return .minute
		case "hour", "hours": return .hour
		case "day", "days": return .day
		case "week", "weeks", "week of year", "weeks of year", "weekofyear": return .weekOfYear
		case "month", "months": return .month
		case "year", "years": return .year
		default: throw ActivityBackdateError("Choose seconds, minutes, hours, days, weeks, months or years.")
		}
	}

	public static func date(value: Int, unit: Calendar.Component, now: Date = Date(),
		calendar: Calendar = .autoupdatingCurrent) throws -> Date {
		let maximum: Int
		switch unit {
		case .second: maximum = 400_000_000_000
		case .minute: maximum = 6_000_000_000
		case .hour: maximum = 100_000_000
		case .day: maximum = 4_000_000
		case .weekOfYear: maximum = 550_000
		case .month: maximum = 120_000
		case .year: maximum = 10_000
		default: throw ActivityBackdateError("Choose a supported backdating unit.")
		}
		// Check before negation or calendar arithmetic, including Int.min and Int.max.
		guard value >= 0, value <= maximum else {
			throw ActivityBackdateError("Choose a nonnegative, whole-number offset within the supported date range.")
		}
		guard now.timeIntervalSinceReferenceDate.isFinite, now >= .distantPast, now <= .distantFuture,
			let shifted = calendar.date(byAdding: unit, value: -value, to: now),
			let result = calendar.dateInterval(of: unit, for: shifted)?.start,
			result.timeIntervalSinceReferenceDate.isFinite, result >= .distantPast, result <= now else {
			throw ActivityBackdateError("Choose a valid activity time.")
		}
		return result
	}
}
