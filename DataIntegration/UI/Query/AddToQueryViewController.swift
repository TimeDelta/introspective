//
//  AddToQueryViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class AddToQueryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	fileprivate typealias Me = AddToQueryViewController

	fileprivate static let values = QueryViewController.CellType.allTypes.map { (type: QueryViewController.CellType) -> String in
		return type.description
	}

	@IBOutlet weak var questionPartSelector: UIPickerView!

	var cellType: QueryViewController.CellType!

	override func viewDidLoad() {
		super.viewDidLoad()
		questionPartSelector.dataSource = self
		questionPartSelector.delegate = self
	}

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return QueryViewController.CellType.allTypes.count
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
				cellType = QueryViewController.CellType.allTypes[index]
			}
		}
	}
}
