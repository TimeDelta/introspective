//
//  SelectDateViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import SwiftDate
import Instructions

public final class SelectDateViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var datePicker: UIDatePicker!
	@IBOutlet weak final var lastButton: UIBarButtonItem!
	@IBOutlet weak final var decrementByThirtyButton: UIBarButtonItem!

	// MARK: - Instance Variables

	public final var initialDate: Date?
	public final var earliestPossibleDate: Date?
	public final var latestPossibleDate: Date?
	public final var datePickerMode: UIDatePicker.Mode = .dateAndTime {
		didSet {
			if datePickerMode == .countDownTimer {
				log.error("this view is not meant to do timers")
			}
		}
	}
	public final var lastDate: Date?
	public final var notificationToSendOnAccept: Notification.Name!

	private final var limitDateToStartOfMinute = true

	private final let log = Log()

	private final var coachMarksController = DependencyInjector.coachMarks.controller()
	private final var coachMarksDataSourceAndDelegate: CoachMarksDataSourceAndDelegate!
	private final lazy var coachMarksInfo: [CoachMarkInfo] = [
		CoachMarkInfo(
			hint: "Use these buttons to increment / decrement the time by the corresponding number of minutes. You can also long press them to increment / decrement by a time unit of your choosing.",
			useArrow: true,
			view: { return self.decrementByThirtyButton.value(forKey: "view") as? UIView }),
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

		lastButton.isEnabled = lastDate != nil

		coachMarksDataSourceAndDelegate = DefaultCoachMarksDataSourceAndDelegate(
			coachMarksInfo,
			instructionsShownKey: .selectDateViewInstructionsShown,
			skipViewLayoutConstraints: defaultCoachMarkSkipViewConstraints())
		coachMarksController.dataSource = coachMarksDataSourceAndDelegate
		coachMarksController.delegate = coachMarksDataSourceAndDelegate
		coachMarksController.skipView = defaultSkipInstructionsView()
	}

	public final override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !DependencyInjector.util.userDefaults.bool(forKey: .selectDateViewInstructionsShown) {
			coachMarksController.start(in: .window(over: self))
		}
	}

	public final override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		coachMarksController.stop(immediately: true)
	}

	// MARK: - Actions

	@IBAction final func lastButtonPressed(_ sender: Any) {
		if let date = lastDate {
			datePicker.date = date
			limitDateToStartOfMinute = false
		} else {
			log.error("last date was unexpectedly nil")
		}
	}

	@IBAction final func decrementByThirtyButtonPressed(sender: AnyObject, forEvent event: UIEvent) {
		processIncrementOrDecrementEvent(event, amountToAdd: -30)
	}

	@IBAction final func decrementByFifteenButtonPressed(sender: AnyObject, forEvent event: UIEvent) {
		processIncrementOrDecrementEvent(event, amountToAdd: -15)
	}

	@IBAction final func incrementByFifteenButtonPressed(sender: AnyObject, forEvent event: UIEvent) {
		processIncrementOrDecrementEvent(event, amountToAdd: 15)
	}

	@IBAction final func incrementByThirtyButtonPressed(sender: AnyObject, forEvent event: UIEvent) {
		processIncrementOrDecrementEvent(event, amountToAdd: 30)
	}

	@IBAction final func nowButtonPressed(_ sender: Any) {
		datePicker.date = Date()
		limitDateToStartOfMinute = false
	}

	@IBAction func datePickerValueChanged(_ sender: Any) {
		limitDateToStartOfMinute = true
	}

	@IBAction final func acceptButtonPressed(_ sender: Any) {
		var date = datePicker.date
		if datePickerMode == .date {
			date = DependencyInjector.util.calendar.start(of: .day, in: date)
		} else if limitDateToStartOfMinute {
			date = DependencyInjector.util.calendar.start(of: .minute, in: date)
		}
		post(notificationToSendOnAccept, userInfo: [.date: date])
		dismiss(animated: false, completion: nil)
	}

	// MARK: - Helper Functions

	private final func processIncrementOrDecrementEvent(_ event: UIEvent, amountToAdd: Int) {
		if let touch = event.allTouches?.first {
			if touch.tapCount == 1 { // tap
				datePicker.date = datePicker.date + amountToAdd.minutes
			} else if touch.tapCount == 0 { // long press
				showChooseTimeUnitActionSheet(amountToAdd: amountToAdd)
			}
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
		})
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		presentView(actionSheet)
	}
}
