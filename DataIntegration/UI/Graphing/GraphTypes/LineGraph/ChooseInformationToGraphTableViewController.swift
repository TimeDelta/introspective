//
//  ChooseInformationToGraphTableViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class ChooseInformationToGraphTableViewController: UITableViewController {

	// MARK: - Static Member Variables

	private typealias Me = ChooseInformationToGraphTableViewController
	private static let editedInformation = Notification.Name("editedInformationWhileChoosingInfoToGraph")

	// MARK: - Instance Member Variables

	public final var notificationToSendWhenFinished: Notification.Name!
	public final var attributes: [Attribute]!
	public final var information: [ExtraInformation]! {
		didSet { information = information ?? [ExtraInformation]() }
	}

	private final var attributeEditIndex: Int!
	private final var informationEditIndex: Int!

	final override func viewDidLoad() {
		super.viewDidLoad()
		// TODO - support editing
		NotificationCenter.default.addObserver(self, selector: #selector(saveEditedInformation), name: Me.editedInformation, object: nil)
	}

	// MARK: - TableView Data Source

	final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return information.count
	}

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = information[indexPath.row].description
		return cell
	}

	// MARK: - TableView Delegate

	final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		informationEditIndex = indexPath.row
		let selectedInformation = information[informationEditIndex]

		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "editExtraInformation") as! SelectExtraInformationViewController
		controller.notificationToSendWhenFinished = Me.editedInformation
		controller.attributes = attributes
		controller.selectedAttribute = selectedInformation.attribute
		controller.selectedInformation = selectedInformation
		navigationController!.pushViewController(controller, animated: true)
	}

	// MARK: - Button Actions

	@IBAction final func addButtonPressed(_ sender: Any) {
		let attribute = attributes[0]
		let information = DependencyInjector.extraInformation.getApplicableInformationTypes(forAttribute: attribute)[0].init(attribute)
		self.information.append(information)
		self.tableView.reloadData()
	}

	@IBAction final func doneButtonPressed(_ sender: Any) {
		NotificationCenter.default.post(name: notificationToSendWhenFinished, object: information)
		navigationController!.popViewController(animated: true)
	}

	// MARK: - Received Notifications

	@objc private final func saveEditedInformation(notification: Notification) {
		information[informationEditIndex] = notification.object as! ExtraInformation
		tableView.reloadData()
	}
}
