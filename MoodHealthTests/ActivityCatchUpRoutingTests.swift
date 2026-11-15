import XCTest
import Common

final class ActivityCatchUpRoutingTests: XCTestCase {
	func testStoppedTimerRouteReopensReviewWithoutEditingItsEndAgain() throws {
		let suite = "activity-route-tests." + UUID().uuidString
		let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
		defer { defaults.removePersistentDomain(forName: suite) }
		try ActivityCatchUpRouting(defaults: defaults).request(activityID: "stopped-instance", editEndTime: false)
		let reopened = ActivityCatchUpRouting(defaults: try XCTUnwrap(UserDefaults(suiteName: suite)))
		XCTAssertEqual(reopened.takePending(), ActivityCatchUpRoute(activityID: "stopped-instance", editEndTime: false))
		XCTAssertNil(reopened.takePending())
	}

	func testColdLaunchRoutePersistsAcrossRoutingInstancesAndIsConsumedOnce() throws {
		let suite = "activity-route-tests." + UUID().uuidString
		let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
		defer { defaults.removePersistentDomain(forName: suite) }
		try ActivityCatchUpRouting(defaults: defaults).request(activityID: "saved-instance", openNote: true)
		let reopened = ActivityCatchUpRouting(defaults: try XCTUnwrap(UserDefaults(suiteName: suite)))
		XCTAssertEqual(reopened.takePending(), ActivityCatchUpRoute(activityID: "saved-instance", openNote: true))
		XCTAssertNil(reopened.takePending())
	}

	func testReviewRouteDoesNotTurnIntoANoteAndInvalidRequestsCannotReplaceIt() throws {
		let suite = "activity-route-tests." + UUID().uuidString
		let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
		defer { defaults.removePersistentDomain(forName: suite) }
		let routing = ActivityCatchUpRouting(defaults: defaults)
		try routing.request(activityID: "chosen-instance")
		XCTAssertThrowsError(try routing.request(activityID: "", openNote: true))
		XCTAssertEqual(routing.takePending(), ActivityCatchUpRoute(activityID: "chosen-instance"))
		XCTAssertThrowsError(try ActivityCatchUpRouting(defaults: nil).request(activityID: "chosen-instance"))
	}
}
