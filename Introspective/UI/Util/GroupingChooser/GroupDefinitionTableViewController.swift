//
//  GroupDefinitionTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 4/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import AttributeRestrictions
import BooleanAlgebra
import Common
import DependencyInjection
import SampleGroupers
import Samples

public final class GroupDefinitionTableViewController: UITableViewController {
	// MARK: - IBOutlets

	@IBOutlet final var addButton: UIBarButtonItem!
	@IBOutlet final var doneButton: UIBarButtonItem!

	// MARK: - Instance Variables

	private final var sampleType: Sample.Type!
	private final var groupName: String = ""
	private final var expressionParts = [BooleanExpressionPart]()
	// leave this as a pass through otherwise the memory from this object gets modified
	// and edits carry through even if cancelled.
	public final var groupDefinition: GroupDefinition! {
		get {
			var definition = DependencyInjector.get(SampleGrouperFactory.self).groupDefinition(sampleType)
			definition.name = groupName
			definition.expressionParts = expressionParts
			return definition
		}
		set {
			sampleType = newValue.sampleType
			groupName = newValue.name
			expressionParts = [BooleanExpressionPart]()
			expressionParts.append(contentsOf: newValue.expressionParts)
		}
	}

	/// The index of the exppression part that is being edited. Only applies to attribute restrictions.
	private final var editedIndex: Int!

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.setRightBarButtonItems([doneButton, addButton], animated: false)

		reorderOnLongPress()

		validate()
		observe(selector: #selector(groupNameEdited), name: .groupNameEdited)
		observe(selector: #selector(attributeRestrictionEdited), name: .attributeRestrictionEdited)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table View Data Source

	public final override func numberOfSections(in _: UITableView) -> Int {
		2
	}

	public final override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		return expressionParts.count
	}

	public final override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 { return nil }
		return "Condition"
	}

