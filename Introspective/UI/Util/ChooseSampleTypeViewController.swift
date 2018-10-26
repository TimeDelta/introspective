//
//  ChooseSampleTypeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class ChooseSampleTypeViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var sampleTypePicker: UIPickerView!

	// MARK: - Instance Variables

	public final var selectedSampleType: Sample.Type?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		sampleTypePicker.dataSource = self
		sampleTypePicker.delegate = self
		if selectedSampleType != nil {
			if let selectedIndex = DependencyInjector.sample.allTypes().index(where: { $0 == selectedSampleType }) {
				sampleTypePicker.selectRow(selectedIndex, inComponent: 0, animated: false)
			} else {
				os_log("Could not find index for specified type", type: .error)
			}
		}
	}

	// MARK: - Button Actions

	@IBAction final func userPressedAccept(_ sender: Any) {
		let selectedIndex = sampleTypePicker.selectedRow(inComponent: 0)
		let selectedSampleType = DependencyInjector.sample.allTypes()[selectedIndex]
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: selectedSampleType)
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseSampleTypeViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return DependencyInjector.sample.allTypes().count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseSampleTypeViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return DependencyInjector.sample.allTypes()[row].name.localizedCapitalized
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedSampleType = DependencyInjector.sample.allTypes()[row]
	}
}
