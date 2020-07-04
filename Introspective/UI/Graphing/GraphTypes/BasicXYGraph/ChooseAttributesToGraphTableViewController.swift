//
//  ChooseAttributesToGraphTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import Common
import DependencyInjection

public protocol ChooseAttributesToGraphTableViewController: UITableViewController {
	var notificationToSendWhenFinished: NotificationName! { get set }
	var allowedAttributes: [Attribute]! { get set }
	var selectedAttributes: [Attribute]! { get set }
}

final class ChooseAttributesToGraphTableViewControllerImpl: UITableViewController,
	ChooseAttributesToGraphTableViewController {
	// MARK: - IBOutlets

	@IBOutlet final var addButton: UIBarButtonItem!

	// MARK: - Instance Variables

	public final var notificationToSendWhenFinished: NotificationName!
	public final var allowedAttributes: [Attribute]! {
		didSet { allowedAttributes = allowedAttributes ?? [Attribute]() }
	}

	public final var selectedAttributes: [Attribute]! {
		didSet { selectedAttributes = selectedAttributes ?? [Attribute]() }
	}

	private final var editIndex: Int!

	// MARK: - UIViewController Overrides

	override final func viewDidLoad() {
		super.viewDidLoad()
		if selectedAttributes.count == allowedAttributes.count {
			addButton.isEnabled = false
		}
		if allowedAttributes.isEmpty {
			let alert = UIAlertController(
				title: "No graphable attributes",
				message: "There are no graphable attributes on the chosen data type.",
				preferredStyle: .alert
			)
			alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
				self.syncPost(self.notificationToSendWhenFinished, userInfo: [:])
				self.navigationController!.popViewController(animated: false)
			})
			present(alert, animated: false)
		}
		observe(selector: #selector(saveEditedAttribute), name: .attributeChosen)
		navigationItem.rightBarButtonItem = editButtonItem
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - TableView Data Source

	override final func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
		selectedAttributes.count
	}

	override final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = selectedAttributes[indexPath.row].name.localizedCapitalized
		return cell
	}

	// MARK: - TableView Delegate

	override final func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
		editIndex = indexPath.row
		let controller: ChooseAttributeViewController = viewController(named: "chooseAttribute", fromStoryboard: "Util")
		controller.notificationToSendOnAccept = .attributeChosen
		controller.selectedAttribute = selectedAttributes[editIndex]
		var unselectedAttributes = allowedAttributes.filter { attribute in
			!selectedAttributes.contains(where: { $0.equalTo(attribute) })
		}
		unselectedAttributes.append(selectedAttributes[editIndex])
		controller.attributes = unselectedAttributes
		customPresentViewController(
			DependencyInjector.get(UiUtil.self).defaultPresenter,
			viewController: controller,
			animated: false
		)
	}

	// MARK: - TableView Editing

	override final func tableView(_: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		selectedAttributes.swapAt(fromIndexPath.row, to.row)
	}

	override final func tableView(
		_ tableView: UITableView,
		editActionsForRowAt indexPath: IndexPath
	) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "🗑️") { _, indexPath in
			self.selectedAttributes.remove(at: indexPath.row)
			self.addButton.isEnabled = true
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
		}
		return [delete]
	}

	// MARK: - Button Actions

	@IBAction final func addButtonPressed(_: Any) {
		if let attribute = firstUnselectedAttribute() {
			selectedAttributes.append(attribute)
		}
		if selectedAttributes.count == allowedAttributes.count {
			addButton.isEnabled = false
		}
		tableView.reloadData()
	}

	@IBAction final func clearButtonPressed(_: Any) {
		var indexPaths = [IndexPath]()
		for i in 0 ..< selectedAttributes.count {
			indexPaths.append(IndexPath(row: i, section: 0))
		}
		selectedAttributes = []
		addButton.isEnabled = true
		tableView.deleteRows(at: indexPaths, with: .fade)
		tableView.reloadData()
	}

	@IBAction final func doneButtonPressed(_: Any) {
		syncPost(
			notificationToSendWhenFinished,
			userInfo: [
				.attributes: selectedAttributes,
			]
		)
		navigationController!.popViewController(animated: false)
	}

	// MARK: - Received Notifications

	@objc private final func saveEditedAttribute(notification: Notification) {
		if let attribute: Attribute? = value(for: .attribute, from: notification) {
			selectedAttributes[editIndex] = attribute!
			tableView.reloadData()
		}
	}

	// MARK: - Helper Functions

	private final func firstUnselectedAttribute() -> Attribute? {
		for attribute in allowedAttributes {
			if selectedAttributes.index(where: { $0.equalTo(attribute) }) == nil {
				return attribute
			}
		}
		return nil
	}
}
