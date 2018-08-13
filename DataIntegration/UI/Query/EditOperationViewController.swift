//
//  EditOperationViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class EditOperationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	fileprivate typealias Me = EditOperationViewController

	fileprivate static let operationTypePickerId = "operationType"
	fileprivate static let aggregationUnitPickerId = "aggregationUnit"

	@IBOutlet weak var operationTypePicker: UIPickerView!
	@IBOutlet weak var useAggregationToggle: UISwitch!
	@IBOutlet weak var aggregationUnitPicker: UIPickerView!

	var operation: QueryOperation!

    override func viewDidLoad() {
        super.viewDidLoad()

        operationTypePicker.dataSource = self
        operationTypePicker.delegate = self
		aggregationUnitPicker.dataSource = self
		aggregationUnitPicker.delegate = self

		var selectedOperationTypeIndex = 0
		for type in QueryOperation.Kind.allTypes {
			if type == operation.kind {
				break
			}
			selectedOperationTypeIndex += 1
		}
		operationTypePicker.selectRow(selectedOperationTypeIndex, inComponent: 0, animated: false)

		if operation.aggregationUnit != nil {
			useAggregationToggle.isOn = true
			var selectedAggregationUnitIndex = 0
			for aggregation in QueryOperation.supportedAggregationUnits {
				if aggregation == operation.aggregationUnit {
					break
				}
				selectedAggregationUnitIndex += 1
			}
			aggregationUnitPicker.selectRow(selectedAggregationUnitIndex, inComponent: 0, animated: false)
		} else {
			useAggregationToggle.isOn = false
			aggregationUnitPicker.isHidden = true
			aggregationUnitPicker.isUserInteractionEnabled = false
		}
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView.restorationIdentifier! == Me.operationTypePickerId {
			return QueryOperation.Kind.allTypes.count
		} else if pickerView.restorationIdentifier! == Me.aggregationUnitPickerId {
			return QueryOperation.supportedAggregationUnits.count
		}
		return 0 // This should never happen
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView.restorationIdentifier! == Me.operationTypePickerId {
			return QueryOperation.Kind.allTypes[row].description
		} else if pickerView.restorationIdentifier! == Me.aggregationUnitPickerId {
			let component = QueryOperation.supportedAggregationUnits[row]
			return component.description
		}
		return "" // This should never happen
	}

	@IBAction func useAggregationToggleValueChanged(_ sender: Any) {
		aggregationUnitPicker.isHidden = !useAggregationToggle.isOn
		aggregationUnitPicker.isUserInteractionEnabled = useAggregationToggle.isOn
	}

	@IBAction func accepted(_ sender: Any) {
		let selectedOperationTypeIndex = operationTypePicker.selectedRow(inComponent: 0)
		operation.kind = QueryOperation.Kind.allTypes[selectedOperationTypeIndex]

		if !useAggregationToggle.isOn {
			operation.aggregationUnit = nil
		} else {
			let selectedAggregationUnitIndex = aggregationUnitPicker.selectedRow(inComponent: 0)
			operation.aggregationUnit = QueryOperation.supportedAggregationUnits[selectedAggregationUnitIndex]
		}
	}
}