	public final override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(
				withIdentifier: "groupName",
				for: indexPath
			) as! GroupNameTableViewCell
			cell.groupName = groupName
			return cell
		}

		let expressionPart = expressionParts[indexPath.row]
		switch expressionPart.type {
		case .and: return andCell(for: indexPath)
		case .or: return orCell(for: indexPath)
		case .groupStart: return groupStartCell(for: indexPath)
		case .groupEnd: return groupEndCell(for: indexPath)
		case .expression: return expressionCell(for: indexPath)
		}
	}

	// MARK: - Table View Delegate

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			tableView.deselectRow(at: indexPath, animated: false)
			return
		}
		guard expressionParts[indexPath.row].type == .expression else {
			tableView.deselectRow(at: indexPath, animated: false)
			showExpressionParts(indexPath)
			return
		}
		let controller = viewController(
			named: "editAttributeRestriction",
			fromStoryboard: "Query"
		) as! EditAttributeRestrictionViewController
		editedIndex = indexPath.row
		controller.sampleType = sampleType
		let expression = expressionParts[indexPath.row].expression
		controller.attributeRestriction = (expression as! AttributeRestriction)
		pushToNavigationController(controller)
	}

	public final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		guard fromIndexPath.section == 1 && to.section == 1 else { return }
		expressionParts.swapAt(fromIndexPath.row, to.row)
		validate()
		tableView.reloadData()
	}

	public final override func tableView(
		_ tableView: UITableView,
		editActionsForRowAt indexPath: IndexPath
	) -> [UITableViewRowAction]? {
		guard indexPath.section == 1 else { return [] }
		let delete = DependencyInjector.get(UiUtil.self)
			.tableViewRowAction(style: .destructive, title: "🗑️") { _, indexPath in
				self.expressionParts.remove(at: indexPath.row)
				self.validate()
				tableView.deleteRows(at: [indexPath], with: .fade)
				tableView.reloadData()
			}
		return [delete]
	}

	public final override func tableView(_: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		indexPath.section == 1
	}

	// MARK: - Received Notifications

	@objc private final func attributeRestrictionEdited(notification: Notification) {
		if let restriction: AttributeRestriction = value(for: .attributeRestriction, from: notification) {
			guard let editedIndex = editedIndex else {
				log.error("editedIndex not set for attribute restriction")
				return
			}
			expressionParts[editedIndex] = (type: .expression, expression: restriction)
			tableView.reloadData()
		}
	}

	@objc private final func groupNameEdited(notification: Notification) {
		if let name: String = value(for: .text, from: notification) {
			groupName = name
			validate()
		}
	}

	// MARK: - Actions

	@IBAction final func doneButtonPressed(_: Any) {
		syncPost(.groupDefinitionEdited, userInfo: [.groupDefinition: groupDefinition])
		popFromNavigationController()
	}

	@IBAction final func addButtonPressed(_: Any) {
		showExpressionParts()
	}

	// MARK: - Helper Functions

	/// - Parameter indexPath:
	///     If provided, the presented options will modify the expression part at this index.
	///     Otherwise, they will add the associated type of expression part.
	private final func showExpressionParts(_ indexPath: IndexPath? = nil) {
		var title = "What would you like to add?"
		if indexPath != nil {
			title = "What would you like to change this to?"
		}
		let actionSheet = DependencyInjector.get(UiUtil.self)
			.alert(title: title, message: nil, preferredStyle: .actionSheet)
		actionSheet.addAction(UIAlertAction(title: "Attribute Restriction", style: .default) { _ in
			self.addOrUpdateAttributeRestrictionFor(indexPath)
		})
		actionSheet.addAction(UIAlertAction(title: "And", style: .default, handler: getHandlerFor(.and, indexPath)))
		actionSheet.addAction(UIAlertAction(title: "Or", style: .default, handler: getHandlerFor(.or, indexPath)))
		actionSheet
			.addAction(UIAlertAction(
				title: "Condition Group Start",
				style: .default,
				handler: getHandlerFor(.groupStart, indexPath)
			))
		actionSheet
			.addAction(UIAlertAction(
				title: "Condition Group End",
				style: .default,
				handler: getHandlerFor(.groupEnd, indexPath)
			))
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		presentView(actionSheet)
	}

	private final func addOrUpdateAttributeRestrictionFor(_ indexPath: IndexPath?) {
		let restriction = getDefaultAttributeRestriction()
		guard let expression = restriction else {
			log.error("No restrictions available for sample type: %@", sampleType.name)
			return
		}
		if let indexPath = indexPath {
			expressionParts[indexPath.row] = (type: .expression, expression: expression)
		} else {
			expressionParts.append((type: .expression, expression: expression))
		}
		validate()
		tableView.reloadData()
	}

	private final func getHandlerFor(
		_ expressionType: BooleanExpressionType,
		_ indexPath: IndexPath?
	) -> ((UIAlertAction) -> Void) {
		return { _ in
			if let indexPath = indexPath {
				self.expressionParts[indexPath.row] = (type: expressionType, expression: nil)
			}
			self.expressionParts.append((type: expressionType, expression: nil))
			self.validate()
			self.tableView.reloadData()
		}
	}

	private final func getIndentationLevelFor(_ indexPath: IndexPath) -> Int {
		let targetIndex = indexPath.row
		var indentation: Int = 0
		for i in 0 ..< targetIndex {
			let part = expressionParts[i]
			switch part.type {
			case .groupStart:
				indentation += 1
				break
			case .groupEnd:
				indentation -= 1
				break
			default: break
			}
		}
		let targetExpressionPart = expressionParts[targetIndex]
		if targetIndex > 0 && targetExpressionPart.type == .groupEnd {
			indentation -= 1
		}
		return max(indentation, 0)
	}

	private final func getDefaultAttributeRestriction() -> AttributeRestriction? {
		let availableAttributes = sampleType.attributes
		var restriction: AttributeRestriction?
		for attribute in availableAttributes {
			let availableRestrictionTypes = DependencyInjector.get(AttributeRestrictionFactory.self).typesFor(attribute)
			if !availableRestrictionTypes.isEmpty {
				restriction = DependencyInjector.get(AttributeRestrictionFactory.self)
					.initialize(type: availableRestrictionTypes[0], forAttribute: attribute)
				break
			}
		}
		return restriction
	}

	private final func validate() {
		doneButton.isEnabled = groupDefinition.isValid()
	}

	// MARK: TableViewCell Creators

	private final func andCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
		cell.indentationLevel = getIndentationLevelFor(indexPath)
		cell.textLabel?.text = "and"
		return cell
	}

	private final func orCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
		cell.indentationLevel = getIndentationLevelFor(indexPath)
		cell.textLabel?.text = "or"
		return cell
	}

	private final func groupStartCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
		cell.indentationLevel = getIndentationLevelFor(indexPath)
		cell.textLabel?.text = "("
		return cell
	}

	private final func groupEndCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
		cell.indentationLevel = getIndentationLevelFor(indexPath)
		cell.textLabel?.text = ")"
		return cell
	}

	private final func expressionCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "attributeRestriction",
			for: indexPath
		) as! AttributeRestrictionTableViewCell
		let part = expressionParts[indexPath.row]
		cell.attributeRestriction = part.expression as? AttributeRestriction
		cell.indentationLevel = getIndentationLevelFor(indexPath)
		return cell
	}
}
