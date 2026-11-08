import XCTest
import Foundation
@testable import Samples

final class HealthSpecializedReadLifecycleTests: XCTestCase {
	private var directory: URL!
	override func setUpWithError() throws {
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
	}
	override func tearDownWithError() throws { try FileManager.default.removeItem(at: directory) }
	private var destination: URL { directory.appendingPathComponent("health-record.bin") }

	func testCollectionFailureDiscardsEarlierBatchesAndStopsLateRegisteredQuery() throws {
		var results: [Result<[Int], Error>] = [], stops = 0
		let state = HealthExternalCollectionState<Int> { results.append($0) }
		state.append([1, 2])
		state.fail(NSError(domain: "HealthReadTest", code: 42))
		state.installCancellation { stops += 1 }
		state.append([3]); state.finish(); state.cancel()
		XCTAssertEqual(stops, 1); XCTAssertEqual(results.count, 1)
		XCTAssertThrowsError(try XCTUnwrap(results.first).get()) { XCTAssertEqual(($0 as NSError).code, 42) }
	}

	func testCancelledCollectionSuppressesBufferedAndLateResults() {
		var completions = 0, stops = 0
		let state = HealthExternalCollectionState<Int> { _ in completions += 1 }
		state.append([1]); state.cancel()
		state.installCancellation { stops += 1 }
		XCTAssertFalse(state.append([2]))
		state.finish(); state.fail(NSError(domain: "Late", code: 1)); state.cancel()
		XCTAssertEqual(completions, 0); XCTAssertEqual(stops, 1)
	}

	func testCompletedCollectionKeepsBatchOrderAndDoesNotStopAnAlreadyFinishedQuery() throws {
		var result: Result<[Int], Error>?, completions = 0, stops = 0
		let state = HealthExternalCollectionState<Int> { result = $0; completions += 1 }
		state.append([3, 1]); state.append([2]); state.finish()
		state.installCancellation { stops += 1 }; state.finish(); state.cancel()
		XCTAssertEqual(try XCTUnwrap(result).get(), [3, 1, 2])
		XCTAssertEqual(completions, 1); XCTAssertEqual(stops, 0)
	}

	func testAttachmentPublishesOnlyCompleteOrderedDataWithPrivateFilePermissions() throws {
		let expected = Data([0, 255, 1, 42, 128])
		var result: Result<URL, Error>?, completions = 0, stops = 0
		let state = try HealthAttachmentFileState(destination: destination, expectedBytes: expected.count) {
			result = $0; completions += 1
		}
		state.installCancellation { stops += 1 }
		state.receive(data: expected.prefix(2), error: nil, done: false)
		XCTAssertFalse(FileManager.default.fileExists(atPath: destination.path))
		state.receive(data: expected.suffix(3), error: nil, done: true)
		XCTAssertEqual(try XCTUnwrap(result).get(), destination)
		XCTAssertEqual(try Data(contentsOf: destination), expected)
		let permissions = try FileManager.default.attributesOfItem(atPath: destination.path)[.posixPermissions] as? NSNumber
		XCTAssertEqual(permissions?.intValue, 0o600)
		state.receive(data: Data([99]), error: nil, done: true); state.cancel()
		XCTAssertEqual(completions, 1); XCTAssertEqual(stops, 0)
		XCTAssertEqual(try FileManager.default.contentsOfDirectory(atPath: directory.path), [destination.lastPathComponent])
	}

	func testTruncatedAttachmentDoesNotPublishOrLeavePartialDataAndStopsLateRegisteredDownload() throws {
		var result: Result<URL, Error>?, stops = 0
		let state = try HealthAttachmentFileState(destination: destination, expectedBytes: 5) { result = $0 }
		state.receive(data: Data([1, 2]), error: nil, done: true)
		state.installCancellation { stops += 1 }
		XCTAssertThrowsError(try XCTUnwrap(result).get()) {
			XCTAssertEqual($0 as? HealthExternalReadError, .attachmentIncomplete)
		}
		XCTAssertEqual(stops, 1)
		XCTAssertTrue(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
	}

	func testOversizedAttachmentFailsBeforePublishingAndReleasesTemporaryFile() throws {
		var result: Result<URL, Error>?
		let state = try HealthAttachmentFileState(destination: destination, expectedBytes: 1) { result = $0 }
		state.receive(data: Data([1, 2]), error: nil, done: false)
		XCTAssertThrowsError(try XCTUnwrap(result).get()) {
			XCTAssertEqual($0 as? HealthExternalReadError, .attachmentIncomplete)
		}
		XCTAssertTrue(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
	}

	func testAttachmentCancellationRemovesBufferedDataAndSuppressesLateCompletion() throws {
		var completions = 0, stops = 0
		let state = try HealthAttachmentFileState(destination: destination, expectedBytes: 3) { _ in completions += 1 }
		state.receive(data: Data([1]), error: nil, done: false); state.cancel()
		state.installCancellation { stops += 1 }
		state.receive(data: Data([2, 3]), error: nil, done: true); state.cancel()
		XCTAssertEqual(completions, 0); XCTAssertEqual(stops, 1)
		XCTAssertTrue(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
	}

	func testAttachmentDoesNotOverwriteAnExistingDestinationOrAFileCreatedDuringDownload() throws {
		let original = Data([11, 12])
		try original.write(to: destination)
		XCTAssertThrowsError(try HealthAttachmentFileState(destination: destination, expectedBytes: 1) { _ in }) {
			XCTAssertEqual($0 as? HealthExternalReadError, .attachmentDestinationExists)
		}
		try FileManager.default.removeItem(at: destination)
		var result: Result<URL, Error>?
		let state = try HealthAttachmentFileState(destination: destination, expectedBytes: 1) { result = $0 }
		try original.write(to: destination)
		state.receive(data: Data([99]), error: nil, done: true)
		XCTAssertThrowsError(try XCTUnwrap(result).get())
		XCTAssertEqual(try Data(contentsOf: destination), original)
		XCTAssertEqual(try FileManager.default.contentsOfDirectory(atPath: directory.path), [destination.lastPathComponent])
	}

	func testEmptyAttachmentCompletesWithoutInventedData() throws {
		var result: Result<URL, Error>?
		let state = try HealthAttachmentFileState(destination: destination, expectedBytes: 0) { result = $0 }
		state.receive(data: nil, error: nil, done: true)
		XCTAssertEqual(try Data(contentsOf: XCTUnwrap(result).get()), Data())
	}

	func testInvalidAttachmentInputDoesNotCreateFiles() throws {
		XCTAssertThrowsError(try HealthAttachmentFileState(destination: URL(string: "https://example.invalid/health")!, expectedBytes: 1) { _ in }) {
			XCTAssertEqual($0 as? HealthExternalReadError, .invalidAttachmentDestination)
		}
		XCTAssertThrowsError(try HealthAttachmentFileState(destination: destination, expectedBytes: -1) { _ in }) {
			XCTAssertEqual($0 as? HealthExternalReadError, .attachmentIncomplete)
		}
		XCTAssertTrue(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
	}
}
