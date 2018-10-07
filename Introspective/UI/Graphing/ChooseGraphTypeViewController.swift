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

	@IBOutlet weak final var graphTypePicker: UIPickerView!

	// MARK: - Instance Member Variables

	public final var currentValue: GraphType?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
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

	@IBAction final func acceptButtonPressed(sender: Any) {
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: currentValue!)
		dismiss(animated: false, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseGraphTypeViewController: UIPickerViewDataSource {

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return GraphType.allTypes.count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseGraphTypeViewController: UIPickerViewDelegate {

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return GraphType.allTypes[row].description
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		currentValue = GraphType.allTypes[row]
	}
}
