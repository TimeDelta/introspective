//
//  EditAttributeRestrictionViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class EditAttributeRestrictionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverPresentationControllerDelegate, UITextViewDelegate {

	fileprivate typealias Me = EditAttributeRestrictionViewController

	fileprivate static let numberRegex = "[0-9]*.?[0-9]+"

	@IBOutlet weak var operationInfoButton: UIButton!
	@IBOutlet weak var operationLabel: UILabel!
	@IBOutlet weak var useOperationToggle: UISwitch!
	@IBOutlet weak var chooseOperationButton: UIButton!
	@IBOutlet weak var attributePicker: UIPickerView!
	@IBOutlet weak var comparisonTypePicker: UIPickerView!
	@IBOutlet weak var valuesTextView: UITextView!
	@IBOutlet weak var validationLabel: UILabel!
	@IBOutlet weak var acceptButton: UIButton!

	var attributeRestriction: AttributeRestriction!
	var dataType: DataTypes!

    override func viewDidLoad() {
        super.viewDidLoad()

        attributePicker.dataSource = self
        attributePicker.delegate = self
        comparisonTypePicker.dataSource = self
        comparisonTypePicker.delegate = self

        valuesTextView.delegate = self

        acceptButton.setTitle("Must fix issues", for: .disabled)
        acceptButton.setTitle("Accept", for: .normal)

        if attributeRestriction.operation != nil {
			useOperationToggle.setOn(true, animated: false)
		}
		updateChooseOperationButtonDisplay()

		let comparisonTypes = getComparisonTypesForSelectedAttribute()
		var index: Int = 0
		for type in comparisonTypes {
			if type == attributeRestriction.comparison {
				comparisonTypePicker.selectRow(index, inComponent: 0, animated: false)
				break
			}
			index += 1
		}

		var valueText = ""
		for value in attributeRestriction.values {
			if !valueText.isEmpty {
				valueText += "\n"
			}
			valueText += String(describing: value)
		}
		valuesTextView.text = valueText

        validate()
    }

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == attributePicker {
			return Attribute.attributesFor(dataType: dataType).count
		}
		if pickerView == comparisonTypePicker {
			return getComparisonTypesForSelectedAttribute().count
		}
		return 0 // This should never happen
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == attributePicker {
			return Attribute.attributesFor(dataType: dataType)[row].description
		}
		if pickerView == comparisonTypePicker {
			return getComparisonTypesForSelectedAttribute()[row].description
		}
		return "" // This should never happen
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		updateComparisonTypeOptions()
		let selectedAttribute = getSelectedAttribute()
		setOperationSelection(enabled: selectedAttribute.isQuantity)
		validate()
	}

	public func textViewDidChange(_ textView: UITextView) {
		validate()
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is EditOperationViewController {
			let controller = (segue.destination as! EditOperationViewController)
			if attributeRestriction.operation == nil {
				attributeRestriction.operation = QueryOperation(.sum, dataType.defaultDependentAttribute)
			}
			controller.operation = attributeRestriction.operation
		}

		if !(segue.destination is AdvancedQuestionViewController) {
			segue.destination.modalPresentationStyle = UIModalPresentationStyle.popover
            segue.destination.popoverPresentationController!.delegate = self
		}
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

	@IBAction func useOperationToggleValueChanged(_ sender: Any) {
		updateChooseOperationButtonDisplay()
	}

	@IBAction func accepted(_ sender: Any) {
		attributeRestriction.attribute = getSelectedAttribute()
		attributeRestriction.comparison = getSelectedComparisonType()

		if !useOperationToggle.isOn {
			attributeRestriction.operation = nil
		}

		let strValues = getValues()
		if attributeRestriction.attribute.isQuantity {
			var values = [Double]()
			for value in strValues {
				values.append(Double(value)!)
			}
			attributeRestriction.values = values
		}
	}

	@IBAction func saveEditedOperation(_ segue: UIStoryboardSegue) {
		let controller = (segue.source as! EditOperationViewController)
		attributeRestriction.operation = controller.operation
		updateChooseOperationButtonDisplay()
	}

	fileprivate func updateChooseOperationButtonDisplay() {
		chooseOperationButton.isHidden = !useOperationToggle.isOn
		chooseOperationButton.isEnabled = useOperationToggle.isOn
		if chooseOperationButton.isEnabled {
			let text: String = attributeRestriction.operation?.description ?? "Choose Operation"
			chooseOperationButton.setTitle(text, for: UIControl.State.normal)
		}
	}

	fileprivate func updateComparisonTypeOptions() {
		comparisonTypePicker.reloadInputViews()
	}

	fileprivate func getComparisonTypesForSelectedAttribute() -> [AttributeComparisonType] {
		let attribute = getSelectedAttribute()
		return AttributeComparisonType.typesFor(attribute: attribute)
	}

	fileprivate func getSelectedAttribute() -> Attribute {
		let selectedAttributeIndex = attributePicker.selectedRow(inComponent: 0)
		return Attribute.attributesFor(dataType: dataType)[selectedAttributeIndex]
	}

	fileprivate func getSelectedComparisonType() -> AttributeComparisonType {
		let selectedComparisonTypeIndex = comparisonTypePicker.selectedRow(inComponent: 0)
		return getComparisonTypesForSelectedAttribute()[selectedComparisonTypeIndex]
	}

	fileprivate func getValues() -> [String] {
		return valuesTextView.text.split(separator: "\n").map({ (substr: Substring) -> String in
			return String(substr)
		})
	}

	fileprivate func validate() {
		let values = getValues()
		if values.count == 0 {
			setInvalidState("Must specify a value")
			return
		}

		let selectedComparisonType = getSelectedComparisonType()
		if selectedComparisonType != .isOneOf && values.count > 1 {
			setInvalidState("Can only specify one value")
			return
		}

		let selectedAttribute = getSelectedAttribute()
		if selectedAttribute.isQuantity {
			for value in values {
				if !DependencyInjector.util.stringUtil.isNumber(value) {
					setInvalidState("Invalid number: \"\(value)\"")
					return
				}
			}
		}

		if attributeRestriction.operation == nil && useOperationToggle.isOn {
			setInvalidState("Must choose operation or specify that no operation is to be used")
			return
		}

		setValidState()
	}

	fileprivate func setInvalidState(_ message: String) {
		disableAcceptButton()
		validationLabel.text = message
		validationLabel.reloadInputViews()
	}

	fileprivate func setValidState() {
		enableAcceptButton()
		validationLabel.text = ""
		validationLabel.reloadInputViews()
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

	fileprivate func setOperationSelection(enabled: Bool) {
		operationInfoButton.isUserInteractionEnabled = enabled
		operationInfoButton.isEnabled = enabled
		operationInfoButton.isHidden = !enabled

		operationLabel.isUserInteractionEnabled = enabled
		operationLabel.isEnabled = enabled
		operationLabel.isHidden = !enabled

		useOperationToggle.isUserInteractionEnabled = enabled
		useOperationToggle.isEnabled = enabled
		useOperationToggle.isHidden = !enabled

		chooseOperationButton.isUserInteractionEnabled = enabled
		chooseOperationButton.isEnabled = enabled
		chooseOperationButton.isHidden = !enabled
	}
}
