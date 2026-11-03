import Foundation

/// The permanent Core Data URI is the identity. The name is only a fallback
/// label when the saved query can no longer be found; no query or results are copied.
public struct PinnedQueryReference: Codable, Equatable {
	public let id: String
	public var lastKnownName: String

	public init(id: String, lastKnownName: String) {
		self.id = id
		self.lastKnownName = lastKnownName
	}
}

public enum PinnedQueryPreferencesError: LocalizedError {
	case invalidReference
	case duplicateReference
	case tooManyPins
	case invalidMove
	case unreadablePins

	public var errorDescription: String? {
		switch self {
		case .invalidReference: return "A pinned query has an invalid identity or name."
		case .duplicateReference: return "A saved query can only be pinned once."
		case .tooManyPins: return "Keep up to 12 pinned queries."
		case .invalidMove: return "The pinned query could not be moved."
		case .unreadablePins: return "The pinned query list could not be read."
		}
	}
}

/// Stores only ordered references. Removing a query does not automatically remove
/// its pin: the dashboard can explain the missing query instead of changing meaning.
public final class PinnedQueryPreferences {
	/// Limits dashboard work and keeps the ordered list small enough to review.
	public static let maximumPins = 12
	public static let maximumNameLength = 200
	public static let shared = PinnedQueryPreferences(defaults: UserDefaults(suiteName:
		CommandLine.arguments.contains("--ui-testing") ? "com.bnova.Introspective.dashboard-ui-tests" : "group.Introspective")!)

	private let defaults: UserDefaults
	private let key = "pinnedSavedQueries.v1"
	private let lock = NSLock()
	private let maximumStoredBytes = 64 * 1024

	public init(defaults: UserDefaults) { self.defaults = defaults }

	public func pins() throws -> [PinnedQueryReference] {
		try locked { try read() }
	}

	/// Validate and encode the entire replacement before writing anything.
	public func save(pins: [PinnedQueryReference]) throws {
		try locked { try write(pins) }
	}

	/// Pinning an existing identity refreshes its fallback name in the same spot.
	/// A rename never duplicates a pin or changes the saved query itself.
	public func pin(_ reference: PinnedQueryReference) throws {
		try locked {
			var values = try read()
			if let index = values.firstIndex(where: { $0.id == reference.id }) { values[index] = reference }
			else { values.append(reference) }
			try write(values)
		}
	}

	public func unpin(id: String) throws {
		try locked {
			let values = try read()
			let remaining = values.filter { $0.id != id }
			if remaining != values { try write(remaining) }
		}
	}

	/// Destination is the final row index, matching UITableView's move operation.
	public func move(from source: Int, to destination: Int) throws {
		try locked {
			var values = try read()
			guard values.indices.contains(source), values.indices.contains(destination) else {
				throw PinnedQueryPreferencesError.invalidMove
			}
			guard source != destination else { return }
			let value = values.remove(at: source)
			values.insert(value, at: destination)
			try write(values)
		}
	}

	private func locked<T>(_ action: () throws -> T) rethrows -> T {
		lock.lock(); defer { lock.unlock() }
		return try action()
	}

	private func read() throws -> [PinnedQueryReference] {
		guard let stored = defaults.object(forKey: key) else { return [] }
		guard let data = stored as? Data, data.count <= maximumStoredBytes else {
			throw PinnedQueryPreferencesError.unreadablePins
		}
		let values: [PinnedQueryReference]
		do { values = try JSONDecoder().decode([PinnedQueryReference].self, from: data) }
		catch { throw PinnedQueryPreferencesError.unreadablePins }
		try validate(values)
		return values
	}

	private func write(_ pins: [PinnedQueryReference]) throws {
		try validate(pins)
		let data = try JSONEncoder().encode(pins)
		guard data.count <= maximumStoredBytes else { throw PinnedQueryPreferencesError.invalidReference }
		defaults.set(data, forKey: key)
	}

	private func validate(_ pins: [PinnedQueryReference]) throws {
		guard pins.count <= Self.maximumPins else { throw PinnedQueryPreferencesError.tooManyPins }
		guard Set(pins.map { $0.id }).count == pins.count else { throw PinnedQueryPreferencesError.duplicateReference }
		for pin in pins {
			guard pin.id.utf8.count <= 2048, let uri = URLComponents(string: pin.id),
				uri.scheme == "x-coredata", uri.host?.isEmpty == false,
				uri.user == nil, uri.password == nil, uri.port == nil, uri.query == nil, uri.fragment == nil,
				uri.path.split(separator: "/").count == 2,
				!pin.lastKnownName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
				pin.lastKnownName.count <= Self.maximumNameLength else {
				throw PinnedQueryPreferencesError.invalidReference
			}
		}
	}
}
