//
//  RecordDataTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Presentr
import UIKit

import Common
import DependencyInjection
import Samples
import Settings

final class RecordDataTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
	// MARK: - Static Variables

	private typealias Me = RecordDataTableViewController

	public static let showErrorMessage = Notification.Name("showErrorOnRecordDataScreen")
	public static let showViewController = Notification.Name("showViewController")

	private static let moodId = "mood"
	private static let continuousMoodId = "continuousMood"
	private static let discreteMoodId = "discreteMood"

	private static let fatigueId = "fatigue"
	private static let continuousFatigueId = "continuousFatigue"
	private static let discreteFatigueId = "discreteFatigue"

	private static let painId = "pain"
	private static let continuousPainId = "continuousPain"
	private static let discretePainId = "discretePain"

	private static let medicationId = "medication"
	private static let activityId = "activity"

	private static let log = Log()

	// MARK: - Instance Variables

	private final var viewOrder = [
		Me.moodId,
		Me.painId,
		Me.fatigueId,
		Me.medicationId,
		Me.activityId,
	]
	private final var viewHeights: [String: CGFloat] = [
		Me.continuousMoodId: 145,
		Me.discreteMoodId: 145,
		Me.continuousFatigueId: 145,
		Me.discreteFatigueId: 145,
		Me.continuousPainId: 180,
		Me.discretePainId: 180,
		Me.medicationId: 52,
		Me.activityId: 52,
	]

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mood History", style: .plain,
			target: self, action: #selector(showMoodHistory))
		navigationItem.rightBarButtonItems = [navigationItem.rightBarButtonItem!, UIBarButtonItem(title: "Lost Items", style: .plain, target: self, action: #selector(showLostItems))]
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Check-ins", style: .plain, target: self, action: #selector(showMoodTools))
		NotificationCenter.default.addObserver(self, selector: #selector(showMoodPresets), name: MoodReminderScheduler.openCheckInNotification, object: nil)
		observe(selector: #selector(showViewController), name: Me.showViewController)
		observe(selector: #selector(showErrorMessage), name: Me.showErrorMessage)
		observe(selector: #selector(showRecordActivitiesScreen), name: .showRecordActivitiesScreen)
		observe(selector: #selector(showRecordMedicationsScreen), name: .showRecordMedicationsScreen)
		observe(selector: #selector(reloadData), name: MoodUiUtilImpl.useDiscreteMoodChanged)
		observe(selector: #selector(reloadData), name: FatigueUiUtilImpl.useDiscreteFatigueChanged)
		observe(selector: #selector(reloadData), name: PainUiUtilImpl.useDiscretePainChanged)

		hideKeyboardOnTapNonTextInput()
	}

	#if DEBUG
	final override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// A lifecycle appearance endpoint, not a measurement of the first rendered frame.
		UILaunchProfileRecorder.current?.record(.initialViewAppeared)
	}
	#endif

	@objc private func showLostItems() { pushToNavigationController(LostItemsViewController(style: .grouped)) }
	@objc private func showMoodTools() { pushToNavigationController(MoodToolsViewController(style: .grouped)) }
	@objc private func showMoodPresets() {
		if !(navigationController?.topViewController is MoodPresetsViewController) {
			pushToNavigationController(MoodPresetsViewController(style: .grouped))
		}
	}

	@objc private func showMoodHistory() {
		pushToNavigationController(MoodHistoryViewController(style: .grouped))
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table view data source

	final override func numberOfSections(in _: UITableView) -> Int {
		1
	}

	final override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
		viewOrder.count
	}

	// MARK: - Table view delegate

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let id = getIdFor(indexPath)
		return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
	}

	final override func tableView(_: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		viewOrder.swapAt(fromIndexPath.row, to.row)
	}

	final override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let id = getIdFor(indexPath)
		if let height = viewHeights[id] {
			return height
		}
		Me.log.error("Failed to retrieve height for id: %@", id)
		// return the largest possible size so that all content is shown
		return viewHeights.map { $0.value }.sorted()[0]
	}

	final override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == viewOrder.firstIndex(of: Me.medicationId) {
			navigationController?.pushViewController(viewController(named: "medicationsTable"), animated: false)
		} else if indexPath.row == viewOrder.firstIndex(of: Me.activityId) {
			navigationController?.pushViewController(viewController(named: "activitiesTable"), animated: false)
		}
	}

	final override func tableView(
		_ tableView: UITableView,
		trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		var actions: [UIContextualAction] = []
		let id = getIdFor(indexPath)
		if isMoodId(id) {
			if let _ = try? injected(MoodDAO.self).getMostRecentMood() {
				actions.append(getEditLastMoodAction())
			}
		}
		if isFatigueId(id) {
			if let _ = try? injected(FatigueDAO.self).getMostRecentFatigue() {
				actions.append(getEditLastFatigueAction())
			}
		}
		if isPainId(id) {
			if let _ = try? injected(PainDAO.self).getMostRecentPain() {
				actions.append(getEditLastPainAction())
			}
		}
		return UISwipeActionsConfiguration(actions: actions)
	}

	// MARK: - Received Notifications

	@objc private final func showViewController(notification: Notification) {
		if let controller: UIViewController = value(for: .controller, from: notification) {
			let presenter: Presentr! = value(for: .presenter, from: notification) ?? injected(UiUtil.self)
				.defaultPresenter
			customPresentViewController(presenter, viewController: controller, animated: false)
		}
	}

	@objc private final func showErrorMessage(notification: Notification) {
		if let title: String = value(for: .title, from: notification) {
			if let error: Error = value(for: .error, from: notification) {
				if let message: String = value(for: .message, from: notification) {
					showError(title: title, message: message, error: error)
				} else {
					showError(title: title, error: error)
				}
			}
			if let message: String = value(for: .message, from: notification) {
				showError(title: title, message: message)
			} else {
				showError(title: title)
			}
		}
	}

	@objc private final func showRecordActivitiesScreen(notification _: Notification) {
		let controller: RecordActivityTableViewController = viewController(named: "activitiesTable")
		if let navigationController = navigationController {
			navigationController.pushViewController(controller, animated: false)
		} else {
			Me.log.error("no navigation controller")
		}
	}

	@objc private final func showRecordMedicationsScreen(notification _: Notification) {
		let controller: RecordMedicationTableViewController = viewController(named: "medicationsTable")
		if let navigationController = navigationController {
			navigationController.pushViewController(controller, animated: false)
		} else {
			Me.log.error("no navigation controller")
		}
	}

	@objc private func reloadData(notification _: Notification) {
		tableView.reloadData()
	}

	// MARK: - Helper Functions

	private final func getIdFor(_ indexPath: IndexPath) -> String {
		let id = viewOrder[indexPath.row]
		if id == Me.moodId {
			if injected(Settings.self).discreteMoods {
				return Me.discreteMoodId
			}
			return Me.continuousMoodId
		}
		if id == Me.fatigueId {
			if injected(Settings.self).discreteFatigue {
				return Me.discreteFatigueId
			}
			return Me.continuousFatigueId
		}
		if id == Me.painId {
			if injected(Settings.self).discretePain {
				return Me.discretePainId
			}
			return Me.continuousPainId
		}
		return id
	}

	private final func isMoodId(_ id: String) -> Bool {
		id == Me.discreteMoodId || id == Me.continuousMoodId || id == Me.moodId
	}

	private final func isFatigueId(_ id: String) -> Bool {
		id == Me.discreteFatigueId || id == Me.continuousFatigueId || id == Me.fatigueId
	}

	private func isPainId(_ id: String) -> Bool {
		id == Me.discretePainId || id == Me.continuousPainId || id == Me.painId
	}

	private final func getEditLastMoodAction() -> UIContextualAction {
		let action = injected(UiUtil.self).contextualAction(
			style: .normal,
			title: "✎ Last"
		) { _, _, completion in
			do {
				guard let mood = try injected(MoodDAO.self).getMostRecentMood() else {
					Me.log.error("Edit last mood action triggered with no mood records")
					completion(false)
					return
				}
				let controller = self.viewController(
					named: "editMood",
					fromStoryboard: "Util"
				) as! EditMoodTableViewController
				controller.mood = mood
				self.pushToNavigationController(controller)
			} catch {
				self.showError(title: "Failed to retrieve most recent mood entry", error: error)
			}
		}
		action.backgroundColor = .orange
		return action
	}

	private final func getEditLastFatigueAction() -> UIContextualAction {
		let action = injected(UiUtil.self).contextualAction(
			style: .normal,
			title: "✎ Last"
		) { _, _, completion in
			do {
				guard let fatigue = try injected(FatigueDAO.self).getMostRecentFatigue() else {
					Me.log.error("Edit last fatigue action triggered with no fatigue records")
					completion(false)
					return
				}
				let controller = self.viewController(
					named: "editFatigue",
					fromStoryboard: "Util"
				) as! EditFatigueTableViewController
				controller.fatigue = fatigue
				self.pushToNavigationController(controller)
			} catch {
				self.showError(title: "Failed to retrieve most recent fatigue entry", error: error)
			}
		}
		action.backgroundColor = .orange
		return action
	}

	private func getEditLastPainAction() -> UIContextualAction {
		let action = injected(UiUtil.self).contextualAction(
			style: .normal,
			title: "✎ Last"
		) { _, _, completion in
			do {
				guard let pain = try injected(PainDAO.self).getMostRecentPain() else {
					Me.log.error("Edit last pain action triggered with no pain records")
					completion(false)
					return
				}
				let controller = self.viewController(
					named: "editPain",
					fromStoryboard: "Util"
				) as! EditPainTableViewController
				controller.pain = pain
				self.pushToNavigationController(controller)
			} catch {
				self.showError(title: "Failed to retrieve most recent pain entry", error: error)
			}
		}
		action.backgroundColor = .orange
		return action
	}
}

/// A focused review flow alongside the existing quick recording controls.
final class MoodHistoryViewController: UITableViewController, UISearchResultsUpdating {
	var clock: () -> Date = { Date() }
	var calendarProvider: () -> Calendar = { .current }
	private let period: UISegmentedControl = {
		let control = UISegmentedControl(items: ["Today", "7 Days", "30 Days", "Day"])
		control.selectedSegmentIndex = 1
		return control
	}()
	private let search = UISearchController(searchResultsController: nil)
	private let historyHeader = UIView()
	private let dayNavigation = UIStackView()
	private let previousDay = UIButton(type: .system)
	private let selectedDayButton = UIButton(type: .system)
	private let nextDay = UIButton(type: .system)
	private var selectedDayHeight: NSLayoutConstraint?
	private var moods: [Mood] = []
	private var displayed: [Mood] = []
	private var selectedDay: Date?
	private var selectedDayCalendar: Calendar?
	private var historyWindow: MoodHistoryWindow?
	private var reviewCalendar = Calendar.current
	private var summary: MoodReviewSummary?
	private var loadError: String?
	private var observers: [NSObjectProtocol] = []
	private var pickerObserver: NSObjectProtocol?
	private weak var dayPicker: UIViewController?
	private let numbers: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal; formatter.maximumFractionDigits = 1
		formatter.locale = .autoupdatingCurrent
		return formatter
	}()
	private let entryDates: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium; formatter.timeStyle = .short
		formatter.locale = .autoupdatingCurrent
		return formatter
	}()
	private let dayDates: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .full; formatter.timeStyle = .none
		formatter.locale = .autoupdatingCurrent
		return formatter
	}()

	deinit {
		for observer in observers { NotificationCenter.default.removeObserver(observer) }
		if let observer = pickerObserver { NotificationCenter.default.removeObserver(observer) }
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Mood History"
		tableView.accessibilityIdentifier = "moodHistory"
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 70
		period.addTarget(self, action: #selector(reloadMoods), for: .valueChanged)
		period.accessibilityLabel = "Mood history period"
		period.accessibilityIdentifier = "moodHistoryPeriod"
		configureHeader()
		search.searchResultsUpdater = self
		search.obscuresBackgroundDuringPresentation = false
		search.searchBar.placeholder = "Search mood notes"
		navigationItem.searchController = search
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
			target: self, action: #selector(addMood))
		navigationItem.rightBarButtonItem?.accessibilityLabel = "Add mood check-in"
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(reloadMoods), for: .valueChanged)
		for name in [UIApplication.didBecomeActiveNotification, .NSCalendarDayChanged, .NSSystemTimeZoneDidChange] {
			observers.append(NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
				guard let self = self, self.viewIfLoaded?.window != nil else { return }
				self.reloadMoods()
			})
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		reloadMoods()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		resizeHeader()
	}

	/// May be selected before presentation; the first appearance then loads this day.
	func selectDay(_ date: Date) {
		selectedDay = date
		selectedDayCalendar = nil
		period.selectedSegmentIndex = 3
		if isViewLoaded { reloadMoods() }
	}

	private func configureHeader() {
		previousDay.setImage(UIImage(systemName: "chevron.left"), for: .normal)
		previousDay.accessibilityLabel = "Previous day"
		previousDay.accessibilityIdentifier = "moodHistoryPreviousDay"
		previousDay.addTarget(self, action: #selector(showPreviousDay), for: .touchUpInside)
		nextDay.setImage(UIImage(systemName: "chevron.right"), for: .normal)
		nextDay.accessibilityLabel = "Next day"
		nextDay.accessibilityIdentifier = "moodHistoryNextDay"
		nextDay.addTarget(self, action: #selector(showNextDay), for: .touchUpInside)
		selectedDayButton.titleLabel?.numberOfLines = 0
		selectedDayButton.titleLabel?.lineBreakMode = .byWordWrapping
		selectedDayButton.titleLabel?.textAlignment = .center
		selectedDayButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
		selectedDayButton.titleLabel?.adjustsFontForContentSizeCategory = true
		selectedDayButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		selectedDayButton.accessibilityLabel = "Choose mood history day"
		selectedDayButton.accessibilityIdentifier = "moodHistorySelectedDay"
		selectedDayButton.addTarget(self, action: #selector(chooseDay), for: .touchUpInside)
		dayNavigation.axis = .horizontal; dayNavigation.alignment = .fill; dayNavigation.spacing = 8
		for button in [previousDay, selectedDayButton, nextDay] {
			dayNavigation.addArrangedSubview(button)
			let height = button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
			// The hidden arranged row can collapse without conflicting with its touch targets.
			height.priority = UILayoutPriority(999); height.isActive = true
			if button === selectedDayButton { selectedDayHeight = height }
		}
		previousDay.widthAnchor.constraint(equalToConstant: 44).isActive = true
		nextDay.widthAnchor.constraint(equalToConstant: 44).isActive = true
		let stack = UIStackView(arrangedSubviews: [period, dayNavigation])
		stack.axis = .vertical; stack.spacing = 8; stack.translatesAutoresizingMaskIntoConstraints = false
		historyHeader.addSubview(stack)
		NSLayoutConstraint.activate([
			stack.leadingAnchor.constraint(equalTo: historyHeader.leadingAnchor, constant: 16),
			stack.trailingAnchor.constraint(equalTo: historyHeader.trailingAnchor, constant: -16),
			stack.topAnchor.constraint(equalTo: historyHeader.topAnchor, constant: 10),
			stack.bottomAnchor.constraint(equalTo: historyHeader.bottomAnchor, constant: -10),
		])
		dayNavigation.isHidden = period.selectedSegmentIndex != 3
		tableView.tableHeaderView = historyHeader
	}

	private func resizeHeader() {
		let width = tableView.bounds.width
		guard width > 0 else { return }
		let titleWidth = max(1, width - 32 - 88 - 16)
		let titleSize = selectedDayButton.titleLabel?.sizeThatFits(CGSize(width: titleWidth, height: .greatestFiniteMagnitude))
		selectedDayHeight?.constant = max(44, ceil(titleSize?.height ?? 0) + 16)
		let size = historyHeader.systemLayoutSizeFitting(CGSize(width: width, height: 0),
			withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
		let height = ceil(size.height)
		guard historyHeader.frame.width != width || historyHeader.frame.height != height else { return }
		historyHeader.frame = CGRect(x: 0, y: 0, width: width, height: height)
		tableView.tableHeaderView = historyHeader
	}

	private func updateHeader() {
		dayNavigation.isHidden = period.selectedSegmentIndex != 3
		let date = historyWindow?.selectedDay
		let title = date.map { dayDates.string(from: $0) } ?? "Choose date"
		selectedDayButton.setTitle(title, for: .normal)
		selectedDayButton.accessibilityValue = date.map { dayDates.string(from: $0) }
		previousDay.isEnabled = date != nil
		nextDay.isEnabled = historyWindow?.canMoveForward == true
		resizeHeader()
	}

	@objc private func showPreviousDay() { moveDay(by: -1) }
	@objc private func showNextDay() { moveDay(by: 1) }
	private func moveDay(by amount: Int) {
		guard amount <= 0 || historyWindow?.canMoveForward == true else { return }
		guard let moved = historyWindow?.movingDay(by: amount), let date = moved.selectedDay else { return }
		selectDay(date)
	}

	@objc private func chooseDay() {
		if let observer = pickerObserver { NotificationCenter.default.removeObserver(observer) }
		let controller = viewController(named: "datePicker", fromStoryboard: "Util") as! SelectDateViewController
		let now = clock()
		controller.initialDate = historyWindow?.selectedDay ?? now
		controller.latestPossibleDate = now
		controller.datePickerMode = .date
		let name = Notification.Name("moodHistoryDaySelected.\(UUID().uuidString)")
		controller.notificationToSendOnAccept = name
		dayPicker = controller
		pickerObserver = NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { [weak self, weak expectedPicker = controller] notification in
			guard let self = self, let expectedPicker = expectedPicker,
				self.dayPicker === expectedPicker, (notification.object as? UIViewController) === expectedPicker,
				let date: Date = self.value(for: .date, from: notification) else { return }
			if let observer = self.pickerObserver { NotificationCenter.default.removeObserver(observer) }
			self.pickerObserver = nil; self.dayPicker = nil
			self.selectDay(date)
		}
		customPresentViewController(SelectDateViewControllerImpl.presenter, viewController: controller, animated: false)
	}

	@objc private func reloadMoods() {
		defer { refreshControl?.endRefreshing() }
		let now = clock(), calendar = calendarProvider()
		reviewCalendar = calendar
		entryDates.calendar = calendar; entryDates.timeZone = calendar.timeZone
		dayDates.calendar = calendar; dayDates.timeZone = calendar.timeZone
		let selection: MoodHistoryWindow.Selection
		switch period.selectedSegmentIndex {
		case 0: selection = .recentDays(1)
		case 2: selection = .recentDays(30)
		case 3:
			var date = selectedDay ?? now
			if let previousCalendar = selectedDayCalendar,
				previousCalendar.identifier == calendar.identifier, previousCalendar.timeZone != calendar.timeZone {
				// Keep the chosen civil date when travel changes local midnight's instant.
				var components = previousCalendar.dateComponents([.era, .year, .month, .day], from: date)
				// Calendar.Component.isLeapMonth requires iOS 17; DateComponents' flag supports older iOS.
				components.isLeapMonth = previousCalendar.dateComponents(in: previousCalendar.timeZone, from: date).isLeapMonth
				components.calendar = calendar; components.timeZone = calendar.timeZone
				date = calendar.date(from: components) ?? date
			}
			selection = .day(date)
		default: selection = .recentDays(7)
		}
		moods = []; displayed = []; summary = nil; loadError = nil
		historyWindow = MoodHistoryWindow(selection: selection, asOf: now, calendar: calendar)
		if let date = historyWindow?.selectedDay { selectedDay = date; selectedDayCalendar = calendar }
		updateHeader()
		guard let window = historyWindow else {
			loadError = "Choose a valid day, then pull to refresh to try again."
			tableView.reloadData(); return
		}
		do {
			moods = try injected(MoodDAO.self).getMoods(from: window.interval.start, to: window.interval.end)
				.filter { window.contains(MoodWeeklyReview.timestamp(for: $0)) }
				.sorted { MoodWeeklyReview.timestamp(for: $0) > MoodWeeklyReview.timestamp(for: $1) }
			updateSearchResults(for: search)
		} catch {
			loadError = "Could not load check-ins for this period. Pull to refresh to try again."
			tableView.reloadData()
		}
	}

	func updateSearchResults(for searchController: UISearchController) {
		let text = (searchController.searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
		displayed = text.isEmpty ? moods : moods.filter {
			($0.note ?? "").range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
		}
		summary = loadError == nil && historyWindow != nil ? MoodReviewSummary(moods: displayed, calendar: reviewCalendar) : nil
		tableView.reloadData()
	}

	override func numberOfSections(in tableView: UITableView) -> Int { 2 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		section == 0 ? 1 : displayed.count
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		section == 0 ? "Summary" : "Check-ins"
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if let message = loadError { return section == 0 ? message : nil }
		if section == 1 { return displayed.isEmpty ? "No matching check-ins. Tap + to record a mood, including a missed check-in." : nil }
		return "Average across displayed check-ins, adjusted for each entry's original scale. 0% is the lowest rating; 100% is the highest. Invalid scales and non-finite or out-of-range ratings are excluded from the average. Missing days are not zero ratings. Dates use recorded instants in your current calendar and time zone. These are descriptive summaries, not clinical scores."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.textLabel?.numberOfLines = 0
		cell.detailTextLabel?.numberOfLines = 0
		if indexPath.section == 0 {
			cell.accessibilityIdentifier = "moodHistorySummary"
			if let summary = summary {
				cell.textLabel?.text = "\(summary.checkInCount) check-ins on \(summary.recordedDayCount) days"
				let average = summary.averagePosition.map { "Average position: \(number($0 * 100))% of mood scale" } ?? "Average unavailable"
				cell.detailTextLabel?.text = average + "\n\(summary.ratedCheckInCount) valid ratings · \(summary.checkInCount - summary.ratedCheckInCount) excluded"
			} else {
				cell.textLabel?.text = loadError == nil ? "Loading mood history…" : "Mood history unavailable"
				cell.detailTextLabel?.text = loadError
			}
			cell.selectionStyle = .none
		} else {
			let mood = displayed[indexPath.row]
			cell.textLabel?.text = "\(entryDates.string(from: MoodWeeklyReview.timestamp(for: mood))) · \(number(mood.rating)) (\(number(mood.minRating))–\(number(mood.maxRating)))"
			cell.detailTextLabel?.text = mood.note?.isEmpty == false ? mood.note : "No note"
			cell.accessoryType = .disclosureIndicator
		}
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		guard indexPath.section == 1 else { return }
		edit(displayed[indexPath.row])
	}
	@objc private func addMood() { edit(nil) }
	private func edit(_ mood: Mood?) {
		let controller = viewController(named: "editMood", fromStoryboard: "Util") as! EditMoodTableViewController
		controller.mood = mood
		if mood == nil {
			controller.initialTimestamp = historyWindow?.newCheckInDate
			controller.navigationItem.prompt = historyWindow?.newCheckInDate == nil ? nil : "Choose the approximate time for this check-in."
		}
		pushToNavigationController(controller)
	}
	private func number(_ value: Double) -> String {
		numbers.string(from: NSNumber(value: value)) ?? "—"
	}
}
