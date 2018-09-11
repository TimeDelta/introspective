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
	private static let values = QueryViewController.PartType.allTypes.map { $0.description }

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
		return Me.values.count
	}

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return Me.values[row]
	}

	@IBAction final func userClickedAccept(sender: Any?) {
		let index = questionPartSelector.selectedRow(inComponent: 0)
		let cellType = QueryViewController.PartType.allTypes[index]
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: cellType)
		dismiss(animated: true, completion: nil)
	}
}
