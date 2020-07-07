//
//  EditActivityDefinitionTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 11/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import Presentr
import UIKit
import WSTagsField

import Common
import DependencyInjection
import Persistence
import Samples

public final class EditActivityDefinitionTableViewController: UITableViewController {
	// MARK: - Static Variables

	private typealias Me = EditActivityDefinitionTableViewController

	private static let nameIndex = IndexPath(row: 0, section: 0)
	private static let autoNoteIndex = IndexPath(row: 1, section: 0)
	private static let descriptionIndex = IndexPath(row: 0, section: 1)
	private static let tagsIndex = IndexPath(row: 0, section: 2)

	private static let nameChanged = Notification.Name("activityDefinitionNameChanged")
	private static let descriptionChanged = Notification.Name("activityDefinitionDescriptionChanged")
	private static let tagsChanged = Notification.Name("activityDefinitionTagsChanged")
	private static let autoNoteChanged = Notification.Name("autoNoteChanged")
	private static let invalid = Notification.Name("activityDefinitionInvalid")
	private static let showPopup = Notification.Name("showPopup")

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: Notification.Name!
	/// This will only be used in the case that `activityDefinition` is not set
	public final var initialName: String?
	public final var activityDefinition: ActivityDefinition? {
		didSet {
			guard let activityDefinition = activityDefinition else { return }
			activityDescription = activityDefinition.activityDescription
			tagNames = Set(activityDefinition.tagsArray().map { $0.name })
			autoNote = activityDefinition.autoNote
		}
	}

	private final var name = ""
	private final var activityDescription: String?
	private final var tagNames = Set<String>()
	private final var autoNote = false

	private final var saveButton: UIBarButtonItem!

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public override func viewDidLoad() {
		super.viewDidLoad()

		extendedLayoutIncludesOpaqueBars = true

		name = activityDefinition?.name ?? initialName ?? ""
		if let activityDefinition = activityDefinition {
			navigationItem.title = "Edit \(activityDefinition.name)"
		} else {
			navigationItem.title = "Create New Activity"
		}

		saveButton = UIBarButtonItem(
			title: "Save",
			style: .done,
			target: self,
			action: #selector(saveButtonPressed)
		)
		saveButton.isEnabled = !name.isEmpty
		navigationItem.rightBarButtonItem = saveButton!

		observe(selector: #selector(nameChanged), name: Me.nameChanged)
		observe(selector: #selector(descriptionChanged), name: Me.descriptionChanged)
		observe(selector: #selector(tagsChanged), name: Me.tagsChanged)
		observe(selector: #selector(invalid), name: Me.invalid)
		observe(selector: #selector(autoNoteChanged), name: Me.autoNoteChanged)
		observe(selector: #selector(showPopup), name: Me.showPopup)

		hideKeyboardOnTapNonTextInput()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table view data source

	public final override func numberOfSections(in _: UITableView) -> Int {
		3
	}

	public final override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 2
		}
		return 1
	}

	public final override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		if indexPath == Me.nameIndex {
			let cell = tableView.dequeueReusableCell(
				withIdentifier: "name",
				for: indexPath
			) as! ActivityDefinitionNameTableViewCell
			cell.initialName = name
			cell.notificationToSendOnNameChange = Me.nameChanged
			cell.notificationToSendOnInvalidName = Me.invalid
			return cell
		} else if indexPath == Me.autoNoteIndex {
			let cell = tableView.dequeueReusableCell(
				withIdentifier: "autoNote",
				for: indexPath
			) as! ActivityDefinitionAutoNoteTableViewCell
			cell.autoNote = autoNote
			cell.notificationToSendOnChange = Me.autoNoteChanged
			cell.notificationToSendForPopup = Me.showPopup
			return cell
		} else if indexPath == Me.descriptionIndex {
			let cell = tableView.dequeueReusableCell(
				withIdentifier: "description",
				for: indexPath
			) as! ActivityDefinitionDescriptionTableViewCell
			cell.activityDescription = activityDescription
			cell.notificationToSendOnChange = Me.descriptionChanged
			return cell
		} else if indexPath == Me.tagsIndex {
			let cell = tableView.dequeueReusableCell(
				withIdentifier: "tags",
				for: indexPath
			) as! ActivityDefinitionTagsTableViewCell
			cell.tagNames = tagNames
			cell.notificationToSendOnChange = Me.tagsChanged
			return cell
		}
		log.error("Missing cell customization case for edit activity")
		return UITableViewCell()
	}

	public final override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath == Me.descriptionIndex || indexPath == Me.tagsIndex {
			return 131
		}
		return 50
	}

	// MARK: - Table view delegate

	public final override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 1 {
			return "Description"
		}
		if section == 2 {
			return "Tags"
		}
		return nil
	}

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false) // selecting a cell should not change the UI
	}

