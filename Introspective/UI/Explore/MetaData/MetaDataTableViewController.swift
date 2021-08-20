//
//  MetaDataViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/4/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import UIKit

import Presentr

import Common
import DependencyInjection
import SwiftDate

public final class MetaDataTableViewController: UITableViewController {
	// MARK: - Static Variables

	private typealias Me = MetaDataTableViewController

	// MARK: Notifications

	internal static let dateRangeSet = Notification.Name("metaDataDateRangeSet")
	/// This will be sent whenever the meta data calcuations need to be reran
	internal static let runCalculations = Notification.Name("runMetaDataCalculations")

	// MARK: Presenters

	private static let setDateRangePresenter: Presentr = injected(UiUtil.self).customPresenter(
		width: .full,
		height: .custom(size: 300),
		center: .center
	)

	// MARK: Other

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var previousDateRangeButton: UIBarButtonItem!
	@IBOutlet final var dateRangeButton: UIBarButtonItem!
	@IBOutlet final var nextDateRangeButton: UIBarButtonItem!

	// MARK: - Instance Variables

	public final var minDate: Date = injected(CalendarUtil.self).start(of: .day, in: Date())
	public final var maxDate: Date = injected(CalendarUtil.self).end(of: .day, in: Date())

	// MARK: - UIViewController Overrides

	public override func viewDidLoad() {
		super.viewDidLoad()

		observe(selector: #selector(dateRangeSet), name: Me.dateRangeSet)
		resetDateRangeButtonTitle()
		rerunCalculations()
	}

	// MARK: - Table view data source

	public override func numberOfSections(in tableView: UITableView) -> Int {
		1
	}

	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}

	// MARK: - Table view delegate

	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: "timeUnaccountedFor",
			for: indexPath
		) as? UnaccountedForTimeTableViewCell else {
			return UITableViewCell()
		}
		return cell
	}

	// MARK: - IBActions

	@IBAction final func chooseDateRangeButtonPressed(_: Any) {
		let controller = viewController(named: "dateRangeChooser", fromStoryboard: "Util") as! DateRangeViewController
		controller.initialFromDate = minDate
		controller.initialToDate = maxDate
		controller.fromDateRequired = true
		controller.toDateRequired = true
		controller.datePickerMode = .date
		controller.notificationToSendOnAccept = Me.dateRangeSet
		customPresentViewController(Me.setDateRangePresenter, viewController: controller, animated: false)
	}

	@IBAction final func previousDateRangeButtonPressed(_: Any) {
		let startOfMin = injected(CalendarUtil.self).start(of: .day, in: minDate)
		let startOfMax = injected(CalendarUtil.self).start(of: .day, in: maxDate)
		if startOfMin == startOfMax {
			minDate = minDate - 1.days
			maxDate = maxDate - 1.days
		} else {
			let difference = maxDate - minDate
			minDate = minDate - difference
			maxDate = maxDate - difference
		}
		resetDateRangeButtonTitle()
		rerunCalculations()
	}

	@IBAction final func nextDateRangeButtonPressed(_: Any) {
		let startOfMin = injected(CalendarUtil.self).start(of: .day, in: minDate)
		let startOfMax = injected(CalendarUtil.self).start(of: .day, in: maxDate)
		if startOfMin == startOfMax {
			minDate = minDate + 1.days
			maxDate = maxDate + 1.days
		} else {
			let difference = maxDate - minDate
			minDate = minDate + difference
			maxDate = maxDate + difference
		}
		resetDateRangeButtonTitle()
		rerunCalculations()
	}

	// MARK: - Received Notifications

	@objc func dateRangeSet(notification: Notification) {
		if let minDate: Date = value(for: .fromDate, from: notification) {
			self.minDate = injected(CalendarUtil.self).start(of: .day, in: minDate)
		} else {
			Me.log.error("missing from date for meta data")
		}
		if let maxDate: Date = value(for: .toDate, from: notification) {
			self.maxDate = injected(CalendarUtil.self).end(of: .day, in: maxDate)
		} else {
			Me.log.error("missing to date for meta data")
		}

		rerunCalculations()
		resetDateRangeButtonTitle()
	}

	// MARK: - Helper Functions

	private final func resetDateRangeButtonTitle() {
		var dateText: String
		let startOfMin = injected(CalendarUtil.self).start(of: .day, in: minDate)
		let startOfMax = injected(CalendarUtil.self).start(of: .day, in: maxDate)
		if startOfMin == startOfMax {
			dateText = "On "
			dateText += injected(CalendarUtil.self).string(for: minDate, dateStyle: .medium, timeStyle: .none)
		} else {
			dateText = injected(CalendarUtil.self).string(for: minDate, dateStyle: .short, timeStyle: .none)
			dateText += " to "
			dateText += injected(CalendarUtil.self).string(for: maxDate, dateStyle: .short, timeStyle: .none)
		}
		dateRangeButton.title = dateText
		dateRangeButton.accessibilityValue = dateText
		dateRangeButton.accessibilityIdentifier = "choose dates button"
		dateRangeButton.accessibilityLabel = "choose dates button"
		dateRangeButton.accessibilityHint = "Choose the date range over which to calculate unaccounted for time"
	}

	private func rerunCalculations() {
		post(
			Me.runCalculations,
			object: self,
			userInfo: [
				.fromDate: minDate,
				.toDate: maxDate,
			]
		)
	}
}
