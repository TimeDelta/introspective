import Foundation

/// Values captured for a read-only query, available only during work on its
/// owning queue. Nested reads restore the previous scope rather than changing
/// the app's injected settings or another queue's evaluation date.
public enum QueryReadScope {
	private static let key = "com.bnova.Introspective.QueryReadScope"
	private final class Values: NSObject {
		let date: Date
		let convertTimeZones: Bool
		var failure: Error?
		init(date: Date, convertTimeZones: Bool) {
			self.date = date
			self.convertTimeZones = convertTimeZones
		}
	}

	private static var values: Values? { Thread.current.threadDictionary[key] as? Values }
	public static var date: Date? { values?.date }
	public static var convertTimeZones: Bool? { values?.convertTimeZones }
	public static var readFailure: Error? { values?.failure }

	/// Record a failure on the calling scope's thread, never from a platform
	/// callback on an unrelated queue. Nested scopes keep independent failures.
	public static func recordFailure(_ error: Error) {
		guard let values = values, values.failure == nil else { return }
		values.failure = error
	}

	public static func with<Value>(date: Date, convertTimeZones: Bool, _ action: () throws -> Value) rethrows -> Value {
		let dictionary = Thread.current.threadDictionary
		let previous = dictionary[key]
		dictionary[key] = Values(date: date, convertTimeZones: convertTimeZones)
		defer {
			if let previous = previous { dictionary[key] = previous }
			else { dictionary.removeObject(forKey: key) }
		}
		return try action()
	}
}
