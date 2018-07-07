//
//  AddToAdvancedQuestionViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class AddToAdvancedQuestionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	fileprivate typealias Me = AddToAdvancedQuestionViewController

	fileprivate static let values = AdvancedQuestionViewController.CellType.allTypes.map { (type: AdvancedQuestionViewController.CellType) -> String in
		return type.description
	}

	@IBOutlet weak var dataTypeSelector: UIPickerView!

	override func viewDidLoad() {
		super.viewDidLoad()
		dataTypeSelector.dataSource = self
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return AdvancedQuestionViewController.CellType.allTypes.count
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return Me.values[row]
	}

	@IBAction func accepted(_ sender: Any) {
	}
}
