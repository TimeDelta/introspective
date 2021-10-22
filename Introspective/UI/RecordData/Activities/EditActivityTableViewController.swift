//
//  EditActivityTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 11/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import Presentr
import UIKit

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

public protocol EditActivityTableViewController: UITableViewController {
	var notificationToSendOnAccept: Notification.Name! { get set }
	var userInfoKey: UserInfoKey { get set }

	var activity: Activity? { get set }
	var autoFocusNote: Bool { get set }

	/// - Note: This will be overwritten if `activity` is set after this is
	var definition: ActivityDefinition? { get set }
}

public final class EditActivityTableViewControllerImpl: UITableViewController, EditActivityTableViewController {
	// MARK: - Static Variables

	private typealias Me = EditActivityTableViewControllerImpl

	// MARK: IndexPaths

	static let definitionIndex = IndexPath(row: 0, section: 0)
	static let startIndex = IndexPath(row: definitionIndex.row + 1, section: 0)
	static let endIndex = IndexPath(row: startIndex.row + 1, section: 0)
	static let durationIndex = IndexPath(row: endIndex.row + 1, section: 0)
	static let noteIndex = IndexPath(row: 0, section: 1)
	static let tagsIndex = IndexPath(row: 0, section: 2)

	// MARK: Presenters

	private static let presenter: Presentr = injected(UiUtil.self).customPresenter(
		width: .full,
		height: .fluid(percentage: 0.4),
		center: .bottomCenter
	)
	private static let datePresenter: Presentr = injected(UiUtil.self).customPresenter(
		width: .full,
		height: .custom(size: 150),
		center: .bottomCenter
	)

	// MARK: Notification Names

	static let activityDefinitionChanged = Notification.Name("activityDefinitionChanged")
	static let startDateChanged = Notification.Name("activityStartDateChanged")
	static let endDateChanged = Notification.Name("activityEndDateChanged")
	static let noteChanged = Notification.Name("activityNoteChanged")
	static let tagsChanged = Notification.Name("tagsChanged")
	static let durationChanged = Notification.Name("activityDurationChanged")

	// MARK: Logging

	private static let log = Log()

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: Notification.Name!
	public final var userInfoKey: UserInfoKey = .activity
	public final var activity: Activity? {
		didSet {
			guard let activity = activity else { return }
			definition = activity.definition
			startDate = activity.start
			startDateSetAt = activity.startSetAt
			endDate = activity.end
			endDateSetAt = activity.endSetAt
			note = activity.note
			tagNames = Set(activity.tagsArray().map { $0.name })
		}
	}

	public final var autoFocusNote = false

	/// - Note: This will be overwritten if `activity` is set after this is
	public final var definition: ActivityDefinition? { didSet { validate() } }
	final var startDate: Date = Date() {
		didSet {
			startDateSetAt = Date()
			validate()
		}
	}

	final var endDate: Date? {
		didSet {
			if endDate != nil {
				endDateSetAt = Date()
			} else {
				endDateSetAt = nil
			}
			validate()
		}
	}

	final var note: String?
	final var tagNames = Set<String>()
	final var startDateSetAt: Date?
	final var endDateSetAt: Date?

	private final var saveButton: UIBarButtonItem!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		extendedLayoutIncludesOpaqueBars = true

		saveButton = UIBarButtonItem(
			title: "Save",
			style: .done,
			target: self,
			action: #selector(saveButtonPressed)
		)
		navigationItem.rightBarButtonItem = saveButton

