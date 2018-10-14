//
//  SortResultsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class SortResultsViewController: UIViewController {

	// MARK: - Static Variables

	private typealias Me = SortResultsViewController
	private static let userAccepted = Notification.Name("userAccepted")

	// MARK: - IBOutlets

	@IBOutlet weak final var sortAscendingSwitch: UISwitch!
	@IBOutlet weak final var chooseAttributeView: UIStackView!

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

		NotificationCenter.default.addObserver(self, selector: #selector(userPressedAccept), name: Me.userAccepted, object: nil)
	}

	// MARK: - Received Notifications

	@objc private final func userPressedAccept(notification: Notification) {
		sortAttribute = (notification.object as! Attribute)
		sortOrder = sortAscendingSwitch.isOn ? .orderedAscending : .orderedDescending
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: (attribute: sortAttribute, order: sortOrder))
	}

	// MARK: - Helper Functions

	private final func installSubView() {
		chooseAttributeController = (UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "chooseAttribute") as! ChooseAttributeViewController)
		chooseAttributeController.attributes = attributes
		chooseAttributeController.selectedAttribute = sortAttribute
		chooseAttributeController.notificationToSendOnAccept = Me.userAccepted
		let containerView = ContainerView<ChooseAttributeViewController>(parentController: self)
		containerView.install(chooseAttributeController)
		chooseAttributeView.addArrangedSubview(containerView)
	}
}
