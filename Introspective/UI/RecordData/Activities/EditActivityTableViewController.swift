//
//  EditActivityTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 11/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import CoreData
import os

public final class EditActivityTableViewController: UITableViewController {

	// MARK: - Static Variables

	private typealias Me = EditActivityTableViewController

	private static let activityIndex = IndexPath(row: 0, section: 0)
	private static let startIndex = IndexPath(row: activityIndex.row + 1, section: 0)
	private static let endIndex = IndexPath(row: startIndex.row + 1, section: 0)
	private static let noteIndex = IndexPath(row: 0, section: 1)
	private static let tagsIndex = IndexPath(row: 0, section: 2)

	private static let presenter: Presentr = UiUtil.customPresenter(
		width: .full,
		height: .fluid(percentage: 0.4),
		center: .bottomCenter)

	private static let activityDefinitionChanged = Notification.Name("activityDefinitionChanged")
	private static let startDateChanged = Notification.Name("activityStartDateChanged")
	private static let endDateChanged = Notification.Name("activityEndDateChanged")
	private static let noteChanged = Notification.Name("activityNoteChanged")
	private static let tagsChanged = Notification.Name("tagsChanged")

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: Notification.Name!
	public final var activity: Activity? {
		didSet {
			guard let activity = activity else { return }
			definition = activity.definition
			startDate = activity.startDate
			endDate = activity.endDate
			note = activity.note
			tagNames = Set(activity.tagsArray().map{ $0.name })
		}
	}

	/// This will be overridden if `activity` is set after this is
	public final var definition: ActivityDefinition? = nil { didSet { validate() } }
	private final var startDate: Date = Date() { didSet { validate() } }
	private final var endDate: Date? { didSet { validate() } }
	private final var note: String?
	private final var tagNames = Set<String>()

