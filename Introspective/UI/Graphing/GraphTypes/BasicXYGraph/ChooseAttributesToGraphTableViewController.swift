//
//  ChooseAttributesToGraphTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class ChooseAttributesToGraphTableViewController: UITableViewController {

	// MARK: - Static Variables

	private typealias Me = ChooseAttributesToGraphTableViewController
	private static let editedAttribute = Notification.Name("editedAttributesWhileChoosingWhatToGraph")

	// MARK: - IBOutlets

	@IBOutlet weak final var addButton: UIBarButtonItem!

	// MARK: - Instance Variables

	public final var notificationToSendWhenFinished: Notification.Name!
	public final var allowedAttributes: [Attribute]! {
		didSet { allowedAttributes = allowedAttributes ?? [Attribute]() }
	}
	public final var selectedAttributes: [Attribute]! {
		didSet { selectedAttributes = selectedAttributes ?? [Attribute]() }
	}

	private final var editIndex: Int!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		if selectedAttributes.count == allowedAttributes.count {
			addButton.isEnabled = false
		}
		if allowedAttributes.count == 0 {
			let alert = UIAlertController(title: "No graphable attributes", message: "There are no graphable attributes on the chosen data type.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
				NotificationCenter.default.post(name: self.notificationToSendWhenFinished, object: nil)
				self.navigationController!.popViewController(animated: false)
			})
			present(alert, animated: false)
		}
		navigationItem.rightBarButtonItem = editButtonItem
		NotificationCenter.default.addObserver(self, selector: #selector(saveEditedAttribute), name: Me.editedAttribute, object: nil)
	}

	// MARK: - TableView Data Source

	final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return selectedAttributes.count
	}

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = selectedAttributes[indexPath.row].name.localizedCapitalized
		return cell
	}

	// MARK: - TableView Delegate

	final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		editIndex = indexPath.row
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "chooseAttribute") as! ChooseAttributeViewController
		controller.notificationToSendOnAccept = Me.editedAttribute
		controller.selectedAttribute = selectedAttributes[editIndex]
		var unselectedAttributes = allowedAttributes.filter{ attribute in
			!selectedAttributes.contains(where: { $0.equalTo(attribute) })
		}
		unselectedAttributes.append(selectedAttributes[editIndex])
		controller.attributes = unselectedAttributes
		customPresentViewController(UiUtil.defaultPresenter, viewController: controller, animated: true)
	}

	// MARK: - TableView Editing

	final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		selectedAttributes.swapAt(fromIndexPath.row, to.row)
	}

	final override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "🗑️") { (_, indexPath) in
			self.selectedAttributes.remove(at: indexPath.row)
			self.addButton.isEnabled = true
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
		}
		return [delete]
	}

	// MARK: - Button Actions

	@IBAction final func addButtonPressed(_ sender: Any) {
		if let attribute = firstUnselectedAttribute() {
			selectedAttributes.append(attribute)
		}
		if selectedAttributes.count == allowedAttributes.count {
			addButton.isEnabled = false
		}
		tableView.reloadData()
	}

	@IBAction final func clearButtonPressed(_ sender: Any) {
		var indexPaths = [IndexPath]()
		for i in 0 ..< selectedAttributes.count {
			indexPaths.append(IndexPath(row: i, section: 0))
		}
		selectedAttributes = []
		self.addButton.isEnabled = true
		tableView.deleteRows(at: indexPaths, with: .fade)
		tableView.reloadData()
	}

	@IBAction final func doneButtonPressed(_ sender: Any) {
		NotificationCenter.default.post(name: notificationToSendWhenFinished, object: selectedAttributes)
		navigationController!.popViewController(animated: true)
	}

	// MARK: - Received Notifications

	@objc private final func saveEditedAttribute(notification: Notification) {
		selectedAttributes[editIndex] = notification.object as! Attribute
		tableView.reloadData()
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
