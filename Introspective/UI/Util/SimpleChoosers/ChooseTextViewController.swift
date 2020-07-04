//
//  ChooseTextViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 5/3/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common

public protocol ChooseTextViewController: UIViewController {
	var notificationToSendOnAccept: NotificationName! { get set }
	var availableChoices: [String]! { get set }
	var selectedText: String? { get set }
}

public final class ChooseTextViewControllerImpl: UIViewController, ChooseTextViewController {
	// MARK: - IBOutlets

	@IBOutlet final var picker: UIPickerView!

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: NotificationName!
	public final var availableChoices: [String]! {
		didSet {
			guard let choices = availableChoices else { return }
			// ensure uniqueness of each choice
			var choicesSoFar = Set<String>()
			var index = 0
			for choice in choices {
				if choicesSoFar.contains(choice) {
					availableChoices.remove(at: index)
					index -= 1
				}
				choicesSoFar.insert(choice)
				index += 1
			}
		}
	}

	public final var selectedText: String?

	private final let log = Log()

	// MARK: - UIViewController Overrides

	override public final func viewDidLoad() {
		super.viewDidLoad()
		picker.dataSource = self
		picker.delegate = self
		if let selectedText = selectedText {
			if let selectedIndex = availableChoices.index(of: selectedText) {
				picker.selectRow(selectedIndex, inComponent: 0, animated: false)
			} else {
				log.error("Could not find index for specified component")
			}
		} else if !availableChoices.isEmpty {
			selectedText = availableChoices[0]
		} else {
			log.error("No text values passed")
			dismiss(animated: false)
		}
	}

	// MARK: - Button Actions

	@IBAction final func userPressedAccept(_: Any) {
		syncPost(notificationToSendOnAccept, userInfo: [.text: selectedText as Any])
		dismiss(animated: false, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseTextViewControllerImpl: UIPickerViewDataSource {
	public final func numberOfComponents(in _: UIPickerView) -> Int {
		1
	}

	public final func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
		availableChoices.count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseTextViewControllerImpl: UIPickerViewDelegate {
	public final func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
		availableChoices[row]
	}

	public final func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
		selectedText = availableChoices[row]
	}
}
