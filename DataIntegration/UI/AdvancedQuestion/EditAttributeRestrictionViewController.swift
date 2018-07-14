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

	fileprivate static let attributePickerId = "attribute"
	fileprivate static let comparisonPickerId = "comparison"
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

        validate()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is EditOperationViewController {
			let controller = (segue.destination as! EditOperationViewController)
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

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView.restorationIdentifier! == Me.attributePickerId {
			return Attributes.attributesFor(dataType: dataType).count
		} else if pickerView.restorationIdentifier! == Me.comparisonPickerId {
			return getComparisonTypesForSelectedAttribute().count
		}
		return 0 // This should never happen
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView.restorationIdentifier! == Me.attributePickerId {
			return Attributes.attributesFor(dataType: dataType)[row].description
		} else if pickerView.restorationIdentifier! == Me.comparisonPickerId {
			return getComparisonTypesForSelectedAttribute()[row].description
		}
		return "" // This should never happen
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		updateComparisonTypeOptions()
		let selectedAttribute = getSelectedAttribute()
		setOperationSelection(enabled: selectedAttribute.type == .quantity)
		validate()
	}

	public func textViewDidChange(_ textView: UITextView) {
		validate()
	}

	@IBAction func useOperationToggleValueChanged(_ sender: Any) {
		chooseOperationButton.isHidden = !useOperationToggle.isOn
		chooseOperationButton.isEnabled = useOperationToggle.isOn
	}

	@IBAction func accepted(_ sender: Any) {
		attributeRestriction.attribute = getSelectedAttribute()
		attributeRestriction.comparison = getSelectedComparisonType()

		if !useOperationToggle.isOn {
			attributeRestriction.operation = nil
		}

		let strValues = getValues()
		if attributeRestriction.attribute.type == .quantity {
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
		chooseOperationButton.setTitle(controller.operation.description, for: UIControl.State.normal)
		chooseOperationButton.titleLabel!.text = controller.operation.description
	}

	fileprivate func updateComparisonTypeOptions() {
		comparisonTypePicker.reloadInputViews()
	}

	fileprivate func getComparisonTypesForSelectedAttribute() -> [AttributeRestriction.ComparisonType] {
		let attribute = getSelectedAttribute()
		return AttributeRestriction.ComparisonType.typesFor(attribute: attribute)
	}

	fileprivate func getSelectedAttribute() -> Attributes {
		let selectedAttributeIndex = attributePicker.selectedRow(inComponent: 0)
		return Attributes.attributesFor(dataType: dataType)[selectedAttributeIndex]
	}

	fileprivate func getSelectedComparisonType() -> AttributeRestriction.ComparisonType {
		let selectedComparisonTypeIndex = comparisonTypePicker.selectedRow(inComponent: 0)
		return getComparisonTypesForSelectedAttribute()[selectedComparisonTypeIndex]
	}

	fileprivate func getValues() -> [String] {
		return valuesTextView.text.split(separator: "\n").map({ (substr: Substring) -> String in
			return String(substr)
		})
	}

	fileprivate func isNumber(_ str: String) -> Bool {
		return str.range(of: Me.numberRegex, options: .regularExpression, range: nil, locale: nil) != nil
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
		if selectedAttribute.type == .quantity {
			for value in values {
				if !isNumber(value) {
					setInvalidState("Invalid number: \"\(value)\"")
					return
				}
			}
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
	}

	fileprivate func enableAcceptButton() {
		acceptButton.isEnabled = true
		acceptButton.isUserInteractionEnabled = true
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
