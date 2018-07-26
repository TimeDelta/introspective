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

	public var possibleValues: [Parameterized]!
	public var currentValue: Parameterized!

	@IBOutlet weak var valuePicker: UIPickerView!
	@IBOutlet weak var parameterStackView: UIStackView!

	override func viewDidLoad() {
		super.viewDidLoad()

		if currentValue == nil {
			currentValue = possibleValues![0]
			valuePicker.selectRow(0, inComponent: 0, animated: false)
		} else {
			var index = 0
			for value in possibleValues {
				if type(of: value).name == type(of: currentValue).name {
					valuePicker.selectRow(index, inComponent: 0, animated: false)
					break
				}
				index += 1
			}
		}

		valuePicker.delegate = self
		valuePicker.dataSource = self

		populateParameters()
	}

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return possibleValues.count
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return type(of: possibleValues[row]).name
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		currentValue = possibleValues[row]
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
			let containerView: ContainerView<ParameterViewController> = ContainerView(parentController: self)
			containerView.install(controller)
			parameterStackView.addArrangedSubview(containerView)
		}
	}
}

class ContainerView<T: UIViewController>: UIView {

	unowned var parentController: UIViewController
	weak var currentController: T?

	init(parentController: UIViewController) {
		self.parentController = parentController
		super.init(frame: CGRect.zero)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func install(_ controller: T) {
		removeCurrentController()
		currentController = controller
		setUpViewController(controller, animated: false)
	}

	func uninstall() {
		removeCurrentController()
	}

	fileprivate func setUpViewController(_ targetController: T?, animated: Bool) {
		if let controller = targetController {
			parentController.addChild(controller)
			controller.view.frame = self.bounds
			self.addSubview(controller.view)
			controller.didMove(toParent: parentController)
		}
	}

	fileprivate func removeCurrentController() {
		if let _viewController = currentController {
			_viewController.willMove(toParent: nil)
			_viewController.view.removeFromSuperview()
			_viewController.removeFromParent()
			currentController = nil
		}
	}
}
