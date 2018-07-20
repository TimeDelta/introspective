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

	@IBOutlet weak var questionPartSelector: UIPickerView!

	var cellType: AdvancedQuestionViewController.CellType!

	override func viewDidLoad() {
		super.viewDidLoad()
		questionPartSelector.dataSource = self
		questionPartSelector.delegate = self
	}

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return AdvancedQuestionViewController.CellType.allTypes.count
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return Me.values[row]
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "addQuestionPart" {
			let index = questionPartSelector.selectedRow(inComponent: 0)
			if index == 0 {
				cellType = .subDataType
			} else {
				cellType = AdvancedQuestionViewController.CellType.allTypes[index]
			}
		}
	}
}
