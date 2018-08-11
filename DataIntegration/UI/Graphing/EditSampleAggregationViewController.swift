//
//  EditSampleAggregationViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class EditSampleAggregationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	fileprivate typealias Me = EditSampleAggregationViewController
	fileprivate static let changedGrouper = Notification.Name("changedGrouper")

	public var currentAggregator: SampleAggregator!

	@IBOutlet weak var groupByLabel: UILabel!
	@IBOutlet weak var groupByButton: UIButton!
	@IBOutlet weak var combineValuesByLabel: UILabel!
	@IBOutlet weak var valueCombinationMethodPicker: UIPickerView!
	@IBOutlet weak var validationLabel: UILabel!
	@IBOutlet weak var acceptButton: UIButton!

	public override func viewDidLoad() {
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
		let currentTypeIndex = validCombinerTypes().firstIndex(where: { type in type.name == currentType.name })
		if currentTypeIndex == nil {
			currentAggregator.groupCombiner = validCombinerTypes()[0].init()
			valueCombinationMethodPicker.selectRow(0, inComponent: 0, animated: false)
		} else {
			valueCombinationMethodPicker.selectRow(currentTypeIndex!, inComponent: 0, animated: false)
		}

		NotificationCenter.default.addObserver(self, selector: #selector(grouperChanged), name: Me.changedGrouper, object: nil)
	}

	// MARK: - UIPickerViewDataSource

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return validCombinerTypes().count
	}

	// MARK: - UIPickerViewDelegate

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return validCombinerTypes()[row].name
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		currentAggregator.groupCombiner = validCombinerTypes()[row].init()
	}

	// MARK: - Navigation

	public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is AttributedChooserViewController {
			let controller = segue.destination as! AttributedChooserViewController
			controller.notificationToSendWhenAccepted = Me.changedGrouper
			controller.currentValue = currentAggregator.grouper
			controller.possibleValues = validGroupers()
		}
	}

	// MARK: - Callbacks

	@objc public func grouperChanged(notification: Notification) {
		currentAggregator.grouper = (notification.object as! SampleGrouper)
		groupByButton.setTitle(currentAggregator.grouper.description, for: .normal)
		validate()
		_ = navigationController?.popViewController(animated: true)
	}

	// MARK: - Helper Functions

	fileprivate func validCombinerTypes() -> [SampleGroupCombiner.Type] {
		return DependencyInjector.sampleGroupCombiner.typesFor(attribute: currentAggregator.combinationAttribute)
	}

	fileprivate func validGroupers() -> [SampleGrouper] {
		return DependencyInjector.sampleGrouper.groupersFor(attribute: currentAggregator.groupByAttribute)
	}

	fileprivate func validate() {
		if currentAggregator.grouper == nil {
			setInvalidState("Must choose a way to group samples")
			return
		}
		setValidState()
	}

	fileprivate func setInvalidState(_ message: String) {
		disableAcceptButton()
		validationLabel.text = message
	}

	fileprivate func setValidState() {
		enableAcceptButton()
		validationLabel.text = ""
	}

	fileprivate func disableAcceptButton() {
		acceptButton.isEnabled = false
		acceptButton.isUserInteractionEnabled = false
		acceptButton.backgroundColor = UIColor.gray
	}

	fileprivate func enableAcceptButton() {
		acceptButton.isEnabled = true
		acceptButton.isUserInteractionEnabled = true
		acceptButton.backgroundColor = UIColor.black
	}
}
