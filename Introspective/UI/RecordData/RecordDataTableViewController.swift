//
//  RecordDataTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import os

final class RecordDataTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

	// MARK: - Static Variables

	private typealias Me = RecordDataTableViewController

	public static let showErrorMessage = Notification.Name("showErrorOnRecordDataScreen")
	public static let showViewController = Notification.Name("showViewController")

	// MARK: - Instance Variables

	private final var viewParams: [(id: String, height: CGFloat)] = [
		(id: "mood", height: 145),
		(id: "medication", height: 52),
		(id: "activity", height: 52),
	]

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		observe(selector: #selector(showViewController), name: Me.showViewController)
		observe(selector: #selector(showErrorMessage), name: Me.showErrorMessage)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table view data source

	final override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewParams.count
	}

	// MARK: - Table view delegate

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: viewParams[indexPath.row].id, for: indexPath)
	}

	final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		viewParams.swapAt(fromIndexPath.row, to.row)
	}

	final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return viewParams[indexPath.row].height
	}

	final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 1 {
			navigationController?.pushViewController(viewController(named: "medicationsTable"), animated: false)
		} else if indexPath.row == 2 {
			navigationController?.pushViewController(viewController(named: "activitiesTable"), animated: false)
		}
	}

	// MARK: - Received Notifications

	@objc private final func showViewController(notification: Notification) {
		if let controller: UIViewController = value(for: .controller, from: notification) {
			let presenter: Presentr! = value(for: .presenter, from: notification) ?? DependencyInjector.util.ui.defaultPresenter
			customPresentViewController(presenter, viewController: controller, animated: false)
		}
	}

	@objc private final func showErrorMessage(notification: Notification) {
		if let title: String = value(for: .title, from: notification) {
			let message: String? = value(for: .message, from: notification) ?? "Sorry for the inconvenience."
			showError(title: title, message: message)
		}
	}
}
