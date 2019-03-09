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

public final class EditActivityTableViewController: UITableViewController {

	// MARK: - Static Variables

	private typealias Me = EditActivityTableViewController

	private static let activityIndex = IndexPath(row: 0, section: 0)
	private static let startIndex = IndexPath(row: activityIndex.row + 1, section: 0)
	private static let endIndex = IndexPath(row: startIndex.row + 1, section: 0)
	private static let noteIndex = IndexPath(row: 0, section: 1)
	private static let tagsIndex = IndexPath(row: 0, section: 2)

	private static let presenter: Presentr = DependencyInjector.util.ui.customPresenter(
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
	public final var userInfoKey: UserInfoKey = .activity
	public final var activity: Activity? {
		didSet {
			guard let activity = activity else { return }
			definition = activity.definition
			startDate = activity.start
			endDate = activity.end
			note = activity.note
			tagNames = Set(activity.tagsArray().map{ $0.name })
		}
	}
	public final var autoFocusNote = false

	/// This will be overridden if `activity` is set after this is
	public final var definition: ActivityDefinition? = nil { didSet { validate() } }
	private final var startDate: Date = Date() { didSet { validate() } }
	private final var endDate: Date? { didSet { validate() } }
	private final var note: String?
	private final var tagNames = Set<String>()

	private final var saveButton: UIBarButtonItem!

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		extendedLayoutIncludesOpaqueBars = true

		saveButton = UIBarButtonItem(
			title: "Save",
			style: .done,
			target: self,
			action: #selector(saveButtonPressed))
		navigationItem.rightBarButtonItem = saveButton

		observe(selector: #selector(activityDefinitionChanged), name: Me.activityDefinitionChanged)
		observe(selector: #selector(startDateChanged), name: Me.startDateChanged)
		observe(selector: #selector(endDateChanged), name: Me.endDateChanged)
		observe(selector: #selector(noteChanged), name: Me.noteChanged)
		observe(selector: #selector(tagsChanged), name: Me.tagsChanged)

		hideKeyboardOnTapNonTextInput()
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
			noteCell.autoFocus = autoFocusNote
			cell = noteCell
		} else if indexPath == Me.tagsIndex {
			let tagsCell = tableView.dequeueReusableCell(withIdentifier: "tags", for: indexPath) as! ActivityTagsTableViewCell
			tagsCell.tagNames = tagNames
			tagsCell.notificationToSendOnChange = Me.tagsChanged
			cell = tagsCell
		} else {
			cell = UITableViewCell()
			log.error("Missing cell customization case for edit activity")
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
			let controller: ChooseActivityDefinitionViewController = viewController(named: "chooseActivityDefinition", fromStoryboard: "Util")
			controller.selectedDefinition = definition
			controller.notificationToSendOnAccept = Me.activityDefinitionChanged
			customPresentViewController(Me.presenter, viewController: controller, animated: false)
		} else if indexPath == Me.startIndex {
			let controller: SelectDateViewController = viewController(named: "datePicker", fromStoryboard: "Util")
			controller.initialDate = startDate
			controller.notificationToSendOnAccept = Me.startDateChanged
			controller.lastDate = getMostRecentActivityDate()
			customPresentViewController(Me.presenter, viewController: controller, animated: false)
		} else if indexPath == Me.endIndex {
			let controller: SelectDateViewController = viewController(named: "datePicker", fromStoryboard: "Util")
			controller.initialDate = endDate
			controller.notificationToSendOnAccept = Me.endDateChanged
			controller.lastDate = getMostRecentActivityDate()
			customPresentViewController(Me.presenter, viewController: controller, animated: false)
		}
		tableView.deselectRow(at: indexPath, animated: false)
		tableView.reloadData()
	}

	// MARK: - Received Notifications

	@objc private final func activityDefinitionChanged(notification: Notification) {
		if let newDefinition: ActivityDefinition? = value(for: .activityDefinition, from: notification) {
			definition = newDefinition
			tableView.reloadData()
		}
	}

	@objc private final func startDateChanged(notification: Notification) {
		if let date: Date = value(for: .date, from: notification) {
			startDate = date
			tableView.reloadData()
		}
	}

	@objc private final func endDateChanged(notification: Notification) {
		endDate = value(for: .date, from: notification)
		// clearing the end date is done by the cell itself so no need to have
		// it update its UI when set to nil
		if endDate != nil {
			tableView.reloadData()
		}
	}

	@objc private final func noteChanged(notification: Notification) {
		self.note = value(for: .text, from: notification)
	}

	@objc private final func tagsChanged(notification: Notification) {
		if let tagNames: Set<String> = value(for: .tagNames, from: notification) {
			self.tagNames = tagNames
		}
	}

	// MARK: - Actions

	@objc final func saveButtonPressed(_ sender: Any) {
		do {
			let transaction = DependencyInjector.db.transaction()

			// have to use local variable here otherwise description will be
			// overwritten when self.activityDefinition is set
			var activity: Activity! = self.activity
			if let localActivity = activity {
				activity = try transaction.pull(savedObject: localActivity)
			} else {
				activity = try transaction.new(Activity.self)
				activity.setSource(.introspective)
			}
			activity.definition = try transaction.pull(savedObject: definition!)
			activity.start = startDate
			activity.end = endDate
			activity.note = note
			try updateTagsForActivity(activity, using: transaction)
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
			activity = try DependencyInjector.db.pull(savedObject: activity)
			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: self.notificationToSendOnAccept,
					object: self,
					userInfo: self.info([
						self.userInfoKey: activity,
					]))
			}
			navigationController?.popViewController(animated: false)
		} catch {
			log.error("Failed to create, edit or save activity: %@", errorInfo(error))
			showError(title: "Failed to save activity instance", error: error)
		}
	}

	// MARK: - Helper Functions

	private final func updateTagsForActivity(_ activity: Activity, using transaction: Transaction) throws {
		var tagsCreated = [Tag]()
		var allTags = [Tag]()
		for tagName in tagNames {
			var tag: Tag! = try findTagWithName(tagName, using: transaction)
			if tag == nil {
				tag = try transaction.new(Tag.self)
				tag.name = tagName
				tagsCreated.append(tag)
			}
			allTags.append(tag)
		}
		try activity.setTags(allTags)
	}

	private final func findTagWithName(_ name: String, using transaction: Transaction) throws -> Tag? {
		let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let tags = try transaction.query(fetchRequest)
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

	private final func getMostRecentActivityDate() -> Date? {
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "endDate != nil")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: false)]
		do {
			let activities = try DependencyInjector.db.query(fetchRequest)
			if activities.count > 0 {
				return activities[0].end
			}
		} catch {
			log.error("Failed to fetch most recent activity: %@", errorInfo(error))
		}
		return nil
	}
}
