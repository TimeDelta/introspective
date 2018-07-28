//
//  ParameterViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class ParameterViewController: UIViewController, UIPopoverPresentationControllerDelegate {

	public var parameter: Parameter!
	public var parameterValue: Any!

	@IBOutlet weak var parameterDescriptionButton: UIButton!
	@IBOutlet weak var parameterNameLabel: UILabel!
	@IBOutlet weak var parameterValueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        parameterNameLabel.text = parameter.name + ":"

        if parameter.extendedDescription == nil {
			parameterDescriptionButton.isHidden = true
			parameterDescriptionButton.isEnabled = false
			parameterDescriptionButton.isUserInteractionEnabled = false
		}

		updateDisplay()
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
    }

	public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		segue.destination.modalPresentationStyle = UIModalPresentationStyle.popover
		segue.destination.popoverPresentationController!.delegate = self

		if segue.destination is ParameterDescriptionViewController {
			let controller = segue.destination as! ParameterDescriptionViewController
			controller.descriptionText = parameter.extendedDescription
		} else if segue.destination is ParameterValueViewController {
			let controller = segue.destination as! ParameterValueViewController
			controller.parameter = parameter
			controller.parameterValue = parameterValue
		}
	}

	@IBAction func saveParameterValue(_ segue: UIStoryboardSegue) {
		let controller = (segue.source as! ParameterValueViewController)
		parameterValue = controller.parameterValue!
		updateDisplay()
	}

	fileprivate func updateDisplay() {
		if parameterValue == nil {
			parameterValueButton.setTitle("Set value", for: .normal)
		} else {
			var parameterValueDescription = try! parameter.convertToDisplayableString(from: parameterValue)
			if parameterValueDescription.isEmpty {
				parameterValueDescription = "Set value"
			}
			parameterValueButton.setTitle(parameterValueDescription, for: .normal)
		}
	}
}
