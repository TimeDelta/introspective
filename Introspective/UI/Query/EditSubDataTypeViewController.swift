//
//  EditSubSampleTypeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

import DependencyInjection
import Queries
import Samples

final class EditSubSampleTypeViewController: UIViewController {

	// MARK: - Static Variables

	private typealias Me = EditSubSampleTypeViewController
	private static let doneEditing = Notification.Name("doneChoosingSubDataType")

	// MARK: - IBOutlets

	@IBOutlet weak final var dataTypePicker: UIPickerView!
	@IBOutlet weak final var attributedChooserSubView: UIView!

	// MARK: - Instance Variables

	public final var notificationToSendWhenAccepted: Notification.Name!
	public final var matcher: SubQueryMatcher!
	public final var sampleType: Sample.Type!
	private final var attributedChooserViewController: AttributedChooserViewController!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		dataTypePicker.dataSource = self
		dataTypePicker.delegate = self

		let index = DependencyInjector.get(SampleFactory.self).allTypes().index { $0 == sampleType }
		if index != nil {
			dataTypePicker.selectRow(index!, inComponent: 0, animated: false)
		}
		setPickerHeightConstraint()

		createAndInstallAttributedChooserViewController()

		observe(selector: #selector(doneEditing), name: Me.doneEditing)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Received Notifications

	@objc public final func doneEditing(notification: Notification) {
		guard let subQueryMatcher: SubQueryMatcher? = value(for: .attributed, from: notification) else { return }
		let savedValue = QueryViewControllerImpl.SampleTypeInfo(sampleType, subQueryMatcher!)
		NotificationCenter.default.post(
			name: notificationToSendWhenAccepted,
			object: self,
			userInfo: info([
				.sampleType: savedValue,
			]))
		navigationController?.popViewController(animated: false)
	}

	// MARK: - Helper Functions

	private final func createAndInstallAttributedChooserViewController() {
		attributedChooserViewController = viewController(named: "attributedChooserViewController", fromStoryboard: "AttributeList")
		updateAttributedChooserViewValues()
		attributedChooserViewController.notificationToSendWhenAccepted = Me.doneEditing
		attributedChooserViewController.saveButtonAccessibilityIdentifier = "save data type button"
		attributedChooserSubView.addSubview(attributedChooserViewController.view)
		attributedChooserViewController.didMove(toParent: self)
		NSLayoutConstraint.activate([
			attributedChooserViewController.view.topAnchor.constraint(equalTo: attributedChooserSubView.topAnchor),
			attributedChooserViewController.view.bottomAnchor.constraint(equalTo: attributedChooserSubView.bottomAnchor),
			attributedChooserViewController.view.leftAnchor.constraint(equalTo: attributedChooserSubView.leftAnchor),
			attributedChooserViewController.view.rightAnchor.constraint(equalTo: attributedChooserSubView.rightAnchor),
		])
	}

	private final func updateAttributedChooserViewValues() {
		let possibleValues = SubQueryMatcherFactoryImpl.allMatcherTypes.map { type in
			return type.init()
		}
		attributedChooserViewController.possibleValues = possibleValues
		attributedChooserViewController.currentValue = matcher ?? possibleValues[0]
		if attributedChooserSubView.subviews.count > 0 {
			attributedChooserViewController.reloadInputViews()
		}
	}

	// MARK: Constraint Helper Functions

	private final func setPickerHeightConstraint() {
		let heightConstraint = dataTypePicker.heightAnchor.constraint(
			equalTo: view.heightAnchor,
			multiplier: CGFloat(0.27))
		heightConstraint.priority = .required
		heightConstraint.isActive = true
	}
}

// MARK: - UIPickerViewDataSource

extension EditSubSampleTypeViewController: UIPickerViewDataSource {

	final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return DependencyInjector.get(SampleFactory.self).allTypes().count
	}
}

// MARK: - UIPickerViewDelegate

extension EditSubSampleTypeViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return DependencyInjector.get(SampleFactory.self).allTypes()[row].name
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		sampleType = DependencyInjector.get(SampleFactory.self).allTypes()[row]
	}
}
