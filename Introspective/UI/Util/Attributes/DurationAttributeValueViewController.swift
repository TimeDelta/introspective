//
//  DurationAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 11/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common

public final class DurationAttributeValueViewController: AttributeValueTypeViewController {
	// MARK: - IBOutlets

	@IBOutlet final var daysTextField: UITextField!
	@IBOutlet final var hoursTextField: UITextField!
	@IBOutlet final var minutesTextField: UITextField!
	@IBOutlet final var secondsTextField: UITextField!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		valueIsValid()

		guard let duration = currentValue as? Duration else { return }

		let units = duration.units()
		if let days = units[.day] {
			daysTextField.text = String(days)
		}
		if let hours = units[.hour] {
			hoursTextField.text = String(hours)
		}
		if let minutes = units[.minute] {
			minutesTextField.text = String(minutes)
		}
		if let seconds = units[.second] {
			secondsTextField.text = String(seconds)
		}
	}

	// MARK: - Actions

	@IBAction final func valueChanged(_: Any) {
		var units = [Calendar.Component: Int]()
		if let days = Int(daysTextField.text ?? "0") {
			units[.day] = days
		}
		if let hours = Int(hoursTextField.text ?? "0") {
			units[.hour] = hours
		}
		if let minutes = Int(minutesTextField.text ?? "0") {
			units[.minute] = minutes
		}
		if let seconds = Int(secondsTextField.text ?? "0") {
			units[.second] = seconds
		}
		currentValue = Duration(units)
	}
}
