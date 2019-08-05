//
//  SelectOneAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class SelectOneAttributeValueViewController: AttributeValueTypeViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var selectOnePicker: UIPickerView!

	// MARK: - Instance Variables

	public final var selectOneAttribute: SelectOneAttribute!
	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		selectOnePicker.delegate = self
		selectOnePicker.dataSource = self

		if let index = selectOneAttribute.indexOf(possibleValue: currentValue) {
			selectOnePicker.selectRow(index, inComponent: 0, animated: false)
		} else {
			log.debug("currentValue not set for select one attribute on load")
			guard selectOneAttribute.possibleValues.count > 0 else {
				log.info("No possible values for SelectOneAttribute: %@", selectOneAttribute.name)
				var message: String? = nil
				if selectOneAttribute is TagAttribute {
					message = "You must first create a tag."
				}
				syncPost(
					.showError,
					userInfo: [
						.title: "No \(selectOneAttribute.pluralName) to choose from",
						.message: message as Any
					])
				dismiss(animated: false)
				return
			}
			currentValue = selectOneAttribute.possibleValues[0]
		}
	}
}

// MARK: - UIPickerViewDataSource

extension SelectOneAttributeValueViewController: UIPickerViewDataSource {
	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return selectOneAttribute.possibleValues.count
	}
}

// MARK: - UIPickerViewDelegate

extension SelectOneAttributeValueViewController: UIPickerViewDelegate {
	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let value = selectOneAttribute.possibleValues[row]
		do {
			return try selectOneAttribute.convertToDisplayableString(from: value)
		} catch {
			log.error(
				"Failed to convert value of %@ as %@ to displayable string: %@",
				String(describing: value),
				selectOneAttribute.name,
				errorInfo(error))
			return String(describing: value)
		}
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		guard row >= 0 && row < selectOneAttribute.possibleValues.count else {
			log.error("Selected value out of index range for possible values: %d", row)
			return
		}
		currentValue = selectOneAttribute.possibleValues[row]
	}
}
