//
//  AddToQueryViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class AddToQueryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	private typealias Me = AddToQueryViewController
	private static let values = QueryViewController.CellType.allTypes.map { (type: QueryViewController.CellType) -> String in
		return type.description
	}

	public final var notificationToSendOnAccept: Notification.Name!

	@IBOutlet weak final var questionPartSelector: UIPickerView!

	final override func viewDidLoad() {
		super.viewDidLoad()
		questionPartSelector.dataSource = self
		questionPartSelector.delegate = self
	}

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return QueryViewController.CellType.allTypes.count
	}

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return Me.values[row]
	}

	@IBAction final func userClickedAccept(sender: Any?) {
		let index = questionPartSelector.selectedRow(inComponent: 0)
		var cellType: QueryViewController.CellType
		if index == 0 {
			cellType = .subDataType
		} else {
			cellType = QueryViewController.CellType.allTypes[index]
		}
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: cellType)
		dismiss(animated: true, completion: nil)
	}
}
