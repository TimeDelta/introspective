//
//  HorizontalMultiSelectAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import Common

final class HorizontalMultiSelectAttributeValueViewController: UIViewController, MultiSelectSegmentedControlDelegate {

	// MARK: - IBOutlets

	@IBOutlet weak final var multiSelect: MultiSelectSegmentedControl!
	@IBOutlet weak final var saveButton: UIButton!

	// MARK: - Instance Variables

	public final var multiSelectAttribute: MultiSelectAttribute!
	public final var notificationToSendOnAccept: Notification.Name!
	public final var currentValue: Any!

	private final let log = Log()

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		multiSelect.removeAllSegments()
		populatePossibleValues()
		multiSelect.delegate = self

		if currentValue != nil {
			updateCurrentValue()
		}
	}

	// MARK: - MultiSelectSegmentedControlDelegate

	public final func multiSelect(multiSelectSegmendedControl: MultiSelectSegmentedControl, didChangeValue value: Bool, atIndex index: Int) {
		var values = [Any]()
		for index in multiSelect.selectedSegmentIndexes {
			let value = multiSelectAttribute.possibleValues[Int(index)]
			values.append(value)
		}
		do {
			currentValue = try multiSelectAttribute.valueFromArray(values)
		} catch {
			log.error("Failed to turn %@ as %@ into array: %@", String(describing: values), multiSelectAttribute.name, errorInfo(error))
		}
	}

	// MARK: - Actions

	@IBAction final func saveButtonPressed(_ sender: Any) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: self.info([
					.attributeValue: self.currentValue,
				]))
		}
		dismiss(animated: false, completion: nil)
	}

	// MARK: - Helper Functions

	private final func populatePossibleValues() {
		var index = 0
		for value in multiSelectAttribute.possibleValues {
			do {
				let segmentTitle = try multiSelectAttribute.convertPossibleValueToDisplayableString(value)
				multiSelect.insertSegment(withTitle: segmentTitle, at: index, animated: false)
				index += 1
			} catch {
				log.error(
					"Failed to convert %@ as %@ to displayable string: %@",
					String(describing: value),
					multiSelectAttribute.name,
					errorInfo(error))
			}
		}
	}

	 private final func updateCurrentValue() {
		do {
			let valueArray = try multiSelectAttribute.valueAsArray(currentValue)
			for value in valueArray {
				let index = multiSelectAttribute.indexOf(possibleValue: value)
				if index != nil {
					multiSelect.selectedSegmentIndexes.insert(index!)
				}
			}
		} catch {
			log.error(
				"Failed to convert %@ as %@ into array: %@",
				String(describing: currentValue),
				multiSelectAttribute.name,
				errorInfo(error))
		}
	}
}