		observe(selector: #selector(activityDefinitionChanged), name: Me.activityDefinitionChanged)
		observe(selector: #selector(startDateChanged), name: Me.startDateChanged)
		observe(selector: #selector(endDateChanged), name: Me.endDateChanged)
		observe(selector: #selector(durationChanged), name: Me.durationChanged)
		observe(selector: #selector(noteChanged), name: Me.noteChanged)
		observe(selector: #selector(tagsChanged), name: Me.tagsChanged)

		if activity == nil {
			do {
				startDate = try injected(ActivityDAO.self).getMostRecentActivityEndDate() ?? Date()
			} catch {
				startDate = Date()
			}
		}

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
			return 4
		}
		return 1
	}

	public final override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let cell: UITableViewCell
		if indexPath == Me.definitionIndex {
			cell = tableView.dequeueReusableCell(withIdentifier: "activity", for: indexPath)
			cell.detailTextLabel?.text = definition?.name ?? "Choose Activity"
			cell.detailTextLabel?.accessibilityValue = cell.detailTextLabel?.text
			cell.detailTextLabel?.accessibilityLabel = "activity name"
			cell.accessibilityHint = "Tap this to change this instance to another activity definition"
		} else if indexPath == Me.startIndex {
			cell = tableView.dequeueReusableCell(withIdentifier: "start", for: indexPath)
			let startDateText = injected(CalendarUtil.self)
				.string(for: startDate, dateStyle: .medium, timeStyle: .medium)
			cell.detailTextLabel?.text = startDateText
			cell.detailTextLabel?.accessibilityValue = cell.detailTextLabel?.text
			cell.detailTextLabel?.accessibilityLabel = "start date"
			cell.accessibilityHint = "Tap this to change the start date"
		} else if indexPath == Me.endIndex {
			let endDateCell = tableViewCell(withIdentifier: "end", for: indexPath) as! ActivityEndDateTableViewCell
			endDateCell.endDate = endDate
			endDateCell.notificationToSendOnDateChange = Me.endDateChanged
			cell = endDateCell
			cell.accessibilityHint = "Tap this to change the end date"
		} else if indexPath == Me.durationIndex {
			cell = tableView.dequeueReusableCell(withIdentifier: "duration", for: indexPath)
			if let endDate = endDate {
				cell.detailTextLabel?.text = TimeDuration(start: startDate, end: endDate).description
			} else {
				cell.detailTextLabel?.text = ""
			}
			cell.detailTextLabel?.accessibilityValue = cell.detailTextLabel?.text
			cell.detailTextLabel?.accessibilityLabel = "duration"
			cell.accessibilityHint = "Tap this to change the duration (start date will remain the same)"
		} else if indexPath == Me.noteIndex {
			let noteCell = tableViewCell(withIdentifier: "note", for: indexPath) as! ActivityNoteTableViewCell
			noteCell.note = note
			noteCell.notificationToSendOnChange = Me.noteChanged
			noteCell.autoFocus = autoFocusNote
			cell = noteCell
		} else if indexPath == Me.tagsIndex {
			let tagsCell = tableViewCell(withIdentifier: "tags", for: indexPath) as! ActivityTagsTableViewCell
			tagsCell.tagNames = tagNames
			tagsCell.notificationToSendOnChange = Me.tagsChanged
			cell = tagsCell
		} else {
			cell = UITableViewCell()
			Me.log.error("Missing cell customization case for edit activity")
		}

		return cell
	}

	public final override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath == Me.noteIndex || indexPath == Me.tagsIndex {
			return 131
		}
		return 44
	}

	// MARK: - Table view delegate

	public final override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == Me.noteIndex.section {
			return "Note"
		}
		if section == Me.tagsIndex.section {
			return "Additional Tags"
		}
		return nil
	}

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath == Me.definitionIndex {
			let controller = viewController(
				named: "chooseActivityDefinition",
				fromStoryboard: "Util"
			) as! ChooseActivityDefinitionViewController
			controller.selectedDefinition = definition
			controller.notificationToSendOnAccept = Me.activityDefinitionChanged
			customPresentViewController(Me.presenter, viewController: controller, animated: false)
		} else if indexPath == Me.startIndex {
			let controller = viewController(named: "datePicker", fromStoryboard: "Util") as! SelectDateViewController
			controller.initialDate = startDate
			controller.notificationToSendOnAccept = Me.startDateChanged
			controller.lastDate = ((try? injected(ActivityDAO.self).getMostRecentActivityEndDate()) as Date??) ?? nil
			customPresentViewController(Me.datePresenter, viewController: controller, animated: false)
		} else if indexPath == Me.endIndex {
			let controller = viewController(named: "datePicker", fromStoryboard: "Util") as! SelectDateViewController
			controller.initialDate = endDate
			controller.notificationToSendOnAccept = Me.endDateChanged
			controller.lastDate = ((try? injected(ActivityDAO.self).getMostRecentActivityEndDate()) as Date??) ?? nil
			customPresentViewController(Me.datePresenter, viewController: controller, animated: false)
		} else if indexPath == Me.durationIndex {
			let controller = viewController(
				named: "durationChooser",
				fromStoryboard: "Util"
			) as! SelectDurationViewController
			controller.notificationToSendOnAccept = Me.durationChanged
			if endDate != nil {
				controller.initialDuration = TimeDuration(start: startDate, end: endDate)
			}
			let presenter = injected(UiUtil.self).customPresenter(
				width: .custom(size: 300),
				height: .custom(size: 215),
				center: .center
			)
			customPresentViewController(presenter, viewController: controller, animated: false)
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
		tableView.reloadData()
	}

	@objc private final func durationChanged(notification: Notification) {
		if let duration: TimeDuration = value(for: .duration, from: notification) {
			endDate = startDate + duration
			tableView.reloadData()
		}
	}

	@objc private final func noteChanged(notification: Notification) {
		note = value(for: .text, from: notification)
	}

	@objc private final func tagsChanged(notification: Notification) {
		if let tagNames: Set<String> = value(for: .tagNames, from: notification) {
			self.tagNames = tagNames
		}
	}

	// MARK: - Actions

	@objc final func saveButtonPressed(_: Any) {
		do {
			let transaction = injected(Database.self).transaction()

			// have to use local variable here otherwise everything will be
			// overwritten when activity.definition is set
			var activity: Activity! = self.activity
			if let localActivity = activity {
				activity = try transaction.pull(savedObject: localActivity)
			} else {
				activity = try transaction.new(Activity.self)
				activity.setSource(.introspective)
			}
			activity.definition = try transaction.pull(savedObject: definition!)
			activity.start = startDate
			activity.startSetAt = startDateSetAt
			activity.end = endDate
			activity.endSetAt = endDateSetAt
			if injected(Settings.self).autoTrimWhitespaceInActivityNotes {
				activity.note = note?.split(separator: "\n").map {
					str in str.trimmingCharacters(in: .whitespaces)
				}.joined(separator: "\n")
			} else {
				activity.note = note
			}
			try updateTagsForActivity(activity, using: transaction)
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
			activity = try injected(Database.self).pull(savedObject: activity)
			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: self.notificationToSendOnAccept,
					object: self,
					userInfo: self.info([
						self.userInfoKey: activity!,
					])
				)
			}
			navigationController?.popViewController(animated: false)
		} catch {
			Me.log.error("Failed to create, edit or save activity: %@", errorInfo(error))
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
		if !tags.isEmpty {
			return tags[0]
		}
		return nil
	}

	private final func validate() {
		saveButton?.isEnabled = definition != nil && !endDateIsBeforeStartDate()
	}

	private final func endDateIsBeforeStartDate() -> Bool {
		endDate?.isBeforeDate(startDate, granularity: .second) ?? false
	}
}
