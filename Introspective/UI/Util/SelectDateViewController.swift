//
//  SelectDateViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Instructions
import SwiftDate
import UIKit

import Common
import DependencyInjection
import UIExtensions

public protocol SelectDateViewController: UIViewController {
	var initialDate: Date? { get set }
	var earliestPossibleDate: Date? { get set }
	var latestPossibleDate: Date? { get set }
	var datePickerMode: UIDatePicker.Mode { get set }
	var lastDate: Date? { get set }
	var notificationToSendOnAccept: Notification.Name! { get set }
}

public final class SelectDateViewControllerImpl: UIViewController, SelectDateViewController {
	// MARK: - Static Variables

	private typealias Me = SelectDateViewControllerImpl

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var datePicker: UIDatePicker!
	@IBOutlet final var toolbar: UIToolbar!

	// MARK: - Instance Variables

	public final var initialDate: Date?
	public final var earliestPossibleDate: Date?
	public final var latestPossibleDate: Date?
	public final var datePickerMode: UIDatePicker.Mode = .dateAndTime {
		didSet {
			if datePickerMode == .countDownTimer {
				Me.log.error("this view is not meant to do timers")
			}
		}
	}

	public final var lastDate: Date?
	public final var notificationToSendOnAccept: Notification.Name!

	private final var limitDateToStartOfMinute = true

	private final var decrementByThirtyButton: UIBarButtonItem!

	private final var coachMarksController = DependencyInjector.get(CoachMarkFactory.self).controller()
	private final var coachMarksDataSourceAndDelegate: CoachMarksDataSourceAndDelegate!
	private lazy final var coachMarksInfo: [CoachMarkInfo] = [
		CoachMarkInfo(
			hint: "Use these buttons to increment / decrement the time by the corresponding number of minutes. You can also long press them to increment / decrement by a time unit of your choosing.",
			useArrow: true,
			view: { self.decrementByThirtyButton.value(forKey: "view") as? UIView }
		),
	]

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		if let date = initialDate {
			datePicker.setDate(date, animated: false)
			limitDateToStartOfMinute = false
		}
		datePicker.minimumDate = earliestPossibleDate
		datePicker.maximumDate = latestPossibleDate
		datePicker.datePickerMode = datePickerMode

		var nowButtonTitle = "Now"
		if datePickerMode == .date {
			nowButtonTitle = "Today"
		}

		coachMarksDataSourceAndDelegate = DefaultCoachMarksDataSourceAndDelegate(
			coachMarksInfo,
			instructionsShownKey: .selectDateViewInstructionsShown,
			skipViewLayoutConstraints: DefaultCoachMarksDataSourceAndDelegate.defaultCoachMarkSkipViewConstraints()
		)
		coachMarksController.dataSource = coachMarksDataSourceAndDelegate
		coachMarksController.delegate = coachMarksDataSourceAndDelegate
		coachMarksController.skipView = DefaultCoachMarksDataSourceAndDelegate.defaultSkipInstructionsView()

		let lastButton = UIBarButtonItem(
			title: "Last",
			style: .plain,
			target: self,
			action: #selector(lastButtonPressed)
		)
		lastButton.isEnabled = lastDate != nil
		decrementByThirtyButton = barButton(
			title: "-30",
			quickPress: #selector(quickPressDecrementByThirty),
			longPress: #selector(longPressDecrementByThirty)
		)
		let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
		fixedSpace.width = CGFloat(10)
		toolbar.setItems([
			lastButton,
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			decrementByThirtyButton,
			fixedSpace,
			barButton(
				title: "-15",
				quickPress: #selector(quickPressDecrementByFifteen),
				longPress: #selector(longPressDecrementByFifteen)
			),
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			barButton(
				title: "+15",
				quickPress: #selector(quickPressIncrementByFifteen),
				longPress: #selector(longPressIncrementByFifteen)
			),
			fixedSpace,
			barButton(
				title: "+30",
				quickPress: #selector(quickPressIncrementByThirty),
				longPress: #selector(longPressIncrementByThirty)
			),
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			UIBarButtonItem(title: nowButtonTitle, style: .plain, target: self, action: #selector(nowButtonPressed)),
		], animated: false)
	}

