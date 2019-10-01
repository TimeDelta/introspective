//
//  ChooseSampleGrouperTypeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 5/3/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import SampleGroupers
import UIExtensions

public protocol ChooseSampleGrouperTypeViewController: UIViewController {
	var grouperTypes: [SampleGrouper.Type]! { get set }
	var selectedGrouperType: SampleGrouper.Type? { get set }
}

public final class ChooseSampleGrouperTypeViewControllerImpl: UIViewController, ChooseSampleGrouperTypeViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var picker: UIPickerView!

	// MARK: - Instance Variables

	public final var grouperTypes: [SampleGrouper.Type]!
	public final var selectedGrouperType: SampleGrouper.Type?

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		picker.dataSource = self
		picker.delegate = self
		if let selectedGrouperType = selectedGrouperType {
			if let selectedIndex = grouperTypes.index(where: { $0 == selectedGrouperType }) {
				picker.selectRow(selectedIndex, inComponent: 0, animated: false)
			} else {
				log.error("Could not find index for specified component")
			}
		} else if grouperTypes.count > 0 {
			selectedGrouperType = grouperTypes[0]
		} else {
			log.error("No groupers passed")
			dismiss(animated: false)
		}
	}

	// MARK: - Button Actions

	@IBAction final func userPressedAccept(_ sender: Any) {
		syncPost(.grouperTypeChanged, userInfo: [ .sampleGrouper: selectedGrouperType as Any ])
		dismiss(animated: false, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseSampleGrouperTypeViewControllerImpl: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return grouperTypes.count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseSampleGrouperTypeViewControllerImpl: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return grouperTypes[row].userVisibleDescription.localizedCapitalized
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedGrouperType = grouperTypes[row]
	}
}
