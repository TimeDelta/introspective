//
//  XAxisSetupViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr

final class XAxisSetupViewController: UIViewController {

	// MARK: - Static Variables

	private typealias Me = XAxisSetupViewController
	private static let groupingChanged = Notification.Name("groupingChanged")
	private static let presenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - IBOutlets

	@IBOutlet weak final var clearGroupingButton: UIButton!
	@IBOutlet weak final var chooseGroupingButton: UIButton!
	@IBOutlet weak final var attributePicker: UIPickerView!
	@IBOutlet weak final var informationPicker: UIPickerView!

	// MARK: - Instance Variables

	public final var grouping: Calendar.Component? { didSet { updateDisplay() } }
	public final var attributes: [Attribute]!
	public final var selectedAttribute: Attribute! {
		didSet {
			if selectedAttribute == nil { return }
			if finishedLoading {
				informationPicker.reloadAllComponents()
			}
			let applicableInformationTypes = getApplicableInformationTypesForSelectedAttribute()
			if let index = applicableInformationTypes.index(where: { $0 == type(of: selectedInformation) }) {
				selectedInformation = applicableInformationTypes[index].init(selectedAttribute)
			} else if applicableInformationTypes.count > 0 {
				selectedInformation = applicableInformationTypes[0].init(selectedAttribute)
			}
		}
	}
	public final var selectedInformation: ExtraInformation!
	public final var notificationToSendWhenFinished: Notification.Name!
	private final var finishedLoading = false

	private final let log = Log()

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		attributePicker.delegate = self
		attributePicker.dataSource = self
		informationPicker.delegate = self
		informationPicker.dataSource = self

		if selectedAttribute == nil {
			selectedAttribute = attributes[0]
		}
		if let selectedAttributeIndex = attributes.index(where: { $0.equalTo(selectedAttribute) }) {
			attributePicker.selectRow(selectedAttributeIndex, inComponent: 0, animated: false)
		} else {
			log.error("Failed to find selected attribute in attributes array")
		}

		if let selectedInformationIndex = indexOfSelectedInformation() {
			informationPicker.selectRow(selectedInformationIndex, inComponent: 0, animated: false)
		}

		observe(selector: #selector(groupingChanged), name: Me.groupingChanged)

		finishedLoading = true
		updateDisplay()
	}

	// MARK: - Button Actions

	@IBAction final func clearGroupingButtonPressed(_ sender: Any) {
		grouping = nil
	}

	@IBAction final func chooseGroupingButtonPressed(_ sender: Any) {
		let controller: ChooseCalendarComponentViewController = viewController(named: "chooseCalendarComponent", fromStoryboard: "Util")
		controller.applicableComponents = [ .year, .quarter, .month, .weekOfMonth, .weekOfYear, .day, .hour, .minute, .second, .nanosecond]
		controller.selectedComponent = grouping
		controller.notificationToSendOnAccept = Me.groupingChanged
		customPresentViewController(Me.presenter, viewController: controller, animated: false)
	}

	@IBAction final func acceptButtonPressed(_ sender: Any) {
		if grouping == nil {
			sendUngroupedAcceptedNotification()
		} else {
			sendGroupedAcceptedNotification()
		}
		if let navigationController = navigationController {
			navigationController.popViewController(animated: false)
		} else {
			dismiss(animated: false, completion: nil)
		}
	}

	private final func sendUngroupedAcceptedNotification() {
		guard let selectedAttribute = selectedAttribute else {
			log.error("Selected attribute not set")
			return
		}
		NotificationCenter.default.post(
			name: notificationToSendWhenFinished,
			object: self,
			userInfo: info([
				.attribute: selectedAttribute,
			]))
	}

	private final func sendGroupedAcceptedNotification() {
		guard let selectedInformation = selectedInformation else {
			log.error("Selected information not set")
			return
		}
		NotificationCenter.default.post(
			name: notificationToSendWhenFinished,
			object: self,
			userInfo: info([
				.calendarComponent: grouping as Any,
				.information: selectedInformation,
			]))
	}

	// MARK: - Received Notifications

	@objc private final func groupingChanged(notification: Notification) {
		if let grouping: Calendar.Component = value(for: .calendarComponent, from: notification) {
			self.grouping = grouping
		}
	}

	// MARK: - Helper Functions

	private final func getApplicableInformationTypesForSelectedAttribute() -> [ExtraInformation.Type] {
		return DependencyInjector.extraInformation.getApplicableInformationTypes(forAttribute: selectedAttribute)
	}

	private final func indexOfSelectedInformation() -> Int? {
		if selectedInformation == nil { return nil }
		return getApplicableInformationTypesForSelectedAttribute().index(where: { $0.init(selectedAttribute).equalTo(selectedInformation!) })
	}

	private final func updateDisplay() {
		if finishedLoading {
			if grouping == nil {
				chooseGroupingButton.setTitle("Choose grouping (optional)", for: .normal)
				DependencyInjector.util.ui.setView(informationPicker, enabled: false, hidden: true)
				DependencyInjector.util.ui.setButton(clearGroupingButton, enabled: false, hidden: true)
			} else {
				chooseGroupingButton.setTitle("Per " + grouping!.description.localizedLowercase, for: .normal)
				DependencyInjector.util.ui.setView(informationPicker, enabled: true, hidden: false)
				DependencyInjector.util.ui.setButton(clearGroupingButton, enabled: true, hidden: false)
			}
			chooseGroupingButton.accessibilityValue = chooseGroupingButton.currentTitle
		}
	}
}

// MARK: - UIPickerViewDataSource

extension XAxisSetupViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == attributePicker {
			return attributes.count
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute().count
		}
		log.error("Unknown UIPickerView when determining number of rows: '%@'", pickerView.restorationIdentifier ?? "")
		return 0
	}
}

// MARK: - UIPickerViewDelegate

extension XAxisSetupViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == attributePicker {
			return attributes[row].name.localizedCapitalized
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute()[row].init(selectedAttribute).name.localizedCapitalized
		}
		log.error("Unknown UIPickerView when determining row title: '%@'", pickerView.restorationIdentifier ?? "")
		return nil
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView == attributePicker {
			selectedAttribute = attributes[row]
		}
		if pickerView == informationPicker {
			selectedInformation = getApplicableInformationTypesForSelectedAttribute()[row].init(selectedAttribute)
		}
		log.error("Unknown UIPickerView when determining row title: '%@'", pickerView.restorationIdentifier ?? "")
	}
}
