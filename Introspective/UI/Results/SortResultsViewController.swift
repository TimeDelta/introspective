//
//  SortResultsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import UIExtensions

final class SortResultsViewController: UIViewController {
	// MARK: - IBOutlets

	@IBOutlet final var sortAscendingSwitch: UISwitch!
	@IBOutlet final var chooseAttributeView: UIStackView!

	// MARK: - Instance Variables

	public final var attributes: [Attribute]!
	public final var sortAttribute: Attribute!
	public final var sortOrder: ComparisonResult!
	public final var notificationToSendOnAccept: Notification.Name!

	private final var chooseAttributeController: ChooseAttributeViewController!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		sortAscendingSwitch.isOn = sortOrder == .orderedAscending

		installSubView()

		observe(selector: #selector(userPressedAccept), name: .attributeChosen)
	}

	// MARK: - Received Notifications

	@objc private final func userPressedAccept(notification: Notification) {
		guard let attribute: Attribute? = value(for: .attribute, from: notification) else { return }
		sortAttribute = attribute!
		sortOrder = sortAscendingSwitch.isOn ? .orderedAscending : .orderedDescending
		NotificationCenter.default.post(
			name: notificationToSendOnAccept,
			object: self,
			userInfo: info([
				.attribute: sortAttribute,
				.comparisonResult: sortOrder,
			])
		)
	}

	// MARK: - Helper Functions

	private final func installSubView() {
		chooseAttributeController = viewController(named: "chooseAttribute", fromStoryboard: "Util")
		chooseAttributeController.attributes = attributes
		chooseAttributeController.selectedAttribute = sortAttribute
		chooseAttributeController.notificationToSendOnAccept = .attributeChosen
		chooseAttributeController.acceptButtonTitle = "Sort"
		let containerView = ContainerView<ChooseAttributeViewController>(parentController: self)
		containerView.install(chooseAttributeController)
		chooseAttributeView.addArrangedSubview(containerView)
	}
}
