//
//  SelectDurationViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/19/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import UIExtensions

public protocol SelectDurationViewController: UIViewController {

	var initialDuration: Duration? { get set }
	var notificationToSendOnAccept: Notification.Name! { get set }
}

public class SelectDurationViewControllerImpl: UIViewController, SelectDurationViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var daysTextField: UITextField!
	@IBOutlet weak final var hoursTextField: UITextField!
	@IBOutlet weak final var minutesTextField: UITextField!
	@IBOutlet weak final var secondsTextField: UITextField!

	// MARK: - Instance Variables

	public final var initialDuration: Duration?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		guard let duration = initialDuration else { return }

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

	@IBAction final func saveButtonPressed(_ sender: Any) {
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
		let duration = Duration(units)
		syncPost(
			notificationToSendOnAccept,
			object: self,
			userInfo: [
				.duration: duration
			])
		dismiss(animated: false, completion: nil)
	}
}