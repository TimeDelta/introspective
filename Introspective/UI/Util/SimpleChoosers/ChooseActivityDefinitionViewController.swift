//
//  ChooseActivityDefinitionViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 11/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import CoreData

public protocol ChooseActivityDefinitionViewController: UIViewController {

	var notificationToSendOnAccept: Notification.Name! { get set }
	var availableDefinitions: [ActivityDefinition]! { get set }
	var selectedDefinition: ActivityDefinition? { get set }
}

public final class ChooseActivityDefinitionViewControllerImpl: UIViewController, ChooseActivityDefinitionViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var picker: UIPickerView!

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: Notification.Name!
	/// If not initially set, will populate with all existing ActivityDefinitions
	public final var availableDefinitions: [ActivityDefinition]!
	public final var selectedDefinition: ActivityDefinition?

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		picker.dataSource = self
		picker.delegate = self

		if availableDefinitions == nil {
			do {
				let fetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
				fetchRequest.sortDescriptors = [NSSortDescriptor(key: "recordScreenIndex", ascending: true)]
				availableDefinitions = try DependencyInjector.db.query(fetchRequest)
			} catch {
				log.error("Failed to load activities: %@", errorInfo(error))
				parent?.showError(title: "Failed to load activities", error: error)
				dismiss(animated: false, completion: nil)
			}
		} else if availableDefinitions.count == 0 {
			parent?.showError(title: "No activities from which to choose")
			dismiss(animated: false, completion: nil)
		}

		if let selectedDefinition = selectedDefinition {
			if let index = availableDefinitions.firstIndex(of: selectedDefinition) {
				picker.selectRow(index, inComponent: 0, animated: false)
			} else {
				log.error("Failed to find selected definition in available definitions")
			}
		}
	}

	// MARK: - Actions

	@IBAction final func saveButtonPressed(_ sender: Any) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: self.info([
					.activityDefinition: self.selectedDefinition!,
				]))
		}
		dismiss(animated: false, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseActivityDefinitionViewControllerImpl: UIPickerViewDataSource {

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return availableDefinitions.count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseActivityDefinitionViewControllerImpl: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return availableDefinitions[row].name
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedDefinition = availableDefinitions[row]
	}
}