	public final override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !DependencyInjector.get(UserDefaultsUtil.self).bool(forKey: .selectDateViewInstructionsShown) {
			coachMarksController.start(in: .window(over: self))
		}
	}

	public final override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		coachMarksController.stop(immediately: true)
	}

	// MARK: - Actions

	@IBAction final func lastButtonPressed(_: Any) {
		if let date = lastDate {
			datePicker.date = date
			limitDateToStartOfMinute = false
		} else {
			Me.log.error("last date was unexpectedly nil")
		}
	}

	@IBAction final func quickPressDecrementByThirty() {
		quickPressIncrementOrDecrement(amountToAdd: -30)
	}

	@IBAction final func longPressDecrementByThirty() {
		showChooseTimeUnitActionSheet(amountToAdd: -30)
	}

	@IBAction final func quickPressDecrementByFifteen() {
		quickPressIncrementOrDecrement(amountToAdd: -15)
	}

	@IBAction final func longPressDecrementByFifteen() {
		showChooseTimeUnitActionSheet(amountToAdd: -15)
	}

	@IBAction final func quickPressIncrementByFifteen() {
		quickPressIncrementOrDecrement(amountToAdd: 15)
	}

	@IBAction final func longPressIncrementByFifteen() {
		showChooseTimeUnitActionSheet(amountToAdd: 15)
	}

	@IBAction final func quickPressIncrementByThirty() {
		quickPressIncrementOrDecrement(amountToAdd: 30)
	}

	@IBAction final func longPressIncrementByThirty() {
		showChooseTimeUnitActionSheet(amountToAdd: 30)
	}

	@IBAction final func nowButtonPressed(_: Any) {
		datePicker.date = Date()
		limitDateToStartOfMinute = false
	}

	@IBAction func datePickerValueChanged(_: Any) {
		limitDateToStartOfMinute = true
	}

	@IBAction final func acceptButtonPressed(_: Any) {
		var date = datePicker.date
		if datePickerMode == .date {
			date = DependencyInjector.get(CalendarUtil.self).start(of: .day, in: date)
		} else if limitDateToStartOfMinute {
			date = DependencyInjector.get(CalendarUtil.self).start(of: .minute, in: date)
		}
		post(notificationToSendOnAccept, userInfo: [.date: date])
		dismiss(animated: false, completion: nil)
	}

	// MARK: - Helper Functions

	private final func quickPressIncrementOrDecrement(amountToAdd: Int) {
		if datePickerMode == .date {
			datePicker.date = datePicker.date + amountToAdd.days
		} else {
			datePicker.date = datePicker.date + amountToAdd.minutes
		}
	}

	private final func showChooseTimeUnitActionSheet(amountToAdd: Int) {
		let actionSheet = UIAlertController(title: "Which unit?", message: nil, preferredStyle: .actionSheet)
		actionSheet.addAction(UIAlertAction(title: "Months", style: .default) { _ in
			self.datePicker.date = self.datePicker.date + amountToAdd.months
		})
		actionSheet.addAction(UIAlertAction(title: "Weeks", style: .default) { _ in
			self.datePicker.date = self.datePicker.date + amountToAdd.weeks
		})
		actionSheet.addAction(UIAlertAction(title: "Days", style: .default) { _ in
			self.datePicker.date = self.datePicker.date + amountToAdd.days
		})
		actionSheet.addAction(UIAlertAction(title: "Hours", style: .default) { _ in
			self.datePicker.date = self.datePicker.date + amountToAdd.hours
		})
		actionSheet.addAction(UIAlertAction(title: "Minutes", style: .default) { _ in
			self.datePicker.date = self.datePicker.date + amountToAdd.minutes
		})
		actionSheet.addAction(UIAlertAction(title: "Seconds", style: .default) { _ in
			self.datePicker.date = self.datePicker.date + amountToAdd.seconds
			self.limitDateToStartOfMinute = false
		})
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		presentView(actionSheet)
	}
}
