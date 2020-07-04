//
//  ChooseGraphTypeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class ChooseGraphTypeViewController: UIViewController {
	// MARK: - IBOutlets

	@IBOutlet final var graphTypePicker: UIPickerView!

	// MARK: - Instance Variables

	public final var currentValue: GraphType?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	override final func viewDidLoad() {
		super.viewDidLoad()

		graphTypePicker.dataSource = self
		graphTypePicker.delegate = self

		if currentValue == nil {
			currentValue = GraphType.allTypes[0]
		} else if let index = GraphType.allTypes.firstIndex(of: currentValue!) {
			graphTypePicker.selectRow(index, inComponent: 0, animated: false)
		}
	}

	// MARK: - Actions

	@IBAction final func acceptButtonPressed(sender _: Any) {
		NotificationCenter.default.post(
			name: notificationToSendOnAccept,
			object: self,
			userInfo: info([
				.graphType: currentValue!,
			])
		)
		dismiss(animated: false, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseGraphTypeViewController: UIPickerViewDataSource {
	public func numberOfComponents(in _: UIPickerView) -> Int {
		1
	}

	public func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
		GraphType.allTypes.count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseGraphTypeViewController: UIPickerViewDelegate {
	public func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
		GraphType.allTypes[row].description
	}

	public func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
		currentValue = GraphType.allTypes[row]
	}
}
