//
//  HorizontalMultiSelectAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class HorizontalMultiSelectAttributeValueViewController: UIViewController, MultiSelectSegmentedControlDelegate {

	// MARK: - IBOutlets

	@IBOutlet weak final var multiSelect: MultiSelectSegmentedControl!
	@IBOutlet weak final var saveButton: UIButton!

	// MARK: - Instance Variables

	public final var multiSelectAttribute: MultiSelectAttribute!
	public final var notificationToSendOnAccept: Notification.Name!
	public final var currentValue: Any!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		multiSelect.removeAllSegments()
		var index = 0
		for value in multiSelectAttribute.possibleValues {
			let segmentTitle = try! multiSelectAttribute.convertPossibleValueToDisplayableString(value)
			multiSelect.insertSegment(withTitle: segmentTitle, at: index, animated: false)
			index += 1
		}
		multiSelect.delegate = self

		if currentValue != nil {
			for value in try! multiSelectAttribute.valueAsArray(currentValue) {
				let index = multiSelectAttribute.indexOf(possibleValue: value)
				if index != nil {
					multiSelect.selectedSegmentIndexes.insert(index!)
				}
			}
		}
	}

	// MARK: - MultiSelectSegmentedControlDelegate

	public final func multiSelect(multiSelectSegmendedControl: MultiSelectSegmentedControl, didChangeValue value: Bool, atIndex index: Int) {
		var values = [Any]()
		for index in multiSelect.selectedSegmentIndexes {
			let value = multiSelectAttribute.possibleValues[Int(index)]
			values.append(value)
		}
		currentValue = try! multiSelectAttribute.valueFromArray(values)
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
}
