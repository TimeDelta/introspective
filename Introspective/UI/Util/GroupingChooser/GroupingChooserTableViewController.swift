//
//  GroupingChooserTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 4/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import Common
import DependencyInjection
import SampleGroupers
import Samples

public protocol GroupingChooserTableViewController: UITableViewController {
	var sampleType: Sample.Type! { get set }
	var currentGrouper: SampleGrouper! { get set }
	var limitToAttributes: [Attribute]? { get set }
	var allowUserToChangeGrouperType: Bool { get set }
	var notificationToSendOnAccept: NotificationName { get set }
}

public final class GroupingChooserTableViewControllerImpl: UITableViewController, GroupingChooserTableViewController {
	// MARK: - Static Variables

	private typealias Me = GroupingChooserTableViewControllerImpl

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var addButton: UIBarButtonItem!
	@IBOutlet final var doneButton: UIBarButtonItem!

	// MARK: - Instance Variables

	public final var sampleType: Sample.Type!
	public final var currentGrouper: SampleGrouper!
	/// Limit the groupers to using these attributes only
	public final var limitToAttributes: [Attribute]?
	public final var allowUserToChangeGrouperType = true
	public final var notificationToSendOnAccept: NotificationName = .grouperEdited

	private final var availableGroupers: [SampleGrouper]!
	private final var editedGroupDefinitionIndex: Int!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		if let limitToAttributes = limitToAttributes {
			availableGroupers = injected(SampleGrouperFactory.self)
				.groupersFor(attributes: limitToAttributes)
		} else {
			availableGroupers = injected(SampleGrouperFactory.self).groupersFor(sampleType: sampleType)
		}
		guard !availableGroupers.isEmpty else {
			showNoAvailableGroupersError()
			popFromNavigationController()
			return
		}

		if currentGrouper == nil {
			currentGrouper = availableGroupers[0]
		}

		updateDoneButtonState()
		updateNavBarButtons()

		observe(selector: #selector(grouperChanged), name: .grouperAttributesSet)
		observe(selector: #selector(groupDefinitionEdited), name: .groupDefinitionEdited)

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 44
	}

	// MARK: - Table View Data Source

	public final override func numberOfSections(in _: UITableView) -> Int {
		if currentGrouper is AdvancedSampleGrouper {
			return 2
		}
		return 1
	}

	public final override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		guard let advancedGrouper = currentGrouper as? AdvancedSampleGrouper else {
			Me.log.error(
				"Asked for number of rows in section %d but current grouper is not advanced grouper: %s",
				section,
				String(describing: type(of: currentGrouper))
			)
			return 0
		}
		return advancedGrouper.groupDefinitions.count
	}

	public final override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 { return nil }
		if section == 1 { return "Group Definitions" }
		Me.log.error("Unknown section number: %d", section)
		return nil
	}

	public final override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
			if currentGrouper is AdvancedSampleGrouper {
				cell.textLabel?.text = currentGrouper.attributedName
			} else {
				cell.textLabel?.text = currentGrouper.description
			}
			return cell
		}

		guard let advancedGrouper = currentGrouper as? AdvancedSampleGrouper else {
			Me.log.error(
				"Current grouper is not advanced grouper: %s",
				String(describing: type(of: currentGrouper))
			)
			return UITableViewCell()
		}

		let cell = tableView.dequeueReusableCell(
			withIdentifier: "groupDefinition",
			for: indexPath
		) as! GroupDefinitionTableViewCell
		cell.groupDefinition = advancedGrouper.groupDefinitions[indexPath.row]
		return cell
	}

	// MARK: - Table View Delegate

	public final override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			showSelectGrouperView()
		} else {
			showGroupDefinitionView(for: indexPath)
		}
	}

	public final override func tableView(
		_ tableView: UITableView,
		editActionsForRowAt indexPath: IndexPath
	) -> [UITableViewRowAction]? {
		guard indexPath.section == 1 else { return [] }
		guard let advancedGrouper = currentGrouper as? AdvancedSampleGrouper else { return nil }
		let delete = UITableViewRowAction(style: .destructive, title: "🗑️") { _, indexPath in
			advancedGrouper.groupDefinitions.remove(at: indexPath.row)
			self.updateDoneButtonState()
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
		}
		return [delete]
	}

	// MARK: - Button Actions

	@IBAction final func doneButtonPressed(_: Any) {
		syncPost(notificationToSendOnAccept, userInfo: [.sampleGrouper: currentGrouper!])
		popFromNavigationController()
	}

	@IBAction final func addButtonPressed(_: Any) {
		guard let advancedGrouper = currentGrouper as? AdvancedSampleGrouper else {
			Me.log.error("Add button pressed when current grouper not AdvancedSampleGrouper")
			return
		}
		let groupDefinition = injected(SampleGrouperFactory.self).groupDefinition(sampleType)
		advancedGrouper.groupDefinitions.append(groupDefinition)
		updateDoneButtonState()
		tableView.reloadData()
	}

	// MARK: - Received Notifications

	@objc private final func grouperChanged(notification: Notification) {
		if let grouper: SampleGrouper? = value(for: .sampleGrouper, from: notification) {
			currentGrouper = grouper
			updateDoneButtonState()
			updateNavBarButtons()
			tableView.reloadData()
		}
		popFromNavigationController()
	}

	@objc private final func groupDefinitionEdited(notification: Notification) {
		guard let advancedGrouper = currentGrouper as? AdvancedSampleGrouper else {
			Me.log.error("Received groupDefinitionEdited notification when grouper was not AdvancedSampleGrouper")
			return
		}
		if let newDefinition: GroupDefinition? = value(for: .groupDefinition, from: notification) {
			advancedGrouper.groupDefinitions[editedGroupDefinitionIndex] = newDefinition!
			tableView.reloadData()
		}
		updateDoneButtonState()
	}

	// MARK: - Helper Functions

	private final func showNoAvailableGroupersError() {
		let alert = UIAlertController(title: "Unable to group \(sampleType.name)", message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in
			self.popFromNavigationController()
		})
		presentView(alert)
	}

	private final func showSelectGrouperView() {
		let controller = viewController(named: "editGrouper") as! EditGrouperViewController
		controller.currentGrouper = currentGrouper
		if allowUserToChangeGrouperType {
			controller.availableGroupers = availableGroupers
		} else {
			controller.availableGroupers = [currentGrouper]
		}
		controller.notificationToSendWhenAccepted = .grouperAttributesSet
		pushToNavigationController(controller)
	}

	private final func showGroupDefinitionView(for indexPath: IndexPath) {
		let controller: GroupDefinitionTableViewController = viewController(named: "groupDefinitionView")
		guard let advancedGrouper = currentGrouper as? AdvancedSampleGrouper else {
			Me.log.error("Unable to cast currentGrouper as AdvancedSampleGrouper")
			showError(title: "You found a bug. Please report it.")
			return
		}
		controller.groupDefinition = advancedGrouper.groupDefinitions[indexPath.row]
		editedGroupDefinitionIndex = indexPath.row
		pushToNavigationController(controller)
	}

	private final func updateDoneButtonState() {
		if currentGrouper is AdvancedSampleGrouper {
			doneButton.isEnabled = (currentGrouper as! AdvancedSampleGrouper).isValid()
		} else {
			doneButton.isEnabled = currentGrouper.attributeValuesAreValid()
		}
	}

	private final func updateNavBarButtons() {
		var buttons: [UIBarButtonItem] = [doneButton]
		if currentGrouper is AdvancedSampleGrouper {
			buttons.append(addButton)
		}
		navigationItem.setRightBarButtonItems(buttons, animated: false)
	}
}
