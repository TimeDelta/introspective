import XCTest
import UIKit
import Common

final class ActivityReminderSettingsUITests: XCTestCase {
	@MainActor private func withScreen(
		settings: ActivityReminderSettings = ActivityReminderSettings(),
		_ body: (ActivityRemindersViewController, ActivityReminderPreferences) throws -> Void
	) throws {
		let suite = "activity-reminder-screen-tests." + UUID().uuidString
		let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
		defer { defaults.removePersistentDomain(forName: suite) }
		let preferences = ActivityReminderPreferences(defaults: defaults)
		try preferences.save(settings: settings)
		let controller = ActivityRemindersViewController(style: .grouped)
		controller.preferences = preferences
		controller.loadViewIfNeeded()
		try body(controller, preferences)
	}

	@MainActor private func toggle(_ controller: ActivityRemindersViewController, enabled: Bool) throws {
		let cell = controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
		let control = try XCTUnwrap(cell.accessoryView as? UISwitch)
		control.isOn = enabled
		control.sendActions(for: .valueChanged)
	}

	@MainActor private func save(_ controller: ActivityRemindersViewController) throws {
		let button = try XCTUnwrap(controller.navigationItem.rightBarButtonItem)
		controller.perform(try XCTUnwrap(button.action))
	}

	@MainActor func testDeniedPermissionDoesNotPersistEnabledStateOrSelectedInterval() throws {
		try withScreen { controller, preferences in
			var authorize: ((Bool, Error?) -> Void)?
			controller.requestAuthorization = { authorize = $0 }
			controller.refreshReminders = { _ in XCTFail("Denied notification permission must not schedule reminders") }
			try toggle(controller, enabled: true)
			controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 1, section: 1))
			try save(controller)
			XCTAssertFalse(controller.tableView.isUserInteractionEnabled)
			XCTAssertEqual(try preferences.settings(), ActivityReminderSettings())
			try XCTUnwrap(authorize)(false, nil)
			let rejected = expectation(description: "Permission denial handled on main")
			DispatchQueue.main.async {
				XCTAssertEqual(try? preferences.settings(), ActivityReminderSettings())
				XCTAssertTrue(controller.tableView.isUserInteractionEnabled)
				XCTAssertTrue(controller.navigationItem.rightBarButtonItem?.isEnabled == true)
				rejected.fulfill()
			}
			wait(for: [rejected], timeout: 5)
		}
	}

	@MainActor func testTurningRemindersOffPersistsWithoutAskingNotificationPermission() throws {
		var initial = ActivityReminderSettings(); initial.enabled = true; initial.intervalMinutes = 60
		try withScreen(settings: initial) { controller, preferences in
			controller.requestAuthorization = { _ in XCTFail("Turning reminders off must not request notification permission") }
			var refreshes = 0
			let refreshed = expectation(description: "Disabled plan reconciled")
			controller.refreshReminders = { completion in
				refreshes += 1
				XCTAssertFalse((try? preferences.settings().enabled) ?? true)
				completion(nil)
				DispatchQueue.main.async { refreshed.fulfill() }
			}
			try toggle(controller, enabled: false)
			controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
			try save(controller)
			wait(for: [refreshed], timeout: 5)
			let saved = try preferences.settings()
			XCTAssertFalse(saved.enabled)
			XCTAssertEqual(saved.intervalMinutes, 30)
			XCTAssertEqual(refreshes, 1)
			XCTAssertTrue(controller.tableView.isUserInteractionEnabled)
		}
	}

	@MainActor func testInFlightPermissionAndSchedulingFreezeEditsAndDuplicateSaves() throws {
		try withScreen { controller, preferences in
			var authorize: ((Bool, Error?) -> Void)?
			var finishRefresh: ((Error?) -> Void)?
			var authorizationRequests = 0, refreshes = 0
			controller.requestAuthorization = { authorizationRequests += 1; authorize = $0 }
			let scheduling = expectation(description: "Permission granted and selected settings persisted")
			controller.refreshReminders = { completion in
				refreshes += 1; finishRefresh = completion; scheduling.fulfill()
			}
			try toggle(controller, enabled: true)
			controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 1, section: 1))
			try save(controller)
			try save(controller)
			controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 3, section: 1))
			XCTAssertEqual(authorizationRequests, 1)
			XCTAssertFalse(controller.tableView.isUserInteractionEnabled)
			XCTAssertFalse(controller.navigationItem.rightBarButtonItem?.isEnabled ?? true)
			try XCTUnwrap(authorize)(true, nil)
			wait(for: [scheduling], timeout: 5)
			try save(controller)
			XCTAssertEqual(refreshes, 1)
			XCTAssertFalse(controller.tableView.isUserInteractionEnabled)
			let saved = try preferences.settings()
			XCTAssertTrue(saved.enabled)
			XCTAssertEqual(saved.intervalMinutes, 60, "An interval tap while permission was pending must not alter the submitted settings")
			try XCTUnwrap(finishRefresh)(nil)
			let finished = expectation(description: "Save controls restored after scheduling")
			DispatchQueue.main.async {
				XCTAssertTrue(controller.tableView.isUserInteractionEnabled)
				XCTAssertTrue(controller.navigationItem.rightBarButtonItem?.isEnabled == true)
				finished.fulfill()
			}
			wait(for: [finished], timeout: 5)
		}
	}
}
