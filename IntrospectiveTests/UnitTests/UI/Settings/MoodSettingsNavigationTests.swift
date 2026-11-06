import XCTest
import UIKit
import SwiftyMocky
@testable import Introspective
@testable import Common
@testable import Settings

final class MoodSettingsNavigationTests: UnitTest {
	private var controller: MoodSettingsViewController!
	private var navigation: MoodSettingsNavigationProbe!
	private var settingsRoot: UIViewController!
	private var window: UIWindow!
	private var doneAction: Selector?
	private weak var doneTarget: UIViewController?

	override func setUp() {
		super.setUp()
		Given(mockSettings, .minMood(getter: 0))
		Given(mockSettings, .maxMood(getter: 10))
		Given(mockSettings, .scaleMoodsOnImport(getter: false))
		Given(mockSettings, .discreteMoods(getter: false))
		Given(mockSettings, .changed(.any, willReturn: false))
		Given(mockMoodUiUtil, .valueToString(.value(0), willReturn: "0"))
		Given(mockMoodUiUtil, .valueToString(.value(10), willReturn: "10"))
		Given(mockUiUtil, .setBackButton(for: .any, title: .any, action: .any, willReturn: UIBarButtonItem()))
		Perform(mockUiUtil, .setBackButton(for: .any, title: .any, action: .any, perform: { [weak self] target, _, action in
			self?.doneTarget = target
			self?.doneAction = action
		}))

		controller = MoodSettingsViewController(nibName: nil, bundle: nil)
		controller.minMoodField = UITextField()
		controller.maxMoodField = UITextField()
		controller.scaleMoodsOnImportSwitch = UISwitch()
		controller.useDiscreteMoodsSwitch = UISwitch()
		controller.loadViewIfNeeded()
		let inputs: [UIView] = [controller.minMoodField!, controller.maxMoodField!,
			controller.scaleMoodsOnImportSwitch!, controller.useDiscreteMoodsSwitch!]
		for input in inputs {
			controller.view.addSubview(input)
		}
		settingsRoot = UIViewController()
		settingsRoot.title = "Settings"
		navigation = MoodSettingsNavigationProbe(rootViewController: settingsRoot)
		navigation.setViewControllers([settingsRoot, controller], animated: false)
		if let scene = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first {
			window = UIWindow(windowScene: scene)
		} else {
			window = UIWindow(frame: UIScreen.main.bounds)
		}
		window.frame = UIScreen.main.bounds
		window.windowLevel = UIWindow.Level(rawValue: UIWindow.Level.normal.rawValue + 1)
		window.rootViewController = navigation
		// A visible window supports real alert presentation without replacing the
		// test host's key window or synthesizing keyboard input.
		window.isHidden = false
		window.layoutIfNeeded()
		XCTAssertTrue(controller.view.window === window)
		XCTAssertEqual(navigation.popCount, 0)
	}

	override func tearDown() {
		navigation?.dismiss(animated: false)
		window?.isHidden = true
		window?.rootViewController = nil
		window = nil
		navigation = nil
		settingsRoot = nil
		controller = nil
		doneAction = nil
		mockUiUtil.resetMock()
		super.tearDown()
	}

	func testChangedMinimumKeepsTheEditorUntilTheScalingChoice() throws {
		controller.minMoodField.text = "1"
		Given(mockSettings, .changed(.value(.minMood), willReturn: true))
		try assertScalingChoice(messageIncludes: "new minimum")
		Verify(mockSettings, .once, .setMinMood(.value(1)))
	}

	func testChangedMaximumKeepsTheEditorUntilTheScalingChoice() throws {
		controller.maxMoodField.text = "9"
		Given(mockSettings, .changed(.value(.maxMood), willReturn: true))
		try assertScalingChoice(messageIncludes: "new maximum")
		Verify(mockSettings, .once, .setMaxMood(.value(9)))
	}

	func testChangingBothBoundsPresentsOneChoiceWithoutSavingOrPopping() throws {
		controller.minMoodField.text = "1"
		controller.maxMoodField.text = "9"
		Given(mockSettings, .changed(.value(.minMood), willReturn: true))
		Given(mockSettings, .changed(.value(.maxMood), willReturn: true))
		try assertScalingChoice(messageIncludes: "new minimum and maximum")
	}

