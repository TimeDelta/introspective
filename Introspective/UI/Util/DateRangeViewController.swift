//
//  DateRangeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

public protocol DateRangeViewController: UIViewController {
	var datePickerMode: UIDatePicker.Mode { get set }
	var initialFromDate: Date? { get set }
	var minFromDate: Date? { get set }
	var maxFromDate: Date? { get set }
	var initialToDate: Date? { get set }
	var minToDate: Date? { get set }
	var maxToDate: Date? { get set }
	var notificationToSendOnAccept: Notification.Name! { get set }
}

public final class DateRangeViewControllerImpl: UIViewController, DateRangeViewController {
	public static let preferredHeight: CGFloat = 600

	// MARK: - IBOutlets

	@IBOutlet final var enableFromDateSwitch: UISwitch!
	@IBOutlet final var fromDatePicker: UIDatePicker!
	@IBOutlet final var enableToDateSwitch: UISwitch!
	@IBOutlet final var toDatePicker: UIDatePicker!
	@IBOutlet final var saveButton: UIButton!
	@IBOutlet final var fromDateLabel: UILabel!
	@IBOutlet final var toDateLabel: UILabel!

	// MARK: - Instance Variables

	public final var datePickerMode: UIDatePicker.Mode = .date
	public final var initialFromDate: Date?
	public final var minFromDate: Date?
	public final var maxFromDate: Date?
	public final var initialToDate: Date?
	public final var minToDate: Date?
	public final var maxToDate: Date?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		// These fixed-height editors were designed for an always-visible wheel picker.
		if #available(iOS 13.4, *) {
			fromDatePicker.preferredDatePickerStyle = .wheels
			toDatePicker.preferredDatePickerStyle = .wheels
		}

		fromDatePicker.datePickerMode = datePickerMode
		toDatePicker.datePickerMode = datePickerMode

		fromDatePicker.accessibilityIdentifier = "from date picker"
		toDatePicker.accessibilityIdentifier = "to date picker"

		if let fromDate = initialFromDate {
			fromDatePicker.date = fromDate
		} else {
			enableFromDateSwitch.isOn = false
		}
		if let toDate = initialToDate {
			toDatePicker.date = toDate
		} else {
			enableToDateSwitch.isOn = false
		}
		updateFromDatePickerState()
		updateToDatePickerState()

		fromDatePicker.minimumDate = minFromDate
		fromDatePicker.maximumDate = maxFromDate
		toDatePicker.minimumDate = minToDate
		toDatePicker.maximumDate = maxToDate

		fromDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
		toDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
		layoutDatePickers()
	}

	private func layoutDatePickers() {
		guard let parent = fromDatePicker.superview, let fromLabel = fromDateLabel,
			let toLabel = toDateLabel, toDatePicker.superview === parent,
			saveButton.superview === parent else { return }
		preferredContentSize = CGSize(width: 375, height: Self.preferredHeight)
		let movedViews: [UIView] = [fromDatePicker, toDatePicker, enableFromDateSwitch, enableToDateSwitch, saveButton, fromLabel, toLabel]
		NSLayoutConstraint.deactivate(parent.constraints.filter { constraint in
			movedViews.contains { $0 === constraint.firstItem as? UIView || $0 === constraint.secondItem as? UIView }
		})
		let fromRow = UIStackView(arrangedSubviews: [fromLabel, enableFromDateSwitch])
		let toRow = UIStackView(arrangedSubviews: [toLabel, enableToDateSwitch])
		let content = UIStackView(arrangedSubviews: [fromRow, fromDatePicker, toRow, toDatePicker])
		content.axis = .vertical; content.spacing = 8
		let scroll = UIScrollView()
		scroll.addSubview(content); parent.addSubview(scroll)
		let controls: [UIView] = [scroll, content, saveButton]
		for control in controls { control.translatesAutoresizingMaskIntoConstraints = false }
		NSLayoutConstraint.activate([
			scroll.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: 8),
			scroll.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
			scroll.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
			scroll.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -8),
			content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
			content.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 8),
			content.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -8),
			content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
			content.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -16),
			fromDatePicker.heightAnchor.constraint(equalToConstant: 216),
			toDatePicker.heightAnchor.constraint(equalToConstant: 216),
			saveButton.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
			saveButton.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
			saveButton.heightAnchor.constraint(equalToConstant: 45),
			saveButton.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: -8),
		])
	}

	// MARK: - Actions

	@IBAction final func saveButtonPressed(_: Any) {
		let fromDate: Date? = getFromDate()
		let toDate: Date? = getToDate()
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: self.info([
					.fromDate: fromDate as Any,
					.toDate: toDate as Any,
				])
			)
		}
		dismiss(animated: false, completion: nil)
	}

	@IBAction final func fromDateSwitchToggled(_: Any) {
		updateFromDatePickerState()
		dateChanged()
	}

	@IBAction final func toDateSwitchToggled(_: Any) {
		updateToDatePickerState()
		dateChanged()
	}

	// MARK: - Helper Functions

	@objc private final func dateChanged() {
		if let fromDate = getFromDate(), let toDate = getToDate() {
			injected(UiUtil.self).setButton(saveButton, enabled: fromDate <= toDate, hidden: false)
			if #available(iOS 13.0, *) {
				saveButton.backgroundColor = saveButton.isEnabled ? .label : .systemGray
			} else {
				saveButton.backgroundColor = saveButton.isEnabled ? .black : .gray
			}
		} else {
			injected(UiUtil.self).setButton(saveButton, enabled: true, hidden: false)
			if #available(iOS 13.0, *) {
				saveButton.backgroundColor = .label
			} else {
				saveButton.backgroundColor = .black
			}
		}
	}

	private final func updateFromDatePickerState() {
		fromDatePicker.isEnabled = enableFromDateSwitch.isOn
		fromDatePicker.isUserInteractionEnabled = enableFromDateSwitch.isOn
	}

	private final func updateToDatePickerState() {
		toDatePicker.isEnabled = enableToDateSwitch.isOn
		toDatePicker.isUserInteractionEnabled = enableToDateSwitch.isOn
	}

	private final func getFromDate() -> Date? {
		var fromDate: Date?
		if enableFromDateSwitch.isOn {
			fromDate = injected(CalendarUtil.self).start(of: .minute, in: fromDatePicker.date)
			if datePickerMode == .date {
				fromDate = injected(CalendarUtil.self).start(of: .day, in: fromDatePicker.date)
			}
//			fromDate = constrainDate(fromDate, from: minFromDate, to: maxFromDate)
		}
		return fromDate
	}

	private final func getToDate() -> Date? {
		var toDate: Date?
		if enableToDateSwitch.isOn {
			toDate = injected(CalendarUtil.self).start(of: .minute, in: toDatePicker.date)
			if datePickerMode == .date {
				toDate = injected(CalendarUtil.self).start(of: .day, in: toDatePicker.date)
			}
//			toDate = constrainDate(toDate, from: minToDate, to: maxToDate)
		}
		return toDate
	}

	private final func constrainDate(_ date: Date?, from minDate: Date?, to maxDate: Date?) -> Date? {
		if let date = date {
			if let maxDate = maxDate {
				if date > maxDate {
					return maxDate
				}
			}
			if let minDate = minDate {
				if date < minDate {
					return minDate
				}
			}
		}
		return date
	}
}
