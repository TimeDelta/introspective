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
	private static let presenter: Presentr = UiUtil.customPresenter(width: .custom(size: 300), height: .custom(size: 200), center: .topCenter)

	public static let showErrorMessage = Notification.Name("showErrorOnRecordDataScreen")
	public static let showViewController = Notification.Name("showViewController")

	// MARK: - Instance Variables

	private final var viewParams: [(id: String, height: CGFloat)] = [
		(id: "mood", height: 100.0),
		(id: "medication", height: 52),
		(id: "activity", height: 52),
	]

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(showViewController), name: Me.showViewController, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(showErrorMessage), name: Me.showErrorMessage, object: nil)
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

	// MARK: - Received Notifications

	@objc private final func showViewController(notification: Notification) {
		if let controller = notification.object as? UIViewController {
			customPresentViewController(Me.presenter, viewController: controller, animated: true)
		} else {
			os_log("Wrong object type for show view controller notification", type: .error)
		}
	}

	@objc private final func showErrorMessage(notification: Notification) {
		if let error = notification.object as? (title: String, message: String?) {
			showError(title: error.title, message: error.message)
		} else {
			os_log("Wrong object type for show error message notification", type: .error)
		}
	}
}
