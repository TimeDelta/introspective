//
//  SelectOneAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import Common
import Samples

public final class SelectOneAttributeValueViewController: AttributeValueTypeViewController {
	// MARK: - Static Variables

	private typealias Me = SelectOneAttributeValueViewController

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var selectOnePicker: UIPickerView!

	// MARK: - Instance Variables

	public final var selectOneAttribute: SelectOneAttribute!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		selectOnePicker.delegate = self
		selectOnePicker.dataSource = self

		if let index = selectOneAttribute.indexOf(possibleValue: currentValue) {
			selectOnePicker.selectRow(index, inComponent: 0, animated: false)
		} else {
			Me.log.debug("currentValue not set for select one attribute on load")
			guard !selectOneAttribute.possibleValues.isEmpty else {
				Me.log.info("No possible values for SelectOneAttribute: %@", selectOneAttribute.name)
				var message: String?
				if selectOneAttribute is TagAttribute {
					message = "You must first create a tag."
				}
				syncPost(
					.showError,
					userInfo: [
						.title: "No \(selectOneAttribute.pluralName) to choose from",
						.message: message as Any,
					]
				)
				dismiss(animated: false)
				return
			}
			currentValue = selectOneAttribute.possibleValues[0]
		}
	}
}

// MARK: - UIPickerViewDataSource

extension SelectOneAttributeValueViewController: UIPickerViewDataSource {
	public final func numberOfComponents(in _: UIPickerView) -> Int {
		1
	}

	public final func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
		selectOneAttribute.possibleValues.count
	}
}

// MARK: - UIPickerViewDelegate

extension SelectOneAttributeValueViewController: UIPickerViewDelegate {
	public final func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
		let value = selectOneAttribute.possibleValues[row]
		do {
			return try selectOneAttribute.convertToDisplayableString(from: value)
		} catch {
			Me.log.error(
				"Failed to convert value of %@ as %@ to displayable string: %@",
				String(describing: value),
				selectOneAttribute.name,
				errorInfo(error)
			)
			return String(describing: value)
		}
	}

	public final func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
		guard row >= 0 && row < selectOneAttribute.possibleValues.count else {
			Me.log.error("Selected value out of index range for possible values: %d", row)
			return
		}
		currentValue = selectOneAttribute.possibleValues[row]
	}
}
