//
//  SelectDateViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/24/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import SwiftDate
@testable import Introspective

final class SelectDateViewControllerUnitTests: UnitTest {

	private final var coachMarksController: CoachMarksControllerProtocolMock!

	private final var datePicker: UIDatePicker!
	private final var lastButton: UIBarButtonItem!

	private final var controller: SelectDateViewController!

	private final let timeUnits = [
		(title: "Months", units: { (amount: Int) -> DateComponents in return amount.months }),
		(title: "Weeks", units: { (amount: Int) -> DateComponents in return amount.weeks }),
		(title: "Days", units: { (amount: Int) -> DateComponents in return amount.days }),
		(title: "Hours", units: { (amount: Int) -> DateComponents in return amount.hours }),
		(title: "Minutes", units: { (amount: Int) -> DateComponents in return amount.minutes }),
		(title: "Seconds", units: { (amount: Int) -> DateComponents in return amount.seconds }),
	]

	final override func setUp() {
		super.setUp()

		coachMarksController = CoachMarksControllerProtocolMock()
		Given(mockCoachMarkFactory, .controller(willReturn: coachMarksController))

		datePicker = UIDatePicker()
		lastButton = UIBarButtonItem()

		let storyboard = UIStoryboard(name: "Util", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "datePicker") as! SelectDateViewController)
		controller.datePicker = datePicker
		controller.lastButton = lastButton
	}

	// MARK: - viewDidLoad

	func testGivenInitialDate_viewDidLoad_setsDatePickerToInitialDate() {
		// given
		let initialDate = Date() - 2.days
		controller.initialDate = initialDate

		// when
		controller.viewDidLoad()

		// then
		XCTAssertEqual(datePicker.date, initialDate)
	}

	func testGivenEarliestPossibleDate_viewDidLoad_setsDatePickerMinimumDate() {
		// given
		let earliestPossibleDate = Date() - 2.days
		controller.earliestPossibleDate = earliestPossibleDate

		// when
		controller.viewDidLoad()

		// then
		XCTAssertEqual(datePicker.minimumDate, earliestPossibleDate)
	}

	func testGivenNoEarliestPossibleDate_viewDidLoad_leavesDatePickerMinimumDateNil() {
		// when
		controller.viewDidLoad()

		// then
		XCTAssertNil(datePicker.minimumDate)
	}

	func testGivenLatestPossibleDate_viewDidLoad_setsDatePickerMaximumDate() {
		// given
		let latestPossibleDate = Date() - 2.days
		controller.latestPossibleDate = latestPossibleDate

		// when
		controller.viewDidLoad()

		// then
		XCTAssertEqual(datePicker.maximumDate, latestPossibleDate)
	}

	func testGivenNoLatestPossibleDate_viewDidLoad_leavesDatePickerMaximumDateNil() {
		// when
		controller.viewDidLoad()

		// then
		XCTAssertNil(datePicker.maximumDate)
	}

	func testGivenDateOnlyMode_viewDidLoad_setsDateOnlyMode() {
		// given
		controller.datePickerMode = .date

		// when
		controller.viewDidLoad()

		// then
		XCTAssertEqual(datePicker.datePickerMode, .date)
	}

	func testGivenNonNilLastDate_viewDidLoad_enablesLastButton() {
		// given
		controller.lastDate = Date()

		// when
		controller.viewDidLoad()

		// then
		XCTAssert(lastButton.isEnabled)
	}

	func testGivenNilLastDate_viewDidLoad_disablesLastButton() {
		// given
		controller.lastDate = nil

		// when
		controller.viewDidLoad()

		// then
		XCTAssertFalse(lastButton.isEnabled)
	}

	// MARK: - viewDidAppear

	func testGivenInstructionsPreviouslyShown_viewDidAppear_doesNotShowInstructions() {
		// given
		Given(mockUserDefaultsUtil, .bool(forKey: .value(.selectDateViewInstructionsShown), willReturn: true))

		// when
		controller.viewDidAppear(true)

		// then
		Verify(coachMarksController, .never, .start(in: .any))
	}

	func testGivenInstructionsNotPreviouslyShown_viewDidAppear_showsInstructions() {
		// given
		Given(mockUserDefaultsUtil, .bool(forKey: .value(.selectDateViewInstructionsShown), willReturn: false))

		// when
		controller.viewDidAppear(true)

		// then
		Verify(coachMarksController, .once, .start(in: .any))
	}

	// MARK: - viewWillDisappear

	func testGivenInstructionsCurrentlyShowing_viewDidAppear_immediatelyStopsInstructions() {
		// given
		Given(mockUserDefaultsUtil, .bool(forKey: .value(.selectDateViewInstructionsShown), willReturn: false))

		// when
		controller.viewWillDisappear(true)

		// then
		Verify(coachMarksController, .stop(immediately: .value(true)))
	}

	// MARK: - lastButtonPressed

	func testGivenLastDate_lastButtonPressed_setsDateToLastDate() {
		// given
		let lastDate = Date()
		controller.lastDate = lastDate

		// when
		controller.lastButtonPressed(lastButton)

		// then
		XCTAssertEqual(datePicker.date, lastDate)
	}

	func testGivenNilLastDate_lastButtonPressed_doesNotChangeTheDate() {
		// given
		let originalDate = Date()
		datePicker.setDate(originalDate, animated: false)

		// when
		controller.lastButtonPressed(lastButton)

		// then
		XCTAssertEqual(datePicker.date, originalDate)
	}

	// MARK: - decrementByThirtyButtonPressed

	func testGivenTap_decrementByThirtyButtonPressed_decrementsDateByThirtyMinutes() {
		// given
		let uiEvent = getUiEventWithTapCount(1)
		let originalDate = Date()
		datePicker.setDate(originalDate, animated: false)

		// when
		controller.decrementByThirtyButtonPressed(sender: self, forEvent: uiEvent)

		// then
		XCTAssertEqual(datePicker.date, originalDate - 30.minutes)
	}

	func testGivenLongPressAndUserChoosesOption_decrementByThirtyButtonPressed_decrementsDateByThirtyAssociatedTimeUnits() throws {
		for unit in timeUnits {
			// given
			let uiEvent = getUiEventWithTapCount(0)
			let originalDate = Date()
			datePicker.setDate(originalDate, animated: false)

			controller.decrementByThirtyButtonPressed(sender: self, forEvent: uiEvent)
			let actionSheetCaptor = ArgumentCaptor<UIViewController>()
			Verify(mockUiUtil, .present(.value(controller), actionSheetCaptor.capture(), animated: .any, completion: .any))
			guard let actionSheet = actionSheetCaptor.value as? UIAlertController else {
				XCTFail("No action sheet presented")
				return
			}

			// when
			try actionSheet.tapButton(withTitle: unit.title)

			// then
			XCTAssertEqual(datePicker.date, originalDate - unit.units(30))
		}
	}

	func testGivenLongPressAndUserChoosesCancel_decrementByThirtyButtonPressed_doesNotChangeDate() throws {
		// given
		let uiEvent = getUiEventWithTapCount(0)
		let originalDate = Date()
		datePicker.setDate(originalDate, animated: false)

		controller.decrementByThirtyButtonPressed(sender: self, forEvent: uiEvent)
		let actionSheetCaptor = ArgumentCaptor<UIViewController>()
		Verify(mockUiUtil, .present(.value(controller), actionSheetCaptor.capture(), animated: .any, completion: .any))
		guard let actionSheet = actionSheetCaptor.value as? UIAlertController else {
			XCTFail("No action sheet presented")
			return
		}

		// when
		try actionSheet.tapButton(withTitle: "Cancel")

		// then
		XCTAssertEqual(datePicker.date, originalDate)
	}

	// MARK: - decrementByFifteenButtonPressed

	func testGivenTap_decrementByFifteenButtonPressed_decrementsDateByFifteenMinutes() {
		// given
		let uiEvent = getUiEventWithTapCount(1)
		let originalDate = Date()
		datePicker.setDate(originalDate, animated: false)

		// when
		controller.decrementByFifteenButtonPressed(sender: self, forEvent: uiEvent)

		// then
		XCTAssertEqual(datePicker.date, originalDate - 15.minutes)
	}

	func testGivenLongPressAndUserChoosesOption_decrementByFifteenButtonPressed_decrementsDateByFifteenAssociatedTimeUnits() throws {
		for unit in timeUnits {
			// given
			let uiEvent = getUiEventWithTapCount(0)
			let originalDate = Date()
			datePicker.setDate(originalDate, animated: false)

			controller.decrementByFifteenButtonPressed(sender: self, forEvent: uiEvent)
			let actionSheetCaptor = ArgumentCaptor<UIViewController>()
			Verify(mockUiUtil, .present(.value(controller), actionSheetCaptor.capture(), animated: .any, completion: .any))
			guard let actionSheet = actionSheetCaptor.value as? UIAlertController else {
				XCTFail("No action sheet presented")
				return
			}

			// when
			try actionSheet.tapButton(withTitle: unit.title)

			// then
			XCTAssertEqual(datePicker.date, originalDate - unit.units(15))
		}
	}

	func testGivenLongPressAndUserChoosesCancel_decrementByFifteenButtonPressed_doesNotChangeDate() throws {
		// given
		let uiEvent = getUiEventWithTapCount(0)
		let originalDate = Date()
		datePicker.setDate(originalDate, animated: false)

		controller.decrementByFifteenButtonPressed(sender: self, forEvent: uiEvent)
		let actionSheetCaptor = ArgumentCaptor<UIViewController>()
		Verify(mockUiUtil, .present(.value(controller), actionSheetCaptor.capture(), animated: .any, completion: .any))
		guard let actionSheet = actionSheetCaptor.value as? UIAlertController else {
			XCTFail("No action sheet presented")
			return
		}

		// when
		try actionSheet.tapButton(withTitle: "Cancel")

		// then
		XCTAssertEqual(datePicker.date, originalDate)
	}

	// MARK: - incrementByFifteenButtonPressed

	func testGivenTap_incrementByFifteenButtonPressed_decrementsDateByFifteenMinutes() {
		// given
		let uiEvent = getUiEventWithTapCount(1)
		let originalDate = Date()
		datePicker.setDate(originalDate, animated: false)

		// when
		controller.incrementByFifteenButtonPressed(sender: self, forEvent: uiEvent)

		// then
		XCTAssertEqual(datePicker.date, originalDate + 15.minutes)
	}

	func testGivenLongPressAndUserChoosesOption_incrementByFifteenButtonPressed_decrementsDateByFifteenAssociatedTimeUnits() throws {
		for unit in timeUnits {
			// given
			let uiEvent = getUiEventWithTapCount(0)
			let originalDate = Date()
			datePicker.setDate(originalDate, animated: false)

			controller.incrementByFifteenButtonPressed(sender: self, forEvent: uiEvent)
			let actionSheetCaptor = ArgumentCaptor<UIViewController>()
			Verify(mockUiUtil, .present(.value(controller), actionSheetCaptor.capture(), animated: .any, completion: .any))
			guard let actionSheet = actionSheetCaptor.value as? UIAlertController else {
				XCTFail("No action sheet presented")
				return
			}

			// when
			try actionSheet.tapButton(withTitle: unit.title)

			// then
			XCTAssertEqual(datePicker.date, originalDate + unit.units(15))
		}
	}

	func testGivenLongPressAndUserChoosesCancel_incrementByFifteenButtonPressed_doesNotChangeDate() throws {
		// given
		let uiEvent = getUiEventWithTapCount(0)
		let originalDate = Date()
		datePicker.setDate(originalDate, animated: false)

		controller.incrementByFifteenButtonPressed(sender: self, forEvent: uiEvent)
		let actionSheetCaptor = ArgumentCaptor<UIViewController>()
		Verify(mockUiUtil, .present(.value(controller), actionSheetCaptor.capture(), animated: .any, completion: .any))
		guard let actionSheet = actionSheetCaptor.value as? UIAlertController else {
			XCTFail("No action sheet presented")
			return
		}

		// when
		try actionSheet.tapButton(withTitle: "Cancel")

		// then
		XCTAssertEqual(datePicker.date, originalDate)
	}

	// MARK: - incrementByThirtyButtonPressed

	func testGivenTap_incrementByThirtyButtonPressed_decrementsDateByThirtyMinutes() {
		// given
		let uiEvent = getUiEventWithTapCount(1)
		let originalDate = Date()
		datePicker.setDate(originalDate, animated: false)

		// when
		controller.incrementByThirtyButtonPressed(sender: self, forEvent: uiEvent)

		// then
		XCTAssertEqual(datePicker.date, originalDate + 30.minutes)
	}

	func testGivenLongPressAndUserChoosesOption_incrementByThirtyButtonPressed_decrementsDateByThirtyAssociatedTimeUnits() throws {
		for unit in timeUnits {
			// given
			let uiEvent = getUiEventWithTapCount(0)
			let originalDate = Date()
			datePicker.setDate(originalDate, animated: false)

			controller.incrementByThirtyButtonPressed(sender: self, forEvent: uiEvent)
			let actionSheetCaptor = ArgumentCaptor<UIViewController>()
			Verify(mockUiUtil, .present(.value(controller), actionSheetCaptor.capture(), animated: .any, completion: .any))
			guard let actionSheet = actionSheetCaptor.value as? UIAlertController else {
				XCTFail("No action sheet presented")
				return
			}

			// when
			try actionSheet.tapButton(withTitle: unit.title)

			// then
			XCTAssertEqual(datePicker.date, originalDate + unit.units(30))
		}
	}

	func testGivenLongPressAndUserChoosesCancel_incrementByThirtyButtonPressed_doesNotChangeDate() throws {
		// given
		let uiEvent = getUiEventWithTapCount(0)
		let originalDate = Date()
		datePicker.setDate(originalDate, animated: false)

		controller.incrementByThirtyButtonPressed(sender: self, forEvent: uiEvent)
		let actionSheetCaptor = ArgumentCaptor<UIViewController>()
		Verify(mockUiUtil, .present(.value(controller), actionSheetCaptor.capture(), animated: .any, completion: .any))
		guard let actionSheet = actionSheetCaptor.value as? UIAlertController else {
			XCTFail("No action sheet presented")
			return
		}

		// when
		try actionSheet.tapButton(withTitle: "Cancel")

		// then
		XCTAssertEqual(datePicker.date, originalDate)
	}

	// MARK: - nowButtonPressed

	func testGivenInitialDateInPast_nowButtonPressed_setsDateToNow() {
		// given
		let initialDate = Date() - 1.days
		datePicker.setDate(initialDate, animated: false)

		// when
		controller.nowButtonPressed(self)

		// then
		XCTAssertGreaterThan(datePicker.date, initialDate)
	}

	func testGivenInitialDateInFuture_nowButtonPressed_setsDateToNow() {
		// given
		let initialDate = Date() + 1.days
		datePicker.setDate(initialDate, animated: false)

		// when
		controller.nowButtonPressed(self)

		// then
		XCTAssertLessThan(datePicker.date, initialDate)
	}

	// MARK: - acceptButtonPressed

	func testGivenFinalDateIsInitialDate_acceptButtonPressed_doesNotLimitDateToStartOfAnything() {
		// given
		let initialDate = Date()
		controller.notificationToSendOnAccept = Notification.Name("abc")
		controller.initialDate = initialDate
		controller.viewDidLoad()

		// when
		controller.acceptButtonPressed(self)

		// then
		Verify(mockCalendarUtil, .never, .start(of: .any, in: .value(initialDate)))
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(controller.notificationToSendOnAccept), object: .any, userInfo: userInfoCaptor.capture()))
		guard let userInfo = userInfoCaptor.value else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.date, withValue: initialDate))
	}

	func testGivenFinalDateIsSetFromLastbutton_acceptButtonPressed_doesNotLimitDateToStartOfAnything() {
		// given
		let lastDate = Date()
		controller.notificationToSendOnAccept = Notification.Name("abc")
		controller.lastDate = lastDate
		controller.lastButtonPressed(self)

		// when
		controller.acceptButtonPressed(self)

		// then
		Verify(mockCalendarUtil, .never, .start(of: .any, in: .value(lastDate)))
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(controller.notificationToSendOnAccept), object: .any, userInfo: userInfoCaptor.capture()))
		guard let userInfo = userInfoCaptor.value else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.date, withValue: lastDate))
	}

	func testGivenFinalDateIsSetFromNowButton_acceptButtonPressed_doesNotLimitDateToStartOfAnything() {
		// given
		let startOfTestDate = Date()
		controller.notificationToSendOnAccept = Notification.Name("abc")
		controller.nowButtonPressed(self)

		// when
		controller.acceptButtonPressed(self)

		// then
		Verify(mockCalendarUtil, .never, .start(of: .any, in: .any))
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(controller.notificationToSendOnAccept), object: .any, userInfo: userInfoCaptor.capture()))
		guard let userInfo = userInfoCaptor.value else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.date, withValue: greaterThan(startOfTestDate)))
	}

	func testGivenFinalDateIsSetFromDatePicker_acceptButtonPressed_limitsDateToStartOfMinute() {
		// given
		let startOfMinute = Date()
		Given(mockCalendarUtil, .start(of: .value(.minute), in: .any, willReturn: startOfMinute))
		controller.initialDate = Date() - 3.days
		controller.notificationToSendOnAccept = Notification.Name("abc")
		controller.viewDidLoad()
		controller.datePickerValueChanged(self)

		// when
		controller.acceptButtonPressed(self)

		// then
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(controller.notificationToSendOnAccept), object: .any, userInfo: userInfoCaptor.capture()))
		guard let userInfo = userInfoCaptor.value else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.date, withValue: startOfMinute))
	}

	func testGivenDateOnlyModeAndFinalDateIsInitialDate_acceptButtonPressed_limitsDateToStartOfDay() {
		// given
		let startOfDay = Date()
		Given(mockCalendarUtil, .start(of: .value(.day), in: .any, willReturn: startOfDay))
		controller.initialDate = Date() - 3.days
		controller.datePickerMode = .date
		controller.notificationToSendOnAccept = Notification.Name("abc")
		controller.viewDidLoad()

		// when
		controller.acceptButtonPressed(self)

		// then
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(controller.notificationToSendOnAccept), object: .any, userInfo: userInfoCaptor.capture()))
		guard let userInfo = userInfoCaptor.value else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.date, withValue: startOfDay))
	}

	func testGivenDateOnlyModeAndFinalDateIsSetFromLastbutton_acceptButtonPressed_limitsDateToStartOfDay() {
		// given
		let startOfDay = Date()
		Given(mockCalendarUtil, .start(of: .value(.day), in: .any, willReturn: startOfDay))
		controller.lastDate = Date() - 3.days
		controller.datePickerMode = .date
		controller.notificationToSendOnAccept = Notification.Name("abc")
		controller.viewDidLoad()
		controller.lastButtonPressed(lastButton)

		// when
		controller.acceptButtonPressed(self)

		// then
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(controller.notificationToSendOnAccept), object: .any, userInfo: userInfoCaptor.capture()))
		guard let userInfo = userInfoCaptor.value else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.date, withValue: startOfDay))
	}

	func testGivenDateOnlyModeAndFinalDateIsSetFromNowButton_acceptButtonPressed_limitsDateToStartOfDay() {
		// given
		let startOfDay = Date()
		Given(mockCalendarUtil, .start(of: .value(.day), in: .any, willReturn: startOfDay))
		controller.lastDate = Date() - 3.days
		controller.datePickerMode = .date
		controller.notificationToSendOnAccept = Notification.Name("abc")
		controller.viewDidLoad()
		controller.nowButtonPressed(lastButton)

		// when
		controller.acceptButtonPressed(self)

		// then
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(controller.notificationToSendOnAccept), object: .any, userInfo: userInfoCaptor.capture()))
		guard let userInfo = userInfoCaptor.value else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.date, withValue: startOfDay))
	}

	func testGivenDateOnlyModeAndFinalDateIsSetFromDatePicker_acceptButtonPressed_limitsDateToStartOfDay() {
		// given
		let startOfDay = Date()
		Given(mockCalendarUtil, .start(of: .value(.day), in: .any, willReturn: startOfDay))
		controller.initialDate = Date() - 3.days
		controller.notificationToSendOnAccept = Notification.Name("abc")
		controller.datePickerMode = .date
		controller.viewDidLoad()
		controller.datePickerValueChanged(self)

		// when
		controller.acceptButtonPressed(self)

		// then
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(controller.notificationToSendOnAccept), object: .any, userInfo: userInfoCaptor.capture()))
		guard let userInfo = userInfoCaptor.value else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.date, withValue: startOfDay))
	}

	// MARK: - Helper Functions

	private final func getUiEventWithTapCount(_ tapCount: Int) -> UIEvent {
		let touch = UITouch()
		touch.setValue(tapCount as Any, forKey: "tapCount")
		let uiEvent = UIEventTestStub()
		uiEvent.touches = Set([touch])
		return uiEvent
	}
}
