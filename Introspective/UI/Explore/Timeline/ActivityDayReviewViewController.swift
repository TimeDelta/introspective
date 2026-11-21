import CoreData
import UIKit

import Common
import DependencyInjection
import Persistence
import Samples
import UIExtensions

/// A dated view of recorded activity and unknown intervals. Overlapping records
/// remain separate; only the gap calculation uses their union.
final class ActivityDayReviewViewController: UITableViewController {
	private static let recordChanged = Notification.Name("activityDayReviewRecordChanged")
	private var selectedDay: Date
	private var snapshot: ActivityCatchUpSnapshot?
	private var observers: [NSObjectProtocol] = []
	private var pendingActivityID: String?
	private let dayControl = UISegmentedControl(items: ["Today", "Yesterday"])
	private let dateButton = UIButton(type: .system)
	private let previousButton = UIButton(type: .system)
	private let nextButton = UIButton(type: .system)
	private let summaryLabel = UILabel()
	private lazy var dateSelection = ActivityReviewDateSelection(owner: self)
	private lazy var recordingUndoToolbar = ActivityRecordingUndoToolbar(owner: self)
	private let calendar = Calendar.autoupdatingCurrent

	init(day: Date? = nil, activityID: String? = nil) {
		let calendar = Calendar.autoupdatingCurrent
		let today = calendar.startOfDay(for: Date())
		let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
		selectedDay = calendar.startOfDay(for: min(day ?? (activityID == nil ? yesterday : today), today))
		pendingActivityID = activityID
		super.init(style: .insetGrouped)
	}
	required init?(coder: NSCoder) { fatalError("Use init(day:activityID:)") }
	deinit { observers.forEach(NotificationCenter.default.removeObserver) }

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Activity Review"
		tableView.accessibilityIdentifier = "activityDayReview"
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 72
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reminders", style: .plain,
			target: self, action: #selector(openReminders))
		configureHeader()
		for name in [Notification.Name.activityRecordingChanged, NotificationName.persistenceLayerDidRefresh.toName(), Self.recordChanged] {
			observers.append(NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
				guard let self = self, self.isViewLoaded, self.view.window != nil else { return }
				self.reloadReview()
			})
		}
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(reloadReview), for: .valueChanged)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		recordingUndoToolbar.show()
		reloadReview()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		recordingUndoToolbar.hide()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		recordingUndoToolbar.show()
		guard let id = pendingActivityID else { return }
		pendingActivityID = nil
		if let running = currentRunning.first(where: { $0.id == id }) {
			chooseEndTime(for: running)
		} else {
			openEditor(activityID: id)
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		guard let header = tableView.tableHeaderView else { return }
		let height = header.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width,
			height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required,
			verticalFittingPriority: .fittingSizeLevel).height
		if header.frame.height != height {
			header.frame.size.height = height
			tableView.tableHeaderView = header
		}
	}

	private var currentRunning: [ActivityRecordingItem] { snapshot?.running ?? [] }
	private var completed: [ActivityReviewRecord] { snapshot?.review.records.filter { $0.end != nil } ?? [] }

	private func configureHeader() {
		let header = UIView()
		let buttons = UIStackView(arrangedSubviews: [previousButton, dateButton, nextButton])
		buttons.axis = .horizontal; buttons.alignment = .center; buttons.spacing = 12
		dateButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
		previousButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
		nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
		previousButton.accessibilityLabel = "Previous day"
		nextButton.accessibilityLabel = "Next day"
		previousButton.addTarget(self, action: #selector(previousDay), for: .touchUpInside)
		nextButton.addTarget(self, action: #selector(nextDay), for: .touchUpInside)
		dateButton.addTarget(self, action: #selector(chooseDay), for: .touchUpInside)
		dateButton.accessibilityIdentifier = "chooseActivityReviewDate"
		dateButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
		dateButton.titleLabel?.adjustsFontForContentSizeCategory = true
		dateButton.titleLabel?.numberOfLines = 0
		dayControl.accessibilityIdentifier = "activityReviewDay"
		dayControl.addTarget(self, action: #selector(dayChosen), for: .valueChanged)
		summaryLabel.font = .preferredFont(forTextStyle: .footnote)
		summaryLabel.adjustsFontForContentSizeCategory = true
		summaryLabel.textColor = .secondaryLabel; summaryLabel.numberOfLines = 0
		let stack = UIStackView(arrangedSubviews: [dayControl, buttons, summaryLabel])
		stack.axis = .vertical; stack.spacing = 12; stack.translatesAutoresizingMaskIntoConstraints = false
		header.addSubview(stack)
		NSLayoutConstraint.activate([stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
			stack.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
			stack.topAnchor.constraint(equalTo: header.topAnchor, constant: 12),
			stack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -12),
			previousButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
			nextButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
			previousButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
			nextButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)])
		header.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 170)
		tableView.tableHeaderView = header
	}

	@objc private func reloadReview() {
		defer { refreshControl?.endRefreshing() }
		do {
			snapshot = try ActivityCatchUpService.loadDay(selectedDay)
			tableView.backgroundView = nil
		} catch {
			snapshot = nil
			let label = UILabel(); label.text = "Could not load activities. Pull to try again."
			label.numberOfLines = 0; label.textAlignment = .center
			tableView.backgroundView = label
			showError(title: "Could not load activities", error: error)
		}
		let today = calendar.startOfDay(for: Date())
		let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
		dayControl.selectedSegmentIndex = calendar.isDate(selectedDay, inSameDayAs: today) ? 0 :
			(yesterday.map { calendar.isDate(selectedDay, inSameDayAs: $0) } == true ? 1 : UISegmentedControl.noSegment)
		dateButton.setTitle(injected(CalendarUtil.self).string(for: selectedDay, dateStyle: .long, timeStyle: .none), for: .normal)
		dateButton.accessibilityLabel = "Choose review date"
		dateButton.accessibilityValue = dateButton.title(for: .normal)
		nextButton.isEnabled = selectedDay < today
		if let review = snapshot?.review {
			summaryLabel.text = "\(review.records.count) recorded entries · \(review.gaps.count) unrecorded intervals. Overlapping activities are kept."
		} else { summaryLabel.text = nil }
		tableView.reloadData(); view.setNeedsLayout()
	}

	@objc private func dayChosen() {
		let today = calendar.startOfDay(for: Date())
		selectedDay = dayControl.selectedSegmentIndex == 0 ? today : (calendar.date(byAdding: .day, value: -1, to: today) ?? today)
		reloadReview()
	}
	@objc private func previousDay() { moveDay(-1) }
	@objc private func nextDay() { moveDay(1) }
	private func moveDay(_ amount: Int) {
		guard let date = calendar.date(byAdding: .day, value: amount, to: selectedDay),
			date <= calendar.startOfDay(for: Date()) else { return }
		selectedDay = date; reloadReview()
	}
	@objc private func chooseDay() {
		dateSelection.present(initial: selectedDay, maximum: Date(), mode: .date) { [weak self] date in
			self?.selectedDay = date; self?.reloadReview()
		}
	}
	@objc private func openReminders() {
		navigationController?.pushViewController(ActivityRemindersViewController(style: .grouped), animated: true)
	}

	override func numberOfSections(in tableView: UITableView) -> Int { snapshot == nil ? 0 : 3 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section { case 0: return currentRunning.count; case 1: return completed.count; default: return snapshot?.review.gaps.count ?? 0 }
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0: return currentRunning.isEmpty ? nil : "Still running now"
		case 1: return completed.isEmpty ? "No completed activities" : "Recorded activities"
		default: return snapshot?.review.gaps.isEmpty == true ? "No unrecorded intervals" : "No activity recorded"
		}
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == 0, !currentRunning.isEmpty { return "Running timers include activities started on earlier days. Ending one leaves the others running." }
		if section == 2 { return "Unrecorded time is unknown. Fill only the intervals you remember; a complete day is not required." }
		return nil
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.detailTextLabel?.font = .preferredFont(forTextStyle: .caption1)
		for label in [cell.textLabel, cell.detailTextLabel] { label?.numberOfLines = 0; label?.adjustsFontForContentSizeCategory = true }
		cell.accessoryType = .disclosureIndicator
		switch indexPath.section {
		case 0:
			let item = currentRunning[indexPath.row]
			cell.textLabel?.text = item.name
			cell.detailTextLabel?.text = "Started \(display(item.start)) · Still running"
			cell.accessibilityIdentifier = "activityReviewRunning.\(item.id)"
		case 1:
			let item = completed[indexPath.row]
			cell.textLabel?.text = item.name
			cell.detailTextLabel?.text = "\(display(item.start)) – \(display(item.end!))"
			cell.accessibilityIdentifier = "activityReviewRecord.\(item.id)"
		default:
			let gap = snapshot!.review.gaps[indexPath.row]
			cell.textLabel?.text = "No activity recorded"
			cell.detailTextLabel?.text = "\(display(gap.start)) – \(display(gap.end))"
			cell.accessibilityIdentifier = "activityReviewGap.\(indexPath.row)"
		}
		return cell
	}
	private func display(_ date: Date) -> String {
		injected(CalendarUtil.self).string(for: date,
			dateStyle: calendar.isDate(date, inSameDayAs: selectedDay) ? .none : .short, timeStyle: .medium)
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		switch indexPath.section {
		case 0:
			guard currentRunning.indices.contains(indexPath.row) else { return }
			showRunningActions(currentRunning[indexPath.row], source: tableView.cellForRow(at: indexPath))
		case 1:
			guard completed.indices.contains(indexPath.row) else { return }
			openEditor(activityID: completed[indexPath.row].id)
		default:
			guard let snapshot = snapshot, snapshot.review.gaps.indices.contains(indexPath.row) else { return }
			let editor = ActivityGapRecordViewController(interval: snapshot.review.gaps[indexPath.row], definitions: snapshot.definitions) { [weak self] result in
				self?.reloadReview()
				if let id = result.autoNoteActivityIDs.first { self?.openEditor(activityID: id, focusNote: true) }
			}
			navigationController?.pushViewController(editor, animated: true)
		}
	}

	private func showRunningActions(_ item: ActivityRecordingItem, source: UIView?) {
		let sheet = UIAlertController(title: item.name, message: "Other running activities keep their own times.", preferredStyle: .actionSheet)
		sheet.addAction(UIAlertAction(title: "Stop now", style: .default) { [weak self] _ in self?.finish(item, at: Date()) })
		sheet.addAction(UIAlertAction(title: "End earlier…", style: .default) { [weak self] _ in
			DispatchQueue.main.async { self?.chooseEndTime(for: item) }
		})
		sheet.addAction(UIAlertAction(title: "Edit record", style: .default) { [weak self] _ in self?.openEditor(activityID: item.id) })
		sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		if let popover = sheet.popoverPresentationController {
			popover.sourceView = source ?? tableView; popover.sourceRect = source?.bounds ?? tableView.bounds
		}
		present(sheet, animated: false)
	}
	private func chooseEndTime(for item: ActivityRecordingItem) {
		let now = Date()
		let reviewEnd = snapshot?.review.reviewInterval.end
		let initial = reviewEnd.flatMap { $0 > item.start ? min($0, now) : nil } ?? now
		dateSelection.present(initial: initial, minimum: item.start, maximum: now) { [weak self] date in
			self?.finish(item, at: date)
		}
	}
	private func finish(_ item: ActivityRecordingItem, at date: Date) {
		do {
			let undoable = try ActivityQuickRecorder.stopWithUndo(activityID: item.id, at: date, recordedAt: Date())
			ActivityRecordingUndoSession.shared.record(undoable, title: "Stopped activity")
			let result = undoable.recording
			reloadReview()
			if let id = result.autoNoteActivityIDs.first { openEditor(activityID: id, focusNote: true) }
		} catch { reloadReview(); showError(title: "Could not finish activity", error: error) }
	}
	private func openEditor(activityID: String, focusNote: Bool = false) {
		do {
			let activity = try ActivityCatchUpService.activity(id: activityID)
			let controller: EditActivityTableViewControllerImpl = viewController(named: "editActivity", fromStoryboard: "RecordData")
			controller.activity = activity; controller.autoFocusNote = focusNote
			controller.notificationToSendOnAccept = Self.recordChanged
			navigationController?.pushViewController(controller, animated: false)
		} catch { reloadReview(); showError(title: "Activity unavailable", error: error) }
	}
}

