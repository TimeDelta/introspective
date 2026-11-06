import Foundation

/// Geometry only: the UI runner separately checks foreground state/hittability.
/// Its own UIScreen can be a placeholder, so use the actual display's pixels.
enum UITestLaunchGeometry {
	static func isUsable(displayPixels: CGSize, window: CGRect, recordTab: CGRect) -> Bool {
		let dimensions = [displayPixels.width, displayPixels.height,
			window.minX, window.minY, window.width, window.height,
			recordTab.minX, recordTab.minY, recordTab.width, recordTab.height]
		guard dimensions.allSatisfy({ $0.isFinite }), displayPixels.width > 0, displayPixels.height > 0,
			abs(window.minX) <= 1, abs(window.minY) <= 1,
			recordTab.width >= 44, recordTab.height >= 30, window.contains(recordTab) else { return false }
		// CI uses portrait iPhones with 2x or 3x backing scales. Allow one logical
		// point of rounding, but reject a window scaled down inside SpringBoard.
		return [CGFloat(2), CGFloat(3)].contains { scale in
			abs(window.width * scale - displayPixels.width) <= scale &&
				abs(window.height * scale - displayPixels.height) <= scale
		}
	}
}

/// Debug UI launches share this small timestamp-only payload with the UI runner.
/// Uptime measures lifecycle callbacks; view appearance is not a rendered-frame metric.
struct UILaunchProfile: Codable, Equatable {
	static let traceEnvironmentKey = "INTROSPECTIVE_UI_LAUNCH_TRACE_ID"
	static let profilingDirectory = "Library/Caches/IntrospectiveUILaunchProfiles"
	static let schemaVersion = 1

	enum Stage: String, CaseIterable {
		// Optional diagnostics; readiness still depends only on the existing callbacks.
		case processEntry = "process_entry"
		case delegateInitialized = "delegate_initialized"
		case willFinishBegin = "will_finish_begin"
		case dependenciesReady = "dependencies_ready"
		case preferencesReady = "preferences_ready"
		case fixturesReady = "fixtures_ready"
		case willFinishEnd = "will_finish_end"
		case didFinishBegin = "did_finish_begin"
		case didFinishEnd = "did_finish_end"
		case appActive = "app_active"
		case initialViewAppeared = "initial_view_appeared"
	}

	let schema: Int
	let traceID: String
	private(set) var stages: [String: TimeInterval]

	init(traceID: UUID) {
		schema = Self.schemaVersion
		self.traceID = traceID.uuidString
		stages = [:]
	}

	/// All three callbacks must have occurred, in whichever order UIKit delivers them.
	var readyUptime: TimeInterval? {
		guard let finished = stages[Stage.didFinishEnd.rawValue],
			let active = stages[Stage.appActive.rawValue],
			let appeared = stages[Stage.initialViewAppeared.rawValue] else { return nil }
		return max(finished, active, appeared)
	}

	private enum CodingKeys: String, CodingKey { case schema, traceID, stages }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		schema = try values.decode(Int.self, forKey: .schema)
		traceID = try values.decode(String.self, forKey: .traceID)
		stages = try values.decode([String: TimeInterval].self, forKey: .stages)
		guard schema == Self.schemaVersion, UUID(uuidString: traceID) != nil,
			stages.allSatisfy({ Stage(rawValue: $0.key) != nil && $0.value.isFinite && $0.value >= 0 }) else {
			throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
				debugDescription: "Invalid UI launch profile"))
		}
	}

	fileprivate mutating func record(_ stage: Stage, at uptime: TimeInterval) {
		stages[stage.rawValue] = uptime
	}
}

/// No application dependencies or fixture data enter this recorder. Application
/// call sites are Debug-only and activate it only for explicitly traced UI tests.
final class UILaunchProfileRecorder {
	typealias Clock = () -> TimeInterval
	typealias Writer = (UILaunchProfile) throws -> Void

	private(set) static var current: UILaunchProfileRecorder?

	private let clock: Clock
	private let writer: Writer
	private let writes = DispatchQueue(label: "com.bnova.Introspective.ui-launch-profile")
	private let lock = NSLock()
	private var profile: UILaunchProfile
	private var lastUptime: TimeInterval?

	/// An invalid or absent trace never creates a recorder, reads the clock, or writes a file.
	@discardableResult
	static func activate(environment: [String: String], isUITesting: Bool,
		clock: @escaping Clock = { ProcessInfo.processInfo.systemUptime }, writer: Writer? = nil
	) -> UILaunchProfileRecorder? {
		guard isUITesting, let text = environment[UILaunchProfile.traceEnvironmentKey],
			let traceID = UUID(uuidString: text) else {
			current = nil
			return nil
		}
		let directory = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
			.appendingPathComponent(UILaunchProfile.profilingDirectory, isDirectory: true)
		let recorder = UILaunchProfileRecorder(traceID: traceID, clock: clock,
			writer: writer ?? fileWriter(directory: directory))
		current = recorder
		return recorder
	}

	private init(traceID: UUID, clock: @escaping Clock, writer: @escaping Writer) {
		profile = UILaunchProfile(traceID: traceID)
		self.clock = clock
		self.writer = writer
	}

	var snapshot: UILaunchProfile {
		lock.lock()
		defer { lock.unlock() }
		return profile
	}

	/// Keep the first valid timestamp. Later navigation and foreground callbacks
	/// cannot move the launch endpoints, and a broken injected clock cannot regress them.
	@discardableResult
	func record(_ stage: UILaunchProfile.Stage) -> Bool {
		lock.lock()
		defer { lock.unlock() }
		guard profile.stages[stage.rawValue] == nil else { return false }
		let uptime = clock()
		guard uptime.isFinite, uptime >= 0, lastUptime.map({ uptime >= $0 }) ?? true else { return false }
		profile.record(stage, at: uptime)
		lastUptime = uptime
		if stage == .didFinishEnd || stage == .appActive || stage == .initialViewAppeared {
			let captured = profile
			let writer = self.writer
			// Queue immutable snapshots while holding the lock so writes preserve event order.
			// Never wait for storage on the application or UI launch path.
			writes.async { try? writer(captured) }
		}
		return true
	}

	/// Directory creation and atomic replacement happen only on the writer queue.
	static func fileWriter(directory: URL) -> Writer {
		return { profile in
			let data = try JSONEncoder().encode(profile)
			try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
			let file = directory.appendingPathComponent(profile.traceID).appendingPathExtension("json")
			try data.write(to: file, options: .atomic)
		}
	}
}
