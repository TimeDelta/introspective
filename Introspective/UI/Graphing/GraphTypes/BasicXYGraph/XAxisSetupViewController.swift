//
//  XAxisSetupViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import os

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
		let selectedAttributeIndex = attributes.index(where: { attribute in return attribute.name == selectedAttribute.name })!
		attributePicker.selectRow(selectedAttributeIndex, inComponent: 0, animated: false)

		if let selectedInformationIndex = indexOfSelectedInformation() {
			informationPicker.selectRow(selectedInformationIndex, inComponent: 0, animated: false)
		}

		NotificationCenter.default.addObserver(self, selector: #selector(groupingChanged), name: Me.groupingChanged, object: nil)

		finishedLoading = true
		updateDisplay()
	}

	// MARK: - Button Actions

	@IBAction final func clearGroupingButtonPressed(_ sender: Any) {
		grouping = nil
	}

	@IBAction final func chooseGroupingButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "chooseCalendarComponent") as! ChooseCalendarComponentViewController
		controller.selectedComponent = grouping
		controller.notificationToSendOnAccept = Me.groupingChanged
		customPresentViewController(Me.presenter, viewController: controller, animated: true)
	}

	@IBAction final func acceptButtonPressed(_ sender: Any) {
		if grouping == nil {
			NotificationCenter.default.post(name: notificationToSendWhenFinished, object: (grouping: grouping, xAxis: selectedAttribute))
		} else {
			NotificationCenter.default.post(name: notificationToSendWhenFinished, object: (grouping: grouping, xAxis: selectedInformation))
		}
		if navigationController != nil {
			navigationController!.popViewController(animated: true)
		} else {
			dismiss(animated: false, completion: nil)
		}
	}

	// MARK: - Received Notifications

	@objc private final func groupingChanged(notification: Notification) {
		grouping = (notification.object as! Calendar.Component)
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
				UiUtil.setView(informationPicker, enabled: false, hidden: true)
				UiUtil.setButton(clearGroupingButton, enabled: false, hidden: true)
			} else {
				chooseGroupingButton.setTitle("Per " + grouping!.description.localizedLowercase, for: .normal)
				UiUtil.setView(informationPicker, enabled: true, hidden: false)
				UiUtil.setButton(clearGroupingButton, enabled: true, hidden: false)
			}
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
		os_log("Unknown UIPickerView when determining number of rows: '%@'", type: .error, pickerView.restorationIdentifier ?? "")
		return 0
	}
}

// MARK: - UIPickerViewDelegate

extension XAxisSetupViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == attributePicker {
			return attributes[row].name
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute()[row].init(selectedAttribute).name
		}
		os_log("Unknown UIPickerView when determining row title: '%@'", type: .error, pickerView.restorationIdentifier ?? "")
		return nil
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView == attributePicker {
			selectedAttribute = attributes[row]
		}
		if pickerView == informationPicker {
			selectedInformation = getApplicableInformationTypesForSelectedAttribute()[row].init(selectedAttribute)
		}
		os_log("Unknown UIPickerView when determining row title: '%@'", type: .error, pickerView.restorationIdentifier ?? "")
	}
}
