//
//  ParameterizedChooserViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

class ParameterizedChooserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	public var possibleValues: [Parameterized.Type]!
	public var currentValue: Parameterized!
	public var notificationToSendWhenAccepted: Notification.Name!

	@IBOutlet weak var valuePicker: UIPickerView!
	@IBOutlet weak var parameterStackView: UIStackView!

	override func viewDidLoad() {
		super.viewDidLoad()

		valuePicker.delegate = self
		valuePicker.dataSource = self

		if currentValue == nil {
			currentValue = possibleValues[0].init()
			valuePicker.selectRow(0, inComponent: 0, animated: false)
		} else {
			var index = 0
			for value in possibleValues {
				if value.name == type(of: currentValue).name {
					valuePicker.selectRow(index, inComponent: 0, animated: false)
					break
				}
				index += 1
			}
		}

		populateParameters()
	}

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return possibleValues.count
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return possibleValues[row].name
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		currentValue = possibleValues[row].init()
		resetParameters()
		populateParameters()
	}

	@IBAction func accepted(_ sender: Any) {
		for view in parameterStackView.arrangedSubviews {
			let containerView = view as! ContainerView<ParameterViewController>
			let controller = containerView.currentController!
			let parameter = controller.parameter!
			let parameterValue = controller.parameterValue!
			try! currentValue.set(parameter: parameter, to: parameterValue)
		}
		NotificationCenter.default.post(name: notificationToSendWhenAccepted, object: currentValue, userInfo: nil)
		_ = navigationController?.popViewController(animated: true)
	}

	fileprivate func resetParameters() {
		for view in parameterStackView.arrangedSubviews {
			parameterStackView.removeArrangedSubview(view)
		}
	}

	fileprivate func populateParameters() {
		for parameter in type(of: currentValue).parameters {
			let controller = UIStoryboard(name: "ParameterList", bundle: nil).instantiateViewController(withIdentifier: "parameterView") as! ParameterViewController
			controller.parameter = parameter
			controller.parameterValue = try! currentValue.get(parameter: parameter)
			let containerView: ContainerView<ParameterViewController> = ContainerView(parentController: self)
			containerView.install(controller)
			parameterStackView.addArrangedSubview(containerView)
		}
	}
}
