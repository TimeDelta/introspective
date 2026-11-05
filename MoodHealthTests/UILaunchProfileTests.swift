import Foundation
import XCTest

final class UILaunchProfileTests: XCTestCase {
	override func tearDown() {
		UILaunchProfileRecorder.activate(environment: [:], isUITesting: false)
		super.tearDown()
	}

	private func clock(start: TimeInterval = 100) -> UILaunchProfileRecorder.Clock {
		var next = start
		return { defer { next += 1 }; return next }
	}

	private func recorder(traceID: UUID = UUID(), clock: @escaping UILaunchProfileRecorder.Clock,
		writer: @escaping UILaunchProfileRecorder.Writer = { _ in }
	) throws -> UILaunchProfileRecorder {
		try XCTUnwrap(UILaunchProfileRecorder.activate(
			environment: [UILaunchProfile.traceEnvironmentKey: traceID.uuidString],
			isUITesting: true, clock: clock, writer: writer))
	}

	private func temporaryDirectory() -> URL {
		let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
		addTeardownBlock { try? FileManager.default.removeItem(at: directory) }
		return directory
	}

	func testInactiveAndInvalidTraceNeverCreateAProfileReadTheClockOrWriteFiles() {
		let directory = temporaryDirectory()
		var clockReads = 0
		let cases: [(Bool, [String: String])] = [
			(false, [UILaunchProfile.traceEnvironmentKey: UUID().uuidString]),
			(true, [:]),
			(true, [UILaunchProfile.traceEnvironmentKey: ""]),
			(true, [UILaunchProfile.traceEnvironmentKey: "not-a-uuid"]),
			(true, [UILaunchProfile.traceEnvironmentKey: "../" + UUID().uuidString]),
		]
		for (enabled, environment) in cases {
			XCTAssertNil(UILaunchProfileRecorder.activate(environment: environment, isUITesting: enabled,
				clock: { clockReads += 1; return 0 }, writer: UILaunchProfileRecorder.fileWriter(directory: directory)))
			XCTAssertNil(UILaunchProfileRecorder.current)
		}
		XCTAssertEqual(clockReads, 0)
		XCTAssertFalse(FileManager.default.fileExists(atPath: directory.path))
	}

	func testOnlyFiniteNonnegativeNondecreasingClockReadingsBecomeStages() throws {
		var values: [TimeInterval] = [.nan, -.infinity, .infinity, -1, 0, -1, 0, 1]
		let profile = try recorder(clock: { values.removeFirst() })
		for _ in 0..<4 { XCTAssertFalse(profile.record(.willFinishBegin)) }
		XCTAssertTrue(profile.record(.willFinishBegin))
		XCTAssertFalse(profile.record(.dependenciesReady))
		XCTAssertTrue(profile.record(.dependenciesReady))
		XCTAssertTrue(profile.record(.preferencesReady))
		XCTAssertEqual(profile.snapshot.stages, ["will_finish_begin": 0, "dependencies_ready": 0, "preferences_ready": 1])
	}

	func testFirstLifecycleEventsSurviveLaterForegroundAndNavigationCallbacks() throws {
		let profile = try recorder(clock: clock())
		for stage in UILaunchProfile.Stage.allCases { XCTAssertTrue(profile.record(stage)) }
		let launch = profile.snapshot
		XCTAssertFalse(profile.record(.appActive))
		XCTAssertFalse(profile.record(.initialViewAppeared))
		XCTAssertFalse(profile.record(.didFinishEnd))
		XCTAssertEqual(profile.snapshot, launch)
		XCTAssertEqual(launch.stages.count, UILaunchProfile.Stage.allCases.count)
		for (index, stage) in UILaunchProfile.Stage.allCases.enumerated() {
			XCTAssertEqual(launch.stages[stage.rawValue], 100 + Double(index))
		}
	}

	func testEarlyStagesKeepStableNamesOrderAndSchemaOneRoundTrip() throws {
		XCTAssertEqual(UILaunchProfile.Stage.processEntry.rawValue, "process_entry")
		XCTAssertEqual(UILaunchProfile.Stage.delegateInitialized.rawValue, "delegate_initialized")
		XCTAssertEqual(UILaunchProfile.Stage(rawValue: "process_entry"), .processEntry)
		XCTAssertEqual(UILaunchProfile.Stage(rawValue: "delegate_initialized"), .delegateInitialized)
		let profile = try recorder(clock: clock())
		XCTAssertTrue(profile.record(.processEntry))
		XCTAssertTrue(profile.record(.delegateInitialized))
		XCTAssertTrue(profile.record(.willFinishBegin))
		XCTAssertFalse(profile.record(.processEntry))
		XCTAssertFalse(profile.record(.delegateInitialized))
		XCTAssertEqual(profile.snapshot.stages,
			["process_entry": 100, "delegate_initialized": 101, "will_finish_begin": 102])
		XCTAssertNil(profile.snapshot.readyUptime)
		let encoded = try JSONEncoder().encode(profile.snapshot)
		let decoded = try JSONDecoder().decode(UILaunchProfile.self, from: encoded)
		XCTAssertEqual(decoded.schema, 1)
		XCTAssertEqual(decoded, profile.snapshot)
	}

