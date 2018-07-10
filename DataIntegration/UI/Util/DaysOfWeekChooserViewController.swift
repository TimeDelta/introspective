//
//  DayOfWeekChooser.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class DaysOfWeekChooserViewController: UIViewController {


	@IBOutlet weak var sundayButton: UIButton!
	@IBOutlet weak var mondayButton: UIButton!
	@IBOutlet weak var tuesdayButton: UIButton!
	@IBOutlet weak var wednesdayButton: UIButton!
	@IBOutlet weak var thursdayButton: UIButton!
	@IBOutlet weak var fridayButton: UIButton!
	@IBOutlet weak var saturdayButton: UIButton!

	fileprivate var buttons: [DayOfWeek: UIButton]!

	override func viewDidLoad() {
		buttons = [
			DayOfWeek.Sunday: sundayButton!,
			DayOfWeek.Monday: mondayButton!,
			DayOfWeek.Tuesday: tuesdayButton!,
			DayOfWeek.Wednesday: wednesdayButton!,
			DayOfWeek.Thursday: thursdayButton!,
			DayOfWeek.Friday: fridayButton!,
			DayOfWeek.Saturday: saturdayButton!,
		]
		for (_, button) in buttons {
			prepareButton(button)
		}
	}

	public func prepareButtons() {
		for (_, button) in buttons {
			prepareButton(button)
		}
	}

	public func select(_ dayOfWeek: DayOfWeek) {
		buttons[dayOfWeek]!.isSelected = true
	}

	public func getSelectedDaysOfWeek() -> Set<DayOfWeek> {
		var selectedDaysOfWeek = Set<DayOfWeek>()
		for (dayOfWeek, button) in buttons {
			if button.isSelected {
				selectedDaysOfWeek.insert(dayOfWeek)
			}
		}
		return selectedDaysOfWeek
	}

	@IBAction func buttonPushed(_ button: UIButton) {
		if button.isSelected {
			deselectButton(button)
		} else {
			selectButton(button)
		}
	}

	fileprivate func prepareButton(_ button: UIButton) {
		button.layer.borderColor = UIColor.blue.cgColor
		button.layer.cornerRadius = 2
		if button.isSelected {
			selectButton(button)
		} else {
			deselectButton(button)
		}
	}

	fileprivate func selectButton(_ button: UIButton) {
		button.isSelected = true
		button.backgroundColor = UIColor.blue
	}

	fileprivate func deselectButton(_ button: UIButton) {
		button.isSelected = false
		button.backgroundColor = UIColor.white
	}
}
