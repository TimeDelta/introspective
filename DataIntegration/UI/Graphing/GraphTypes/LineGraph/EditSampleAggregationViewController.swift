//
//  EditSampleAggregationViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class EditSampleAggregationViewController: UIViewController {

	// MARK: - Static Member Variables

	private typealias Me = EditSampleAggregationViewController
	private static let changedGrouper = Notification.Name("changedGrouper")

	// MARK: - Instance Member Variables

	public final var notificationToSendOnAccept: Notification.Name!
	public final var currentAggregator: SampleAggregator!

	// MARK: - IBOutlets

	@IBOutlet weak final var groupByLabel: UILabel!
	@IBOutlet weak final var groupByButton: UIButton!
	@IBOutlet weak final var combineValuesByLabel: UILabel!
	@IBOutlet weak final var valueCombinationMethodPicker: UIPickerView!
	@IBOutlet weak final var validationLabel: UILabel!
	@IBOutlet weak final var acceptButton: UIButton!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		validate()

		groupByLabel.text = "Group " + currentAggregator.groupByAttribute.pluralName.localizedLowercase
		combineValuesByLabel.text = "Combine " + currentAggregator.combinationAttribute.pluralName.localizedLowercase + " by:"

		valueCombinationMethodPicker.delegate = self
		valueCombinationMethodPicker.dataSource = self

		if currentAggregator.grouper != nil {
			groupByButton.setTitle(currentAggregator.grouper.description, for: .normal)
		}
		if currentAggregator.groupCombiner == nil {
			currentAggregator.groupCombiner = validCombinerTypes()[0].init()
		}
		let currentType = type(of: currentAggregator.groupCombiner!)
		let currentTypeIndex = validCombinerTypes().index(where: { type in type.name == currentType.name })
		if currentTypeIndex == nil {
			currentAggregator.groupCombiner = validCombinerTypes()[0].init()
			valueCombinationMethodPicker.selectRow(0, inComponent: 0, animated: false)
		} else {
			valueCombinationMethodPicker.selectRow(currentTypeIndex!, inComponent: 0, animated: false)
		}

		NotificationCenter.default.addObserver(self, selector: #selector(grouperChanged), name: Me.changedGrouper, object: nil)
	}

	// MARK: - Navigation

	public final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is AttributedChooserViewController {
			let controller = segue.destination as! AttributedChooserViewController
			controller.notificationToSendWhenAccepted = Me.changedGrouper
			controller.currentValue = currentAggregator.grouper
			controller.possibleValues = validGroupers()
		}
	}

	// MARK: - Actions

	@IBAction public final func acceptButtonPressed(_ sender: Any) {
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: currentAggregator)
		navigationController?.popViewController(animated: true)
	}

	// MARK: - Received Notifications

	@objc public final func grouperChanged(notification: Notification) {
		currentAggregator.grouper = (notification.object as! SampleGrouper)
		groupByButton.setTitle(currentAggregator.grouper.description, for: .normal)
		validate()
		navigationController?.popViewController(animated: true)
	}

	// MARK: - Helper Functions

	private final func validCombinerTypes() -> [SampleGroupCombiner.Type] {
		return DependencyInjector.sampleGroupCombiner.typesFor(attribute: currentAggregator.combinationAttribute)
	}

	private final func validGroupers() -> [SampleGrouper] {
		return DependencyInjector.sampleGrouper.groupersFor(attribute: currentAggregator.groupByAttribute)
	}

	private final func validate() {
		if currentAggregator.grouper == nil {
			setInvalidState("Must choose a way to group samples")
			return
		}
		setValidState()
	}

	private final func setInvalidState(_ message: String) {
		disableAcceptButton()
		validationLabel.text = message
	}

	private final func setValidState() {
		enableAcceptButton()
		validationLabel.text = ""
	}

	private final func disableAcceptButton() {
		acceptButton.isEnabled = false
		acceptButton.isUserInteractionEnabled = false
		acceptButton.backgroundColor = UIColor.gray
	}

	private final func enableAcceptButton() {
		acceptButton.isEnabled = true
		acceptButton.isUserInteractionEnabled = true
		acceptButton.backgroundColor = UIColor.black
	}
}

// MARK: - UIPickerViewDataSource

extension EditSampleAggregationViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return validCombinerTypes().count
	}
}

// MARK: - UIPickerViewDelegate

extension EditSampleAggregationViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return validCombinerTypes()[row].name
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		currentAggregator.groupCombiner = validCombinerTypes()[row].init()
	}
}