	func testSchemaOneProfilesWithoutEarlyStagesStillDecodeWithTheSameReadiness() throws {
		let oldStages: [String: TimeInterval] = [
			"will_finish_begin": 100, "dependencies_ready": 101, "preferences_ready": 102,
			"fixtures_ready": 103, "will_finish_end": 104, "did_finish_begin": 105,
			"did_finish_end": 106, "app_active": 107, "initial_view_appeared": 108,
		]
		let payload: [String: Any] = ["schema": 1, "traceID": UUID().uuidString, "stages": oldStages]
		let data = try JSONSerialization.data(withJSONObject: payload)
		let profile = try JSONDecoder().decode(UILaunchProfile.self, from: data)
		XCTAssertEqual(profile.stages, oldStages)
		XCTAssertNil(profile.stages[UILaunchProfile.Stage.processEntry.rawValue])
		XCTAssertNil(profile.stages[UILaunchProfile.Stage.delegateInitialized.rawValue])
		XCTAssertEqual(profile.readyUptime, 108)
	}

	func testEarlyStagesLeaveReadinessCallbacksUnchanged() throws {
		let profile = try recorder(clock: clock())
		profile.record(.processEntry)
		profile.record(.delegateInitialized)
		XCTAssertNil(profile.snapshot.readyUptime)
		profile.record(.didFinishEnd)
		XCTAssertNil(profile.snapshot.readyUptime)
		profile.record(.appActive)
		XCTAssertNil(profile.snapshot.readyUptime)
		profile.record(.initialViewAppeared)
		XCTAssertEqual(profile.snapshot.readyUptime, 104)
	}

	func testReadyEndpointWaitsForAllCallbacksAndUsesTheLatestInEitherOrder() throws {
		let orders: [[UILaunchProfile.Stage]] = [
			[.didFinishEnd, .appActive, .initialViewAppeared],
			[.didFinishEnd, .initialViewAppeared, .appActive],
			[.appActive, .initialViewAppeared, .didFinishEnd],
			[.initialViewAppeared, .appActive, .didFinishEnd],
		]
		for order in orders {
			let profile = try recorder(clock: clock())
			XCTAssertNil(profile.snapshot.readyUptime)
			for stage in order.dropLast() {
				profile.record(stage)
				XCTAssertNil(profile.snapshot.readyUptime)
			}
			profile.record(try XCTUnwrap(order.last))
			XCTAssertEqual(profile.snapshot.readyUptime, 102)
		}
	}

	func testNewActivationHasFreshStagesAndDoesNotReusePreviousProcessTrace() throws {
		let first = try recorder(clock: clock())
		first.record(.willFinishBegin)
		first.record(.didFinishEnd)
		let secondID = UUID()
		let second = try recorder(traceID: secondID, clock: clock())
		XCTAssertTrue(second.snapshot.stages.isEmpty)
		XCTAssertEqual(second.snapshot.traceID, secondID.uuidString)
		XCTAssertNotEqual(second.snapshot.traceID, first.snapshot.traceID)
	}

	func testEncodedSnapshotContainsOnlySchemaOpaqueTraceAndKnownTimestampStages() throws {
		let id = UUID()
		let secret = "fixture note and producer stamp must stay out of profiles"
		let profile = try XCTUnwrap(UILaunchProfileRecorder.activate(environment: [
			UILaunchProfile.traceEnvironmentKey: id.uuidString,
			UITestFixtures.environmentKey: secret,
			"INTROSPECTIVE_UI_FIXTURE_PRODUCER": secret,
		], isUITesting: true, clock: clock(), writer: { _ in }))
		for stage in UILaunchProfile.Stage.allCases { profile.record(stage) }
		let encoded = try JSONEncoder().encode(profile.snapshot)
		let json = try XCTUnwrap(JSONSerialization.jsonObject(with: encoded) as? [String: Any])
		XCTAssertEqual(Set(json.keys), ["schema", "traceID", "stages"])
		XCTAssertEqual(json["schema"] as? Int, 1)
		XCTAssertEqual(json["traceID"] as? String, id.uuidString)
		let stages = try XCTUnwrap(json["stages"] as? [String: Double])
		XCTAssertEqual(Set(stages.keys), Set(UILaunchProfile.Stage.allCases.map { $0.rawValue }))
		XCTAssertFalse(String(decoding: encoded, as: UTF8.self).contains(secret))
		XCTAssertEqual(try JSONDecoder().decode(UILaunchProfile.self, from: encoded), profile.snapshot)
	}