	func testUnchangedBoundsSaveAndReturnToSettingsExactlyOnceWithoutAChoice() throws {
		controller.scaleMoodsOnImportSwitch.isOn = true
		controller.useDiscreteMoodsSwitch.isOn = true
		try finishEditing()
		Verify(mockSettings, .once, .save())
		Verify(mockSettings, .once, .setMinMood(.value(0)))
		Verify(mockSettings, .once, .setMaxMood(.value(10)))
		Verify(mockSettings, .once, .setScaleMoodsOnImport(.value(true)))
		Verify(mockSettings, .once, .setDiscreteMoods(.value(true)))
		XCTAssertEqual(navigation.popCount, 1)
		XCTAssertTrue(navigation.topViewController === settingsRoot)
		XCTAssertEqual(navigation.viewControllers.count, 1)
		XCTAssertNil(navigation.presentedViewController)
		XCTAssertNil(controller.presentedViewController)
	}

	func testReversedBoundsShowAnErrorWithoutChangingOrSavingSettings() throws {
		controller.minMoodField.text = "11"
		try assertInvalidInput(title: "Maximum mood must be greater than minimum mood.")
	}

	func testNonnumericMinimumIdentifiesTheInvalidFieldWithoutSaving() throws {
		controller.minMoodField.text = "invalid minimum"
		try assertInvalidInput(title: "Invalid minimum mood", message: "'invalid minimum' is not a number.")
	}

	func testNonnumericMaximumIdentifiesTheInvalidFieldWithoutSaving() throws {
		controller.maxMoodField.text = "invalid maximum"
		try assertInvalidInput(title: "Invalid maximum mood", message: "'invalid maximum' is not a number.")
	}

	private func finishEditing() throws {
		XCTAssertTrue(doneTarget === controller, "Invoke the action registered for this editor's back button")
		let action = try XCTUnwrap(doneAction)
		controller.perform(action)
	}

	private func presentedAlert() throws -> UIAlertController {
		let visible = NSPredicate { _, _ in
			guard let alert = (self.controller.presentedViewController ?? self.navigation.presentedViewController) as? UIAlertController else {
				return false
			}
			return !alert.isBeingPresented && alert.viewIfLoaded?.window != nil
		}
		let expectation = XCTNSPredicateExpectation(predicate: visible, object: nil)
		XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 3), .completed,
			"Mood settings must finish presenting the alert before its choice can be made")
		return try XCTUnwrap((controller.presentedViewController ?? navigation.presentedViewController) as? UIAlertController)
	}

	private func assertScalingChoice(messageIncludes fragment: String,
		file: StaticString = #file, line: UInt = #line) throws {
		try finishEditing()
		let alert = try presentedAlert()
		XCTAssertEqual(alert.title, "Scale existing moods?", file: file, line: line)
		XCTAssertTrue(alert.message?.contains(fragment) == true, file: file, line: line)
		XCTAssertEqual(alert.actions.map { $0.title }, ["Yes", "No"], file: file, line: line)
		XCTAssertEqual(alert.actions.map { $0.style }, [.destructive, .default], file: file, line: line)
		Verify(mockSettings, .never, .save(), file: file, line: line)
		XCTAssertEqual(navigation.popCount, 0, file: file, line: line)
		XCTAssertTrue(navigation.topViewController === controller, file: file, line: line)
		XCTAssertEqual(navigation.viewControllers.count, 2, file: file, line: line)
	}

	private func assertInvalidInput(title: String, message: String? = nil,
		file: StaticString = #file, line: UInt = #line) throws {
		try finishEditing()
		let alert = try presentedAlert()
		XCTAssertEqual(alert.title, title, file: file, line: line)
		if let message = message { XCTAssertEqual(alert.message, message, file: file, line: line) }
		Verify(mockSettings, .never, .setMinMood(.any), file: file, line: line)
		Verify(mockSettings, .never, .setMaxMood(.any), file: file, line: line)
		Verify(mockSettings, .never, .setScaleMoodsOnImport(.any), file: file, line: line)
		Verify(mockSettings, .never, .setDiscreteMoods(.any), file: file, line: line)
		Verify(mockSettings, .never, .save(), file: file, line: line)
		XCTAssertEqual(navigation.popCount, 0, file: file, line: line)
		XCTAssertTrue(navigation.topViewController === controller, file: file, line: line)
	}
}

private final class MoodSettingsNavigationProbe: UINavigationController {
	private(set) var popCount = 0
	override func popViewController(animated: Bool) -> UIViewController? {
		popCount += 1
		return super.popViewController(animated: animated)
	}
}