private final class ActivityGapRecordViewController: UITableViewController {
	private let interval: DateInterval
	private var start: Date
	private var end: Date
	private var definitions: [ActivityRecordingDefinition]
	private var definition: ActivityRecordingDefinition?
	private var saving = false
	private let saved: (ActivityRecordingResult) -> Void
	private lazy var dateSelection = ActivityReviewDateSelection(owner: self)
	init(interval: DateInterval, definitions: [ActivityRecordingDefinition], saved: @escaping (ActivityRecordingResult) -> Void) {
		self.interval = interval; start = interval.start; end = interval.end; self.definitions = definitions; self.saved = saved
		super.init(style: .insetGrouped)
	}
	required init?(coder: NSCoder) { fatalError("Use init(interval:definitions:saved:)") }
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Record Past Activity"; tableView.accessibilityIdentifier = "activityGapEditor"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 72
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
		updateSave()
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 3 }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		"The interval starts and ends at neighboring records or the day's boundary. Adjust it to the time you remember. Existing activities are not changed."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil); cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = ["Activity", "Start", "End"][indexPath.row]
		cell.detailTextLabel?.text = indexPath.row == 0 ? (definition?.name ?? "Choose an activity") :
			injected(CalendarUtil.self).string(for: indexPath.row == 1 ? start : end, dateStyle: .medium, timeStyle: .medium)
		cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.detailTextLabel?.font = .preferredFont(forTextStyle: .caption1)
		for label in [cell.textLabel, cell.detailTextLabel] { label?.numberOfLines = 0; label?.adjustsFontForContentSizeCategory = true }
		cell.accessibilityIdentifier = ["activityGapDefinition", "activityGapStart", "activityGapEnd"][indexPath.row]
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		if indexPath.row == 0 {
			do {
				let context = try ActivityCatchUpService.choices(for: interval)
				let selectedID = definition?.id
				definitions = context.definitions
				definition = definitions.first { $0.id == selectedID }
				tableView.reloadData(); updateSave()
				guard !definitions.isEmpty else { showError(title: "No activities available", message: "Create an activity in Record → Activities first."); return }
				let chooser = ActivityReviewDefinitionChooser(context: context, selectedID: definition?.id) { [weak self] selected in
					self?.definition = selected; self?.tableView.reloadData(); self?.updateSave()
				}
				navigationController?.pushViewController(chooser, animated: true)
			} catch {
				showError(title: "Could not load activity choices", error: error)
			}
		} else {
			let changesStart = indexPath.row == 1
			dateSelection.present(initial: changesStart ? start : end, minimum: changesStart ? interval.start : start,
				maximum: changesStart ? end : interval.end) { [weak self] date in
				guard let self = self else { return }
				if changesStart { self.start = date } else { self.end = date }
				self.tableView.reloadData(); self.updateSave()
			}
		}
	}
	private func updateSave() {
		navigationItem.rightBarButtonItem?.isEnabled = !saving && definition != nil && start < end && start >= interval.start && end <= interval.end && end <= Date()
	}
	@objc private func save() {
		guard !saving, let definition = definition, start < end, start >= interval.start, end <= interval.end else { return }
		saving = true
		updateSave()
		do {
			let result = try ActivityCatchUpService.recordGap(definitionID: definition.id, from: start, to: end, recordedAt: Date())
			ActivityRecordingUndoSession.shared.clear()
			guard let navigation = navigationController else { return }
			navigation.popViewController(animated: false)
			saved(result)
		} catch {
			saving = false
			if let refreshed = try? ActivityQuickRecorder.snapshot() {
				definitions = refreshed.definitions
				self.definition = definitions.first { $0.id == definition.id }
			}
			tableView.reloadData(); updateSave()
			showError(title: "Could not record interval", error: error)
		}
	}
}