	func testDecoderRejectsUnsupportedSchemaTraceAndStagePayloads() throws {
		let valid: [String: Any] = ["schema": 1, "traceID": UUID().uuidString, "stages": ["will_finish_begin": 0]]
		var invalidSchema = valid
		invalidSchema["schema"] = 2
		var invalidTrace = valid
		invalidTrace["traceID"] = "not-a-uuid"
		var invalidStage = valid
		invalidStage["stages"] = ["record_note": 0]
		var invalidTime = valid
		invalidTime["stages"] = ["will_finish_begin": -1]
		var invalidProcessTime = valid
		invalidProcessTime["stages"] = ["process_entry": -1]
		var invalidDelegateTime = valid
		invalidDelegateTime["stages"] = ["delegate_initialized": -1]
		for invalid in [invalidSchema, invalidTrace, invalidStage, invalidTime, invalidProcessTime, invalidDelegateTime] {
			let data = try JSONSerialization.data(withJSONObject: invalid)
			XCTAssertThrowsError(try JSONDecoder().decode(UILaunchProfile.self, from: data))
		}
	}

	func testSerialWriterCapturesPartialThenLatestSnapshotWithoutBlockingCallbacks() throws {
		let started = expectation(description: "Writer started")
		let completed = expectation(description: "All snapshots written")
		completed.expectedFulfillmentCount = 3
		completed.assertForOverFulfill = true
		let release = DispatchSemaphore(value: 0)
		let snapshots = LockedSnapshots()
		let profile = try recorder(clock: clock(), writer: { snapshot in
			if snapshot.stages.count == 4 {
				started.fulfill()
				XCTAssertEqual(release.wait(timeout: .now() + 5), .success,
					"Snapshot storage must not block lifecycle callbacks")
			}
			snapshots.append(snapshot)
			completed.fulfill()
		})
		profile.record(.processEntry)
		profile.record(.delegateInitialized)
		profile.record(.willFinishBegin)
		profile.record(.didFinishEnd)
		wait(for: [started], timeout: 2)
		// These return while the first write is blocked, then enqueue behind it.
		profile.record(.initialViewAppeared)
		profile.record(.appActive)
		release.signal()
		wait(for: [completed], timeout: 2)
		let captured = snapshots.values
		XCTAssertEqual(captured.map { $0.stages.count }, [4, 5, 6])
		guard captured.count == 3 else { return }
		XCTAssertNil(captured[0].readyUptime)
		XCTAssertNil(captured[1].readyUptime)
		XCTAssertEqual(captured[2], profile.snapshot)
	}

	func testAtomicFilePersistenceEndsWithTheLatestProfileAndNoExtraFiles() throws {
		let directory = temporaryDirectory()
		let id = UUID()
		let completed = expectation(description: "All atomic snapshots written")
		completed.expectedFulfillmentCount = 3
		let fileWriter = UILaunchProfileRecorder.fileWriter(directory: directory)
		let profile = try recorder(traceID: id, clock: clock(), writer: { snapshot in
			try fileWriter(snapshot)
			completed.fulfill()
		})
		for stage in UILaunchProfile.Stage.allCases { profile.record(stage) }
		wait(for: [completed], timeout: 3)
		XCTAssertEqual(try FileManager.default.contentsOfDirectory(atPath: directory.path), [id.uuidString + ".json"])
		let data = try Data(contentsOf: directory.appendingPathComponent(id.uuidString + ".json"))
		XCTAssertEqual(try JSONDecoder().decode(UILaunchProfile.self, from: data), profile.snapshot)
	}

	func testFailedWritesCannotInterruptStartupOrPreventLaterSnapshots() throws {
		enum Failure: Error { case storageUnavailable }
		let attempted = expectation(description: "All failing writes attempted")
		attempted.expectedFulfillmentCount = 3
		let profile = try recorder(clock: clock(), writer: { _ in
			attempted.fulfill()
			throw Failure.storageUnavailable
		})
		for stage in UILaunchProfile.Stage.allCases { XCTAssertTrue(profile.record(stage)) }
		wait(for: [attempted], timeout: 2)
		XCTAssertEqual(profile.snapshot.readyUptime, 110)
	}

	private final class LockedSnapshots {
		private let lock = NSLock()
		private var storage: [UILaunchProfile] = []
		func append(_ value: UILaunchProfile) {
			lock.lock()
			defer { lock.unlock() }
			storage.append(value)
		}
		var values: [UILaunchProfile] {
			lock.lock()
			defer { lock.unlock() }
			return storage
		}
	}
}
