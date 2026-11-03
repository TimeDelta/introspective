import XCTest
import Foundation
import Common

final class PinnedQueryPreferencesTests: XCTestCase {
	private var suite: String!
	private var defaults: UserDefaults!
	private var subject: PinnedQueryPreferences!
	private let key = "pinnedSavedQueries.v1"

	override func setUp() {
		super.setUp()
		suite = "PinnedQueryPreferencesTests." + UUID().uuidString
		defaults = UserDefaults(suiteName: suite)!
		subject = PinnedQueryPreferences(defaults: defaults)
	}

	override func tearDown() {
		defaults.removePersistentDomain(forName: suite)
		subject = nil; defaults = nil; suite = nil
		super.tearDown()
	}

	private func reference(_ number: Int, name: String? = nil) -> PinnedQueryReference {
		PinnedQueryReference(id: "x-coredata://A89E6D85-954D-4D3A-B80D-0241E91B6549/Query/p\(number)",
			lastKnownName: name ?? "Query \(number)")
	}

	func testNewDashboardHasNoPinsAndRoundTripPreservesIdentityNamesAndOrder() throws {
		XCTAssertEqual(try subject.pins(), [])
		let values = [reference(3, name: "Café moods"), reference(1, name: "Exercise / weekends"), reference(2)]
		try subject.save(pins: values)
		let reopened = PinnedQueryPreferences(defaults: UserDefaults(suiteName: suite)!)
		XCTAssertEqual(try reopened.pins(), values)
	}

	func testPinningARenamedQueryUpdatesFallbackWithoutMovingOrDuplicatingIt() throws {
		let first = reference(1), second = reference(2)
		try subject.pin(first); try subject.pin(second)
		let renamed = reference(1, name: "A new query name")
		try subject.pin(renamed)
		XCTAssertEqual(try subject.pins(), [renamed, second])
		XCTAssertEqual(first.lastKnownName, "Query 1", "Updating a pin does not rewrite the original reference")
	}

	func testUnpinKeepsOtherIdentitiesInOrderAndUnknownIdentityIsANoOp() throws {
		let values = [reference(1), reference(2), reference(3)]
		try subject.save(pins: values)
		try subject.unpin(id: values[1].id)
		try subject.unpin(id: reference(99).id)
		XCTAssertEqual(try subject.pins(), [values[0], values[2]])
		XCTAssertEqual(try PinnedQueryPreferences(defaults: defaults).pins(), [values[0], values[2]])
	}

	func testMoveUsesFinalRowIndexInBothDirectionsAndPersists() throws {
		let values = [reference(1), reference(2), reference(3)]
		try subject.save(pins: values)
		try subject.move(from: 0, to: 2)
		XCTAssertEqual(try subject.pins(), [values[1], values[2], values[0]])
		try subject.move(from: 2, to: 0)
		try subject.move(from: 1, to: 1)
		XCTAssertEqual(try PinnedQueryPreferences(defaults: defaults).pins(), values)
	}

	func testInvalidMovesLeaveThePersistedOrderIntact() throws {
		XCTAssertThrowsError(try subject.move(from: 0, to: 0))
		let values = [reference(1), reference(2)]
		try subject.save(pins: values)
		let stored = try XCTUnwrap(defaults.data(forKey: key))
		for move in [(-1, 0), (0, -1), (2, 0), (0, 2)] {
			XCTAssertThrowsError(try subject.move(from: move.0, to: move.1))
			XCTAssertEqual(defaults.data(forKey: key), stored)
			XCTAssertEqual(try subject.pins(), values)
		}
	}

	func testFullListCanRenameAnExistingPinButCannotAppendAnother() throws {
		let values = (1...PinnedQueryPreferences.maximumPins).map { reference($0) }
		try subject.save(pins: values)
		let renamed = reference(1, name: "Renamed while full")
		try subject.pin(renamed)
		let stored = try XCTUnwrap(defaults.data(forKey: key))
		XCTAssertThrowsError(try subject.pin(reference(99)))
		XCTAssertEqual(defaults.data(forKey: key), stored)
		XCTAssertEqual(try subject.pins(), [renamed] + Array(values.dropFirst()))
	}

	func testInvalidReplacementIsAtomicForDuplicateMalformedAndOversizedInputs() throws {
		let original = [reference(1)]
		try subject.save(pins: original)
		let stored = try XCTUnwrap(defaults.data(forKey: key))
		var invalid = [[reference(1), reference(1, name: "Duplicate identity")],
			(1...(PinnedQueryPreferences.maximumPins + 1)).map { reference($0) },
			[reference(2, name: " \n\t")],
			[reference(2, name: String(repeating: "N", count: PinnedQueryPreferences.maximumNameLength + 1))]]
		for identity in ["", "not a URI", "https://example.com/Query/p1", "x-coredata:///Query/t1", "x-coredata://store",
			"x-coredata://store/Query/p1?another=record", "x-coredata://store/Query/p1#fragment"] {
			invalid.append([PinnedQueryReference(id: identity, lastKnownName: "Invalid")])
		}
		for values in invalid {
			XCTAssertThrowsError(try subject.save(pins: values))
			XCTAssertEqual(defaults.data(forKey: key), stored)
			XCTAssertEqual(try subject.pins(), original)
		}
	}

	func testCorruptStorageIsReportedAndNeverSilentlyReplacedWithAnEmptyList() throws {
		let corruptValues: [Any] = ["not encoded data", Data("invalid JSON".utf8),
			try JSONEncoder().encode([reference(1), reference(1)])]
		for stored in corruptValues {
			defaults.set(stored, forKey: key)
			XCTAssertThrowsError(try subject.pins())
			XCTAssertThrowsError(try subject.pin(reference(2)))
			XCTAssertThrowsError(try subject.unpin(id: reference(1).id))
			if let data = stored as? Data { XCTAssertEqual(defaults.data(forKey: key), data) }
			else { XCTAssertEqual(defaults.string(forKey: key), stored as? String) }
		}
	}

	func testIndependentDefaultsSuitesDoNotSharePins() throws {
		let otherSuite = "PinnedQueryPreferencesTests." + UUID().uuidString
		let otherDefaults = UserDefaults(suiteName: otherSuite)!
		defer { otherDefaults.removePersistentDomain(forName: otherSuite) }
		let other = PinnedQueryPreferences(defaults: otherDefaults)
		try subject.pin(reference(1))
		XCTAssertEqual(try other.pins(), [])
		try other.pin(reference(2))
		XCTAssertEqual(try subject.pins(), [reference(1)])
		XCTAssertEqual(try other.pins(), [reference(2)])
	}
}