private final class ActivityReviewDefinitionChooser: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
	private struct Choice {
		let definition: ActivityRecordingDefinition
		let detail: String?
		let kind: String
	}
	private struct Section {
		let title: String
		let rows: [Choice]
	}
	private let sections: [Section]
	private let all: [Choice]
	private var shown: [Section]
	private let selectedID: String?
	private let choose: (ActivityRecordingDefinition) -> Void
	private let search = UISearchController(searchResultsController: nil)
	private var pendingSelection: ActivityRecordingDefinition?
	private var selectionInProgress = false
	init(context: ActivityGapChoiceSnapshot, selectedID: String?, choose: @escaping (ActivityRecordingDefinition) -> Void) {
		let definitions = Dictionary(uniqueKeysWithValues: context.definitions.map { ($0.id, $0) })
		let nearby = context.choices.neighbors.compactMap { neighbor -> Choice? in
			guard let definition = definitions[neighbor.definitionID] else { return nil }
			let detail = neighbor.before && neighbor.after ? "Before and after this gap" :
				(neighbor.before ? "Before this gap" : "After this gap")
			return Choice(definition: definition, detail: detail, kind: "neighbor")
		}
		let recent = context.choices.recentDefinitionIDs.compactMap { id -> Choice? in
			guard let definition = definitions[id] else { return nil }
			return Choice(definition: definition, detail: nil, kind: "recent")
		}
		let all = context.definitions.map { Choice(definition: $0, detail: nil, kind: "all") }
		var sections: [Section] = []
		if !nearby.isEmpty { sections.append(Section(title: "Around this gap", rows: nearby)) }
		if !recent.isEmpty { sections.append(Section(title: "Recent", rows: recent)) }
		sections.append(Section(title: "All activities", rows: all))
		self.sections = sections; self.all = all; shown = sections
		self.selectedID = selectedID; self.choose = choose
		super.init(style: .insetGrouped)
	}
	required init?(coder: NSCoder) { fatalError("Use init(context:selectedID:choose:)") }
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Choose Activity"; tableView.accessibilityIdentifier = "activityGapDefinitions"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 44
		search.searchResultsUpdater = self; search.delegate = self
		search.obscuresBackgroundDuringPresentation = false
		navigationItem.searchController = search; definesPresentationContext = true
	}
	func updateSearchResults(for searchController: UISearchController) {
		let query = (searchController.searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
		shown = query.isEmpty ? sections : [Section(title: "All activities", rows:
			all.filter { $0.definition.name.localizedCaseInsensitiveContains(query) })]
		tableView.reloadData()
	}
	override func numberOfSections(in tableView: UITableView) -> Int { shown.count }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { shown[section].rows.count }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { shown[section].title }
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let choice = shown[indexPath.section].rows[indexPath.row]
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.textLabel?.text = choice.definition.name
		cell.detailTextLabel?.text = choice.detail
		cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.detailTextLabel?.font = .preferredFont(forTextStyle: .caption1)
		cell.textLabel?.adjustsFontForContentSizeCategory = true
		cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
		cell.textLabel?.numberOfLines = 0
		cell.detailTextLabel?.numberOfLines = 0
		cell.accessoryType = choice.definition.id == selectedID ? .checkmark : .none
		cell.accessibilityIdentifier = "activityGapChoice.\(choice.kind).\(choice.definition.id)"
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard !selectionInProgress else { return }
		let selected = shown[indexPath.section].rows[indexPath.row].definition
		selectionInProgress = true
		if search.isActive {
			// Dismiss the presented search before removing its presentation context.
			pendingSelection = selected
			search.isActive = false
		} else {
			finishSelecting(selected)
		}
	}
	func didDismissSearchController(_ searchController: UISearchController) {
		guard searchController === search, let selected = pendingSelection else { return }
		pendingSelection = nil
		finishSelecting(selected)
	}
	private func finishSelecting(_ selected: ActivityRecordingDefinition) {
		selectionInProgress = false
		guard let navigation = navigationController, navigation.topViewController === self else { return }
		navigation.popViewController(animated: false)
		choose(selected)
	}
}

