//
//  MultiSelectAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes

public final class MultiSelectAttributeValueViewController: UIViewController {
	// MARK: - IBOutlets

	@IBOutlet final var subView: UIView!

	// MARK: - Instance Variables

	public final var multiSelectAttribute: MultiSelectAttribute!
	public final var notificationToSendOnAccept: Notification.Name!
	public final var initialValue: Any?

	private final var subViewController: MultiSelectAttributeValueSelectTableViewController!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		createAndInstallSubViewController()
	}

	// MARK: - IBActions

	@IBAction final func saveButtonPressed() {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: self.info([
					.attributeValue: self.subViewController.selectedValues,
				])
			)
		}
		dismiss(animated: false, completion: nil)
	}

	// MARK: - Helper Functions

	private final func createAndInstallSubViewController() {
		subViewController = viewController(named: "multiSelect", fromStoryboard: "AttributeList")
		subViewController.initialValue = initialValue
		subViewController.multiSelectAttribute = multiSelectAttribute
		subView.addSubview(subViewController.view)
		subViewController.didMove(toParent: self)
	}
}
