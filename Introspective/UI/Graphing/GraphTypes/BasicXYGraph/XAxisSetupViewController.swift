//
//  XAxisSetupViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Presentr
import UIKit

import Attributes
import Common
import DependencyInjection
import SampleGroupInformation

public protocol XAxisSetupViewController: UIViewController {
	var usePointGroupValue: Bool { get set }
	var grouped: Bool { get set }
	var attributes: [Attribute]! { get set }
	var selectedAttribute: Attribute! { get set }
	var selectedInformation: SampleGroupInformation! { get set }
	var notificationToSendWhenFinished: NotificationName! { get set }
}

final class XAxisSetupViewControllerImpl: UIViewController, XAxisSetupViewController {
	// MARK: - Static Variables

	private typealias Me = XAxisSetupViewControllerImpl

	private static let groupingChanged = Notification.Name("groupingChanged")

	private static let presenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var usePointGroupValueLabel: UILabel!
	@IBOutlet final var usePointGroupValueSwitch: UISwitch!
	@IBOutlet final var attributePicker: UIPickerView!
	@IBOutlet final var informationPicker: UIPickerView!

	// MARK: - Instance Variables

	public final var usePointGroupValue: Bool = false
	public final var grouped: Bool = false { didSet { updateDisplay() } }
	public final var attributes: [Attribute]!
	public final var selectedAttribute: Attribute! {
		didSet {
			if selectedAttribute == nil { return }
			if finishedLoading {
				informationPicker.reloadAllComponents()
			}
			let applicableInformationTypes = getApplicableInformationTypesForSelectedAttribute()
			if let index = applicableInformationTypes.firstIndex(where: { $0 == type(of: selectedInformation) }) {
				selectedInformation = applicableInformationTypes[index].init(selectedAttribute)
			} else if !applicableInformationTypes.isEmpty {
				selectedInformation = applicableInformationTypes[0].init(selectedAttribute)
			}
		}
	}

	public final var selectedInformation: SampleGroupInformation!
	public final var notificationToSendWhenFinished: NotificationName!
	private final var finishedLoading = false

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
		if let selectedAttributeIndex = attributes.firstIndex(where: { $0.equalTo(selectedAttribute) }) {
			attributePicker.selectRow(selectedAttributeIndex, inComponent: 0, animated: false)
		} else {
			Me.log.error("Failed to find selected attribute in attributes array")
		}

		if let selectedInformationIndex = indexOfSelectedInformation() {
			informationPicker.selectRow(selectedInformationIndex, inComponent: 0, animated: false)
		}

		usePointGroupValueSwitch.isOn = usePointGroupValue
		finishedLoading = true
		updateDisplay()
	}

	// MARK: - Button Actions

	@IBAction final func acceptButtonPressed(_: Any) {
		if grouped {
			sendGroupedAcceptedNotification()
		} else {
			sendUngroupedAcceptedNotification()
		}
		if let navigationController = navigationController {
			navigationController.popViewController(animated: false)
		} else {
			dismiss(animated: false, completion: nil)
		}
	}

	@IBAction final func useGroupValueChanged(_: Any) {
		updateDisplay()
	}

	private final func sendUngroupedAcceptedNotification() {
		guard let selectedAttribute = selectedAttribute else {
			Me.log.error("Selected attribute not set")
			return
		}
		syncPost(
			notificationToSendWhenFinished,
			userInfo: [
				.attribute: selectedAttribute,
			]
		)
	}

	private final func sendGroupedAcceptedNotification() {
		if usePointGroupValueSwitch.isOn {
			syncPost(
				notificationToSendWhenFinished,
				userInfo: [
					.usePointGroupValue: true,
				]
			)
		} else {
			guard let selectedInformation = selectedInformation else {
				Me.log.error("Selected information not set")
				return
			}
			syncPost(
				notificationToSendWhenFinished,
				userInfo: [
					.information: selectedInformation,
				]
			)
		}
	}

	// MARK: - Helper Functions

	private final func getApplicableInformationTypesForSelectedAttribute() -> [SampleGroupInformation.Type] {
		injected(SampleGroupInformationFactory.self)
			.getApplicableInformationTypes(forAttribute: selectedAttribute)
	}

	private final func indexOfSelectedInformation() -> Int? {
		if selectedInformation == nil { return nil }
		return getApplicableInformationTypesForSelectedAttribute()
			.firstIndex(where: { $0.init(selectedAttribute).equalTo(selectedInformation!) })
	}

	private final func updateDisplay() {
		if finishedLoading {
			injected(UiUtil.self).setView(usePointGroupValueLabel, enabled: grouped, hidden: !grouped)
			injected(UiUtil.self).setView(usePointGroupValueSwitch, enabled: grouped, hidden: !grouped)
			if grouped && usePointGroupValueSwitch.isOn {
				injected(UiUtil.self).setView(informationPicker, enabled: false, hidden: true)
				injected(UiUtil.self).setView(attributePicker, enabled: false, hidden: true)
			} else {
				injected(UiUtil.self).setView(informationPicker, enabled: grouped, hidden: !grouped)
				injected(UiUtil.self).setView(attributePicker, enabled: true, hidden: false)
			}
		}
	}
}

// MARK: - UIPickerViewDataSource

extension XAxisSetupViewControllerImpl: UIPickerViewDataSource {
	public final func numberOfComponents(in _: UIPickerView) -> Int {
		1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
		if pickerView == attributePicker {
			return attributes.count
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute().count
		}
		Me.log.error(
			"Unknown UIPickerView when determining number of rows: '%@'",
			pickerView.restorationIdentifier ?? ""
		)
		return 0
	}
}

// MARK: - UIPickerViewDelegate

extension XAxisSetupViewControllerImpl: UIPickerViewDelegate {
	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
		if pickerView == attributePicker {
			return attributes[row].name.localizedCapitalized
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute()[row].init(selectedAttribute).name
				.localizedCapitalized
		}
		Me.log.error("Unknown UIPickerView when determining row title: '%@'", pickerView.restorationIdentifier ?? "")
		return nil
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
		if pickerView == attributePicker {
			selectedAttribute = attributes[row]
		}
		if pickerView == informationPicker {
			selectedInformation = getApplicableInformationTypesForSelectedAttribute()[row].init(selectedAttribute)
		}
		Me.log.error("Unknown UIPickerView when determining row title: '%@'", pickerView.restorationIdentifier ?? "")
	}
}
