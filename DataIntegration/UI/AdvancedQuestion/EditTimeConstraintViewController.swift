//
//  EditTimeConstraintViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/8/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class EditTimeConstraintViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	fileprivate typealias Me = EditTimeConstraintViewController

	fileprivate static let mainPickerId = "mainPicker"

	fileprivate static let values: [String: [[String]]] = [
		mainPickerId: [
			TimeConstraint.StartOrEnd.allTypes.map({ (type: CustomStringConvertible) -> String in
				return type.description
			}),
			TimeConstraint.ConstraintType.allTypes.map({ (type: CustomStringConvertible) -> String in
				return type.description
			}),
		],
	]

	@IBOutlet weak var mainPicker: UIPickerView!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var dayOfWeekToggle: UISwitch!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var dayOfWeekLabel: UILabel!

	@IBOutlet weak var sundayButton: UIButton!
	@IBOutlet weak var mondayButton: UIButton!
	@IBOutlet weak var tuesdayButton: UIButton!
	@IBOutlet weak var wednesdayButton: UIButton!
	@IBOutlet weak var thursdayButton: UIButton!
	@IBOutlet weak var fridayButton: UIButton!
	@IBOutlet weak var saturdayButton: UIButton!
	fileprivate var dayOfWeekButtons: [DayOfWeek: UIButton]!

	public var timeConstraint: TimeConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
		mainPicker.dataSource = self
		mainPicker.delegate = self

		let startOrEndDate = timeConstraint.useStartOrEndDate.description
		let startOrEndDateIndex = Me.values[Me.mainPickerId]![0].firstIndex(of: startOrEndDate)!
		mainPicker.selectRow(startOrEndDateIndex, inComponent: 0, animated: false)

		let constraintTypeName = timeConstraint.constraintType.description
		let constraintTypeIndex = Me.values[Me.mainPickerId]![1].firstIndex(of: constraintTypeName)!
		mainPicker.selectRow(constraintTypeIndex, inComponent: 1, animated: false)

		dayOfWeekToggle.isOn = timeConstraint.constraintType == .on && (!timeConstraint.daysOfWeek.isEmpty || timeConstraint.specificDate == nil)

		dayOfWeekButtons = [
			DayOfWeek.Sunday: sundayButton!,
			DayOfWeek.Monday: mondayButton!,
			DayOfWeek.Tuesday: tuesdayButton!,
			DayOfWeek.Wednesday: wednesdayButton!,
			DayOfWeek.Thursday: thursdayButton!,
			DayOfWeek.Friday: fridayButton!,
			DayOfWeek.Saturday: saturdayButton!,
		]

		for dayOfWeek in timeConstraint.daysOfWeek {
			let button = dayOfWeekButtons[dayOfWeek]!
			button.isSelected = true
		}

		updateView()
    }

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return Me.values[pickerView.restorationIdentifier!]!.count
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return Me.values[pickerView.restorationIdentifier!]![component].count
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return Me.values[pickerView.restorationIdentifier!]![component][row]
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		updateView()
	}

	@IBAction func accepted(_ sender: Any) {
		let selectedStartOrEndIndex = mainPicker.selectedRow(inComponent: 0)
		let startOrEnd = TimeConstraint.StartOrEnd.allTypes[selectedStartOrEndIndex]
		timeConstraint.useStartOrEndDate = startOrEnd

		let selectedConstraintTypeIndex = mainPicker.selectedRow(inComponent: 1)
		let constraintType = TimeConstraint.ConstraintType.allTypes[selectedConstraintTypeIndex]
		timeConstraint.constraintType = constraintType

		switch (constraintType) {
			case .before, .after:
				timeConstraint.specificDate = datePicker.date
				timeConstraint.daysOfWeek = Set<DayOfWeek>()
				break
			case .on:
				if dayOfWeekToggle.isOn {
					timeConstraint.specificDate = nil
					timeConstraint.daysOfWeek = getSelectedDaysOfWeek()
				} else {
					timeConstraint.specificDate = datePicker.date
				}
				break
		}
	}

	@IBAction func dayOfWeekToggleChanged(_ sender: Any) {
		setDayOfWeekPickerEnabled(dayOfWeekToggle.isOn)
	}

	@IBAction func buttonPushed(_ button: UIButton) {
		button.isSelected = !button.isSelected
	}

	fileprivate func updateView() {
		let constraintTypeIndex = mainPicker.selectedRow(inComponent: 1)
		let selectedConstraintType = TimeConstraint.ConstraintType.allTypes[constraintTypeIndex]
		setDayOfWeekToggleEnabled(selectedConstraintType == .on)
		setDayOfWeekPickerEnabled(dayOfWeekToggle.isOn)
	}

	fileprivate func setDayOfWeekToggleEnabled(_ enabled: Bool) {
		dayOfWeekToggle.isHidden = !enabled
		dayOfWeekToggle.isUserInteractionEnabled = enabled
		dateLabel.isHidden = !enabled
		dateLabel.isUserInteractionEnabled = enabled
		dayOfWeekLabel.isHidden = !enabled
		dayOfWeekLabel.isUserInteractionEnabled = enabled
		if enabled {
			datePicker.datePickerMode = .date
		} else {
			datePicker.datePickerMode = .dateAndTime
		}
	}

	fileprivate func setDayOfWeekPickerEnabled(_ enabled: Bool) {
		for (_, button) in dayOfWeekButtons {
			button.isHidden = !enabled
			button.isUserInteractionEnabled = enabled
		}
		datePicker.isHidden = enabled
		datePicker.isUserInteractionEnabled = !enabled
	}

	fileprivate func getSelectedDaysOfWeek() -> Set<DayOfWeek> {
		var selectedDaysOfWeek = Set<DayOfWeek>()
		for (dayOfWeek, button) in dayOfWeekButtons {
			if button.isSelected {
				selectedDaysOfWeek.insert(dayOfWeek)
			}
		}
		return selectedDaysOfWeek
	}
}