/// Shared picker adapter: accept unchanged/Now values exactly, and let the
/// existing picker apply its manual lower-unit precision rule.
final class ActivityReviewDateSelection {
	private weak var owner: UIViewController?
	private weak var picker: UIViewController?
	private var accept: ((Date) -> Void)?
	private var observer: NSObjectProtocol?
	private let notification = Notification.Name("activityReviewDate-" + UUID().uuidString)
	init(owner: UIViewController) {
		self.owner = owner
		observer = NotificationCenter.default.addObserver(forName: notification, object: nil, queue: .main) { [weak self] value in
			guard let self = self, let owner = self.owner, let picker = self.picker,
				value.object as AnyObject? === picker, let date: Date = owner.value(for: .date, from: value),
				let accept = self.accept else { return }
			self.accept = nil; self.picker = nil
			DispatchQueue.main.async { [weak owner] in
				guard let owner = owner, owner.viewIfLoaded?.window != nil else { return }
				accept(date)
			}
		}
	}
	deinit { if let observer = observer { NotificationCenter.default.removeObserver(observer) } }
	func present(initial: Date, minimum: Date? = nil, maximum: Date? = nil,
		mode: UIDatePicker.Mode = .dateAndTime, accept: @escaping (Date) -> Void) {
		guard let owner = owner else { return }
		let controller: SelectDateViewControllerImpl = owner.viewController(named: "datePicker", fromStoryboard: "Util")
		controller.initialDate = initial; controller.earliestPossibleDate = minimum; controller.latestPossibleDate = maximum
		controller.datePickerMode = mode; controller.notificationToSendOnAccept = notification
		self.accept = accept; picker = controller
		let present = { [weak owner] in
			guard let owner = owner, owner.viewIfLoaded?.window != nil else { return }
			owner.customPresentViewController(SelectDateViewControllerImpl.presenter, viewController: controller, animated: false)
		}
		if let sheet = owner.presentedViewController as? UIAlertController {
			sheet.dismiss(animated: false, completion: present)
		} else { present() }
	}
}
