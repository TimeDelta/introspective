//
//  MultiSelectAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class MultiSelectAttributeValueViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var subView: UIView!

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
				object: self.subViewController.selectedValues)
		}
		dismiss(animated: true, completion: nil)
	}

	// MARK: - Helper Functions

	private final func createAndInstallSubViewController() {
		subViewController = (UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "multiSelect") as! MultiSelectAttributeValueSelectTableViewController)
		subViewController.initialValue = initialValue
		subViewController.multiSelectAttribute = multiSelectAttribute
		subView.addSubview(subViewController.view)
	}
}
