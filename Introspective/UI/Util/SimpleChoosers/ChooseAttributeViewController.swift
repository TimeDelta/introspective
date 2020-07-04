//
//  ChooseAttributeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import Common

final class ChooseAttributeViewController: UIViewController {
	// MARK: - IBOutlets

	@IBOutlet final var attributePicker: UIPickerView!
	@IBOutlet final var acceptButton: UIButton!

	// MARK: - Instance Variables

	public final var attributes: [Attribute]!
	public final var selectedAttribute: Attribute?
	public final var notificationToSendOnAccept: NotificationName!
	public final var acceptButtonTitle = "Save"

	private final let log = Log()

	// MARK: - UIViewController Overrides

	override final func viewDidLoad() {
		super.viewDidLoad()
		attributePicker.dataSource = self
		attributePicker.delegate = self
		acceptButton.setTitle(acceptButtonTitle, for: .normal)
		if selectedAttribute != nil {
			if let selectedIndex = attributes.index(where: { $0.equalTo(selectedAttribute!) }) {
				attributePicker.selectRow(selectedIndex, inComponent: 0, animated: false)
			} else {
				log.error("Could not find index for specified component")
			}
		} else if !attributes.isEmpty {
			selectedAttribute = attributes[0]
		} else {
			log.error("No attributes passed")
		}
	}

	// MARK: - Button Actions

	@IBAction final func userPressedAccept(_: Any) {
		syncPost(notificationToSendOnAccept, userInfo: [.attribute: selectedAttribute as Any])
		dismiss(animated: false, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseAttributeViewController: UIPickerViewDataSource {
	public final func numberOfComponents(in _: UIPickerView) -> Int {
		1
	}

	public final func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
		attributes.count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseAttributeViewController: UIPickerViewDelegate {
	public final func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
		attributes[row].name.localizedCapitalized
	}

	public final func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
		selectedAttribute = attributes[row]
	}
}
