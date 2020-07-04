//
//  ChooseSampleTypeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

protocol ChooseSampleTypeViewController: UIViewController {
	var selectedSampleType: Sample.Type? { get set }
	var notificationToSendOnAccept: NotificationName! { get set }
}

final class ChooseSampleTypeViewControllerImpl: UIViewController, ChooseSampleTypeViewController {
	// MARK: - IBOutlets

	@IBOutlet final var sampleTypePicker: UIPickerView!

	// MARK: - Instance Variables

	public final var selectedSampleType: Sample.Type?
	public final var notificationToSendOnAccept: NotificationName!

	private final let log = Log()

	// MARK: - UIViewController Overrides

	override final func viewDidLoad() {
		super.viewDidLoad()
		sampleTypePicker.dataSource = self
		sampleTypePicker.delegate = self
		if selectedSampleType != nil {
			if let selectedIndex = DependencyInjector.get(SampleFactory.self).allTypes()
				.index(where: { $0 == selectedSampleType }) {
				sampleTypePicker.selectRow(selectedIndex, inComponent: 0, animated: false)
			} else {
				log.error("Could not find index for specified type")
			}
		}
	}

	// MARK: - Button Actions

	@IBAction final func userPressedAccept(_: Any) {
		let selectedIndex = sampleTypePicker.selectedRow(inComponent: 0)
		let selectedSampleType = DependencyInjector.get(SampleFactory.self).allTypes()[selectedIndex]
		syncPost(
			notificationToSendOnAccept,
			userInfo: [
				.sampleType: selectedSampleType,
			]
		)
		dismiss(animated: false, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseSampleTypeViewControllerImpl: UIPickerViewDataSource {
	public final func numberOfComponents(in _: UIPickerView) -> Int {
		1
	}

	public final func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
		DependencyInjector.get(SampleFactory.self).allTypes().count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseSampleTypeViewControllerImpl: UIPickerViewDelegate {
	public final func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
		DependencyInjector.get(SampleFactory.self).allTypes()[row].name.localizedCapitalized
	}

	public final func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
		selectedSampleType = DependencyInjector.get(SampleFactory.self).allTypes()[row]
	}
}