	private final var saveButton: UIBarButtonItem!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		saveButton = UIBarButtonItem(
			title: "Save",
			style: .done,
			target: self,
			action: #selector(saveButtonPressed))
		navigationItem.rightBarButtonItem = saveButton!

		NotificationCenter.default.addObserver(self, selector: #selector(activityDefinitionChanged), name: Me.activityDefinitionChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(startDateChanged), name: Me.startDateChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(endDateChanged), name: Me.endDateChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(noteChanged), name: Me.noteChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(tagsChanged), name: Me.tagsChanged, object: nil)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table view data source

	public final override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}

	public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 3
		}
		return 1
	}

	public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell
		if indexPath == Me.activityIndex {
			cell = tableView.dequeueReusableCell(withIdentifier: "activity", for: indexPath)
			cell.detailTextLabel?.text = definition?.name ?? "Choose Activity"
		} else if indexPath == Me.startIndex {
			cell = tableView.dequeueReusableCell(withIdentifier: "start", for: indexPath)
			let startDateText = DependencyInjector.util.calendar.string(for: startDate, dateStyle: .medium, timeStyle: .medium)
			cell.detailTextLabel?.text = startDateText
			cell.detailTextLabel?.accessibilityValue = startDateText
			cell.detailTextLabel?.accessibilityLabel = "start date"
		} else if indexPath == Me.endIndex {
			let endDateCell = tableView.dequeueReusableCell(withIdentifier: "end", for: indexPath) as! ActivityEndDateTableViewCell
			endDateCell.endDate = endDate
			endDateCell.notificationToSendOnDateChange = Me.endDateChanged
			cell = endDateCell
		} else if indexPath == Me.noteIndex {
			let noteCell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath) as! ActivityNoteTableViewCell
			noteCell.note = note
			noteCell.notificationToSendOnChange = Me.noteChanged
			cell = noteCell
		} else if indexPath == Me.tagsIndex {
			let tagsCell = tableView.dequeueReusableCell(withIdentifier: "tags", for: indexPath) as! ActivityTagsTableViewCell
			tagsCell.tagNames = tagNames
			tagsCell.notificationToSendOnChange = Me.tagsChanged
			cell = tagsCell
		} else {
			cell = UITableViewCell()
			os_log("Missing cell customization case for edit activity", type: .error)
		}

		return cell
	}

	public final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath == Me.noteIndex || indexPath == Me.tagsIndex {
			return 131
		}
		return 44
	}

	// MARK: - Table view delegate

	public final override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 1 {
			return "Note"
		}
		if section == 2 {
			return "Additional Tags"
		}
		return nil
	}

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath == Me.activityIndex {
			let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "chooseActivityDefinition") as! ChooseActivityDefinitionViewController
			controller.selectedDefinition = definition
			controller.notificationToSendOnAccept = Me.activityDefinitionChanged
			customPresentViewController(Me.presenter, viewController: controller, animated: false)
		} else if indexPath == Me.startIndex {
			let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "datePicker") as! SelectDateViewController
			controller.initialDate = startDate
			controller.notificationToSendOnAccept = Me.startDateChanged
			customPresentViewController(Me.presenter, viewController: controller, animated: false)
		} else if indexPath == Me.endIndex {
			let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "datePicker") as! SelectDateViewController
			controller.initialDate = endDate
			controller.notificationToSendOnAccept = Me.endDateChanged
			customPresentViewController(Me.presenter, viewController: controller, animated: false)
		}
		tableView.deselectRow(at: indexPath, animated: false)
		tableView.reloadData()
	}

	// MARK: - Received Notifications

	@objc private final func activityDefinitionChanged(notification: Notification) {
		if let newDefinition = notification.object as? ActivityDefinition {
			definition = newDefinition
			tableView.reloadData()
		} else {
			os_log("Wrong object type for activity definition changed notification", type: .error)
		}
	}

	@objc private final func startDateChanged(notification: Notification) {
		if let date = notification.object as? Date {
			startDate = date
			tableView.reloadData()
		} else {
			os_log("Wrong object type for start date changed notification", type: .error)
		}
	}

	@objc private final func endDateChanged(notification: Notification) {
		endDate = notification.object as? Date
		// clearing the end date is done by the cell itself so no need to have
		// it update its UI when set to nil
		if endDate != nil {
			tableView.reloadData()
		}
	}

	@objc private final func noteChanged(notification: Notification) {
		if let note = notification.object as? String? {
			self.note = note
		} else {
			os_log("Wrong object type for note changed notification", type: .error)
		}
	}

	@objc private final func tagsChanged(notification: Notification) {
		if let tagNames = notification.object as? Set<String> {
			self.tagNames = tagNames
		} else {
			os_log("Wrong object type for tags changed notification", type: .error)
		}
	}

	// MARK: - Actions

	@objc final func saveButtonPressed(_ sender: Any) {
		var activity: Activity! = self.activity
		var deleteActivityOnFail = false
		do {
			if activity == nil {
				activity = try DependencyInjector.sample.activity()
				deleteActivityOnFail = true
			}
			activity.definition = try DependencyInjector.db.pull(savedObject: definition!, fromSameContextAs: activity)
			activity.startDate = startDate
			activity.endDate = endDate
			activity.note = note
			try updateTagsForActivity(activity)
			DependencyInjector.db.save()
			DispatchQueue.main.async {
				NotificationCenter.default.post(name: self.notificationToSendOnAccept, object: activity)
			}
			navigationController?.popViewController(animated: true)
		} catch {
			if deleteActivityOnFail {
				DependencyInjector.db.delete(activity)
			}
			os_log("Failed to save activity: %@", type: .error, error.localizedDescription)
			showError(title: "Failed to save", message: "Sorry for the inconvenience")
		}
	}

	// MARK: - Helper Functions

	private final func updateTagsForActivity(_ activity: Activity) throws {
		var tagsCreated = [Tag]()
		var allTags = [Tag]()
		do {
			for tagName in tagNames {
				var tag: Tag! = try findTagWithName(tagName)
				if tag == nil {
					tag = try DependencyInjector.db.new(Tag.self)
					tag.name = tagName
					tagsCreated.append(tag)
				}
				allTags.append(tag)
			}
			try activity.setTags(allTags)
		} catch {
			for tag in tagsCreated {
				DependencyInjector.db.delete(tag)
			}
			throw error
		}
	}

	private final func findTagWithName(_ name: String) throws -> Tag? {
		let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let tags = try DependencyInjector.db.query(fetchRequest)
		if tags.count > 0 {
			return tags[0]
		}
		return nil
	}

	private final func validate() {
		saveButton?.isEnabled = definition != nil && !endDateIsBeforeStartDate()
	}

	private final func endDateIsBeforeStartDate() -> Bool {
		return endDate?.isBeforeDate(startDate, granularity: .second) ?? false
	}
}