	// MARK: - Received Notifications

	@objc private final func nameChanged(notification: Notification) {
		if let name: String? = value(for: .text, from: notification) {
			self.name = name!
			saveButton.isEnabled = true
		}
	}

	@objc private final func invalid(notification _: Notification) {
		saveButton.isEnabled = false
	}

	@objc private final func descriptionChanged(notification: Notification) {
		activityDescription = value(for: .text, from: notification)
	}

	@objc private final func tagsChanged(notification: Notification) {
		if let tagNames: Set<String> = value(for: .tagNames, from: notification) {
			self.tagNames = tagNames
		}
	}

	@objc private final func autoNoteChanged(notification: Notification) {
		if let autoNote: Bool? = value(for: .activityDefinitionAutoNote, from: notification) {
			self.autoNote = autoNote!
		}
	}

	@objc private final func showPopup(notification: Notification) {
		if
			let controller: UIViewController = value(for: .controller, from: notification),
			let presenter: Presentr = value(for: .presenter, from: notification) {
			customPresentViewController(presenter, viewController: controller, animated: false)
		}
	}

	// MARK: - Actions

	@objc private final func saveButtonPressed(_: Any) {
		do {
			let transaction = DependencyInjector.get(Database.self).transaction()

			// have to use local variable here otherwise description will be
			// overwritten when self.activityDefinition is set
			var activityDefinition: ActivityDefinition! = self.activityDefinition
			if let localActivityDefinition = activityDefinition {
				activityDefinition = try transaction.pull(savedObject: localActivityDefinition)
			} else {
				activityDefinition = try transaction.new(ActivityDefinition.self)
				activityDefinition.setSource(.introspective)
				activityDefinition
					.recordScreenIndex = Int16(
						try DependencyInjector.get(Database.self)
							.query(ActivityDefinition.fetchRequest()).count
					)
			}

			activityDefinition.name = name
			activityDefinition.activityDescription = activityDescription
			activityDefinition.autoNote = autoNote
			try updateTagsForActivityDefinition(&activityDefinition, using: transaction)

			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
			activityDefinition = try DependencyInjector.get(Database.self).pull(savedObject: activityDefinition)

			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: self.notificationToSendOnAccept,
					object: self,
					userInfo: self.info([
						.activityDefinition: activityDefinition,
					])
				)
			}
			navigationController?.popViewController(animated: false)
		} catch {
			log.error("Failed to create, edit or save ActivityDefinition: %@", errorInfo(error))
			showError(
				title: "Failed to save activity",
				message: "Something went wrong while trying to save this activity. Sorry for the inconvenience.",
				error: error
			)
		}
	}

	// MARK: - Helper Functions

	private final func updateTagsForActivityDefinition(
		_ activityDefinition: inout ActivityDefinition,
		using transaction: Transaction
	) throws {
		var allTags = [Tag]()
		for tagName in tagNames {
			var tag: Tag! = try findTagWithName(tagName, using: transaction)
			if tag == nil {
				tag = try transaction.new(Tag.self)
				tag.name = tagName
			}
			allTags.append(tag)
		}
		try activityDefinition.setTags(allTags)
	}

	private final func findTagWithName(_ name: String, using transaction: Transaction) throws -> Tag? {
		let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let tags = try transaction.query(fetchRequest)
		if !tags.isEmpty {
			return tags[0]
		}
		return nil
	}
}
