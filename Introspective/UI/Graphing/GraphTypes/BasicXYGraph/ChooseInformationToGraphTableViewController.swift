//
//  ChooseInformationToGraphTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class ChooseInformationToGraphTableViewController: UITableViewController {

	// MARK: - Static Variables

	private typealias Me = ChooseInformationToGraphTableViewController
	private static let editedInformation = Notification.Name("editedInformationWhileChoosingInfoToGraph")

	// MARK: - Instance Variables

	public final var limitToNumericInformation: Bool = false
	public final var notificationToSendWhenFinished: Notification.Name!
	public final var attributes: [Attribute]!
	public final var chosenInformation: [ExtraInformation]! {
		didSet { chosenInformation = chosenInformation ?? [ExtraInformation]() }
	}

	private final var informationEditIndex: Int!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = editButtonItem
		observe(selector: #selector(saveEditedInformation), name: Me.editedInformation)
	}

	// MARK: - TableView Data Source

	final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return chosenInformation.count
	}

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = chosenInformation[indexPath.row].description
		return cell
	}

	// MARK: - TableView Delegate

	final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		informationEditIndex = indexPath.row
		let selectedInformation = chosenInformation[informationEditIndex]

		let controller: SelectExtraInformationViewController = viewController(named: "editExtraInformation", fromStoryboard: "Util")
		controller.notificationToSendWhenFinished = Me.editedInformation
		controller.attributes = attributes
		controller.limitToNumericInformation = limitToNumericInformation
		controller.selectedAttribute = selectedInformation.attribute
		controller.selectedInformation = selectedInformation
		navigationController!.pushViewController(controller, animated: true)
	}

	final override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "🗑️") { (_, indexPath) in
			self.chosenInformation.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
		}

		return [delete]
	}

	// MARK: - Button Actions

	@IBAction final func addButtonPressed(_ sender: Any) {
		let attribute = attributes[0]
		var newInformation: ExtraInformation
		if limitToNumericInformation {
			newInformation = DependencyInjector.extraInformation.getApplicableNumericInformationTypes(forAttribute: attribute)[0].init(attribute)
		} else {
			newInformation = DependencyInjector.extraInformation.getApplicableInformationTypes(forAttribute: attribute)[0].init(attribute)
		}
		self.chosenInformation.append(newInformation)
		self.tableView.reloadData()
	}

	@IBAction final func clearButtonPressed(_ sender: Any) {
		var indexPaths = [IndexPath]()
		for i in 0 ..< chosenInformation.count {
			indexPaths.append(IndexPath(row: i, section: 0))
		}
		chosenInformation = []
		tableView.deleteRows(at: indexPaths, with: .fade)
		tableView.reloadData()
	}

	@IBAction final func doneButtonPressed(_ sender: Any) {
		NotificationCenter.default.post(
			name: notificationToSendWhenFinished,
			object: self,
			userInfo: info([
				.information: chosenInformation,
			]))
		navigationController!.popViewController(animated: true)
	}

	// MARK: - Received Notifications

	@objc private final func saveEditedInformation(notification: Notification) {
		if let information: ExtraInformation? = value(for: .information, from: notification) {
			chosenInformation[informationEditIndex] = information!
			tableView.reloadData()
		}
	}
}
