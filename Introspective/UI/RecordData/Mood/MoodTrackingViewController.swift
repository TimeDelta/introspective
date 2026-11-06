import UIKit
import CoreData
import UserNotifications
import WidgetKit
import Common
import DependencyInjection
import Persistence
import Samples
import Settings

final class MoodToolsViewController: UITableViewController {
	private let options = ["Weekly Review", "Check-in Presets", "Reminders", "Stress Check-in", "Stress Review", "Manage Stressors", "Stress Guide", "Stress Reminders"]
	override func viewDidLoad() { super.viewDidLoad(); title = "Mood Check-ins" }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { options.count }
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		cell.textLabel?.text = options[indexPath.row]; cell.accessoryType = .disclosureIndicator
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		let controller: UIViewController
		switch indexPath.row {
		case 0: controller = MoodWeeklyReviewViewController(style: .grouped)
		case 1: controller = MoodPresetsViewController(style: .grouped)
		case 2: controller = MoodRemindersViewController(style: .grouped)
		case 3: controller = StressCheckInViewController()
		case 4: controller = StressReviewViewController(style: .grouped)
		case 5: controller = StressorsViewController(style: .grouped)
		case 6: controller = StressGuideViewController(style: .grouped)
		default: controller = StressRemindersViewController(style: .grouped)
		}
		navigationController?.pushViewController(controller, animated: true)
	}
}

final class MoodWeeklyReviewViewController: UITableViewController {
	var analyticsCalculation: ([MoodReviewObservation], Date, Bool, Calendar) -> MoodWeekComparison = {
		MoodWeekComparison(observations: $0, endingOn: $1, includingToday: $2, calendar: $3)
	}
	private var moods: [Mood] = []
	private var review = MoodWeeklyReview(moods: [])
	private var context: [MetricContextEntry] = []
	private var showsContext = false
	private var pendingMoods: [Mood] = []
	private var pendingContext: [MetricContextEntry] = []
	private var generation = UUID()
	private var calculation: DispatchWorkItem?
	private let window = UISegmentedControl(items: ["7 Complete Days", "Include Today"])
	private var observers: [NSObjectProtocol] = []
	deinit { calculation?.cancel(); for observer in observers { NotificationCenter.default.removeObserver(observer) } }
	private let numbers: NumberFormatter = {
		let value = NumberFormatter(); value.numberStyle = .decimal; value.maximumFractionDigits = 1; return value
	}()
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Weekly Mood Review"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 90
		tableView.accessibilityIdentifier = "weeklyMoodReview"
		window.selectedSegmentIndex = 0; window.accessibilityLabel = "Weekly review window"
		window.addTarget(self, action: #selector(load), for: .valueChanged)
		let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 56))
		window.translatesAutoresizingMaskIntoConstraints = false; header.addSubview(window)
		NSLayoutConstraint.activate([window.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
			window.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16), window.centerYAnchor.constraint(equalTo: header.centerYAnchor)])
		tableView.tableHeaderView = header
		for name in [UIApplication.didBecomeActiveNotification, .NSCalendarDayChanged, .NSSystemTimeZoneDidChange] {
			observers.append(NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
				if self?.viewIfLoaded?.window != nil { self?.load() }
			})
		}
		refreshControl = UIRefreshControl(); refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
	}
	override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); load() }
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated); calculation?.cancel(); generation = UUID()
		tableView.isUserInteractionEnabled = true; navigationItem.prompt = nil
		pendingMoods = []; pendingContext = []
	}
	@objc private func load() {
		calculation?.cancel(); let token = UUID(); generation = token
		do {
			let now = Date()
			let calendar = Calendar.current
			let includesToday = window.selectedSegmentIndex == 1
			let windows = MoodWeeklyReview.intervals(endingOn: now, includingToday: includesToday, calendar: calendar)
			pendingMoods = try injected(MoodDAO.self).getMoods(from: windows.previous.start, to: windows.current.end)
			let observations = MoodWeeklyReview.observations(for: pendingMoods)
			pendingContext = showsContext ? try injected(Database.self).query(MetricContextEntry.request(metric: .mood,
				interval: DateInterval(start: windows.previous.start, end: min(now, windows.current.end)))) : []
			tableView.isUserInteractionEnabled = false; navigationItem.prompt = "Updating review…"
			let calculate = analyticsCalculation
			let work = DispatchWorkItem { [weak self] in
				let analytics = calculate(observations, now, includesToday, calendar)
				DispatchQueue.main.async { [weak self] in
					guard let self = self, self.generation == token else { return }
					self.review = MoodWeeklyReview(analytics: analytics)
					self.moods = self.pendingMoods; self.context = self.pendingContext
					self.pendingMoods = []; self.pendingContext = []; self.calculation = nil
					self.tableView.isUserInteractionEnabled = true; self.navigationItem.prompt = nil
					self.refreshControl?.endRefreshing(); self.tableView.reloadData()
				}
			}
			calculation = work; DispatchQueue.global(qos: .userInitiated).async(execute: work)
		} catch {
			pendingMoods = []; pendingContext = []; tableView.isUserInteractionEnabled = true
			navigationItem.prompt = nil; refreshControl?.endRefreshing()
			showError(title: "Could not load weekly review", error: error)
		}
	}
	override func numberOfSections(in tableView: UITableView) -> Int { 6 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section { case 0: return 4; case 1: return 5; case 2, 4: return 2; case 3: return review.current.days.count; default: return 2 + context.count }
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		["Period comparison", "Rating distributions", "Recording coverage", "Day by day", "Median and variation", "Dated context"][section]
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		switch section {
		case 0: return "Daily averages give each day with valid ratings equal weight, so days with more check-ins do not dominate. The per-check-in average is shown separately. " + (window.selectedSegmentIndex == 1 ? "Today is incomplete. " : "Seven complete calendar days, ending yesterday. ") + "Tap a period to see entries. These are descriptions, not clinical scores or evidence of a cause."
		case 1: return "Each rating is positioned on its original scale: 0% is its minimum and 100% its maximum. Percentages use valid check-ins in each period, not all recorded entries."
		case 2: return "Missing days are not zero ratings. Days with invalid entries can be recorded without contributing an average. Sparse data and changes in recording frequency or sources limit comparisons. Imported Health daily moods and momentary emotions may be combined; this review cannot separate their kinds."
		case 3: return "Each row compares the same weekday in adjacent periods. Dates use the actual recorded instants in your current calendar and time zone. An em dash means no valid rating, not a neutral mood."
		case 4: return "Per-check-in median and middle 50% use linear percentile interpolation. Variation is the sample standard deviation in percentage points, available with at least two valid ratings. All values depend on which check-ins you recorded."
		default: return "Show mood context and entries marked for all metrics. Tap to review or add illness, travel, routine changes and other context."
		}
	}
	private func percent(_ value: Double?) -> String { value.map { (numbers.string(from: NSNumber(value: $0 * 100)) ?? "—") + "%" } ?? "Unavailable" }
	private func period(_ interval: DateInterval) -> String {
		let formatter = DateFormatter(); formatter.dateStyle = .medium
		return formatter.string(from: interval.start) + " – " + formatter.string(from: interval.end.addingTimeInterval(-1))
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.textLabel?.numberOfLines = 0; cell.detailTextLabel?.numberOfLines = 0; cell.selectionStyle = .none
		switch indexPath.section {
		case 0:
			if indexPath.row < 2 {
				let summary = indexPath.row == 0 ? review.current : review.previous
				cell.textLabel?.text = (indexPath.row == 0 ? "Recent: " : "Previous: ") + period(indexPath.row == 0 ? review.currentInterval : review.previousInterval)
				cell.detailTextLabel?.text = "Daily average: \(percent(summary.dailyAveragePosition))\nPer-check-in average: \(percent(summary.averagePosition)) · \(summary.checkInCount) check-ins"
				cell.accessoryType = .disclosureIndicator; cell.selectionStyle = .default
			} else {
				cell.textLabel?.text = indexPath.row == 2 ? "Change in daily average position" : "Change on matched weekdays"
				let difference = indexPath.row == 2 ? review.difference : review.analytics.matchedDayDifference
				cell.detailTextLabel?.text = difference.map {
					let value = numbers.string(from: NSNumber(value: abs($0) * 100)) ?? "—"
					return "\(value) percentage points " + ($0 > 0 ? "higher" : $0 < 0 ? "lower" : "(unchanged)")
				} ?? "Record valid ratings in both periods to compare."
				if indexPath.row == 3 {
					cell.detailTextLabel?.text = (cell.detailTextLabel?.text ?? "") + " · \(review.analytics.matchedDayCount) of 7 weekday pairs have valid ratings in both periods."
				}
			}
		case 1:
			let title = "\(indexPath.row * 20)% " + (indexPath.row < 4 ? "up to " : "through ") + "\((indexPath.row + 1) * 20)%"
			func count(_ summary: MoodPeriodAnalytics) -> String {
				let count = summary.distribution[indexPath.row]
				return "\(count) (\(percent(summary.ratedCheckInCount > 0 ? Double(count) / Double(summary.ratedCheckInCount) : nil)))"
			}
			return MoodDistributionCell(title: title, current: count(review.current), previous: count(review.previous),
				currentFraction: review.current.ratedCheckInCount > 0 ? Float(review.current.distribution[indexPath.row]) / Float(review.current.ratedCheckInCount) : 0,
				previousFraction: review.previous.ratedCheckInCount > 0 ? Float(review.previous.distribution[indexPath.row]) / Float(review.previous.ratedCheckInCount) : 0)
		case 2:
			let summary = indexPath.row == 0 ? review.current : review.previous
			cell.textLabel?.text = indexPath.row == 0 ? "Recent period" : "Previous period"
			cell.detailTextLabel?.text = "\(summary.recordedDayCount) of 7 days recorded · \(summary.ratedDayCount) days with valid ratings\n\(summary.ratedCheckInCount) valid of \(summary.checkInCount) check-ins\nExcluded: \(summary.invalidScaleCount) invalid scales, \(summary.invalidRatingCount) non-finite ratings, \(summary.outOfRangeCount) out-of-range ratings"
			let sources = summary.sourceCounts.keys.sorted().map { "\($0): \(summary.sourceCounts[$0] ?? 0)" }.joined(separator: ", ")
			if !sources.isEmpty { cell.detailTextLabel?.text = (cell.detailTextLabel?.text ?? "") + "\nSources: " + sources }
		case 3:
			let current = review.current.days[indexPath.row], previous = review.previous.days[indexPath.row]
			let formatter = DateFormatter(); formatter.dateFormat = "EEE, MMM d"
			cell.textLabel?.text = formatter.string(from: current.date) + " / " + formatter.string(from: previous.date)
			cell.detailTextLabel?.text = "Recent: \(current.averagePosition.map { percent($0) } ?? "—") (\(current.ratedCheckInCount)/\(current.checkInCount) valid) · Previous: \(previous.averagePosition.map { percent($0) } ?? "—") (\(previous.ratedCheckInCount)/\(previous.checkInCount) valid)"
		case 4:
			let summary = indexPath.row == 0 ? review.current : review.previous
			cell.textLabel?.text = indexPath.row == 0 ? "Recent period" : "Previous period"
			cell.detailTextLabel?.text = "Median: \(percent(summary.medianPosition)) · Middle 50%: \(percent(summary.lowerQuartile)) – \(percent(summary.upperQuartile))\nVariation: " + (summary.standardDeviation.map { (numbers.string(from: NSNumber(value: $0 * 100)) ?? "—") + " percentage points" } ?? "Unavailable")
		default:
			if indexPath.row == 0 {
				cell.textLabel?.text = "Show dated context"
				let toggle = UISwitch(); toggle.isOn = showsContext; toggle.accessibilityLabel = "Show dated context"
				toggle.addTarget(self, action: #selector(contextChanged), for: .valueChanged); cell.accessoryView = toggle
			} else if indexPath.row == 1 {
				cell.textLabel?.text = "Review or add mood context"
				cell.accessoryType = .disclosureIndicator; cell.selectionStyle = .default
			} else {
				let entry = context[indexPath.row - 2]
				cell.textLabel?.text = entry.category
				cell.detailTextLabel?.text = period(DateInterval(start: entry.timestamp, end: entry.endDate ?? entry.timestamp.addingTimeInterval(1))) + (entry.note.map { " · " + $0 } ?? "")
				cell.accessoryType = .disclosureIndicator; cell.selectionStyle = .default
			}
		}
		return cell
	}
	@objc private func contextChanged(_ sender: UISwitch) { showsContext = sender.isOn; load() }
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		if indexPath.section == 0 && indexPath.row < 2 {
			let interval = indexPath.row == 0 ? review.currentInterval : review.previousInterval
			let now = Date()
			let entries = moods.filter {
				let date = MoodWeeklyReview.timestamp(for: $0)
				return date >= interval.start && date < interval.end && date <= now
			}.sorted { MoodWeeklyReview.timestamp(for: $0) > MoodWeeklyReview.timestamp(for: $1) }
			navigationController?.pushViewController(MoodReviewEntriesViewController(moods: entries), animated: true)
		} else if indexPath.section == 5 && indexPath.row > 0 {
			navigationController?.pushViewController(MetricContextViewController(metric: .mood,
				interval: DateInterval(start: review.previousInterval.start, end: min(Date(), review.currentInterval.end))), animated: true)
		}
	}
}

private final class MoodDistributionCell: UITableViewCell {
	init(title: String, current: String, previous: String, currentFraction: Float, previousFraction: Float) {
		super.init(style: .default, reuseIdentifier: nil)
		selectionStyle = .none
		let heading = UILabel(); heading.text = title; heading.font = .preferredFont(forTextStyle: .body)
		heading.adjustsFontForContentSizeCategory = true; heading.numberOfLines = 0
		let stack = UIStackView(arrangedSubviews: [heading]); stack.axis = .vertical; stack.spacing = 8
		for (name, summary, fraction, color) in [("Recent", current, currentFraction, UIColor.systemBlue), ("Previous", previous, previousFraction, UIColor.systemGray)] {
			let label = UILabel(); label.text = name + ": " + summary; label.font = .preferredFont(forTextStyle: .caption1)
			label.adjustsFontForContentSizeCategory = true; label.numberOfLines = 0
			let bar = UIProgressView(progressViewStyle: .default); bar.progress = fraction; bar.progressTintColor = color
			bar.isAccessibilityElement = false
			stack.addArrangedSubview(label); stack.addArrangedSubview(bar)
		}
		stack.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview(stack)
		NSLayoutConstraint.activate([stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
			stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12), stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)])
		isAccessibilityElement = true; accessibilityLabel = title + ", Recent: " + current + ", Previous: " + previous
	}
	required init?(coder: NSCoder) { fatalError("Use init(title:current:previous:currentFraction:previousFraction:)") }
}

private final class MoodReviewEntriesViewController: UITableViewController {
	let moods: [Mood]
	init(moods: [Mood]) { self.moods = moods; super.init(style: .grouped) }
	required init?(coder: NSCoder) { fatalError("Use init(moods:)") }
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Period Check-ins"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 70
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { moods.count }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? { moods.isEmpty ? "No check-ins in this period." : nil }
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let mood = moods[indexPath.row], cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.textLabel?.text = injected(CalendarUtil.self).string(for: MoodWeeklyReview.timestamp(for: mood), dateStyle: .medium, timeStyle: .short) + " · \(mood.rating) (\(mood.minRating)–\(mood.maxRating))"
		cell.detailTextLabel?.text = mood.note?.isEmpty == false ? mood.note : "No note"
		cell.textLabel?.numberOfLines = 0; cell.detailTextLabel?.numberOfLines = 0
		return cell
	}
}

final class MoodPresetsViewController: UITableViewController {
	private(set) var presets: [MoodCheckInPreset] = []
	var preferences: MoodTrackingPreferences = .shared
	// Resolve the system notification center only when scheduling is needed;
	// callers can supply a scheduler before the controller performs any work.
	lazy var reminderScheduler: MoodReminderScheduler = .shared
	private var feedback: String?
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Check-in Presets"; tableView.accessibilityIdentifier = "moodPresets"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 70
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
		navigationItem.leftBarButtonItem = editButtonItem
		navigationItem.leftItemsSupplementBackButton = true
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		do { presets = try preferences.presets(); tableView.reloadData() }
		catch { showError(title: "Could not load presets", error: error) }
	}
	@objc private func add() { editPreset(nil) }
	private func editPreset(_ preset: MoodCheckInPreset?) {
		let settings = injected(Settings.self)
		let draft = preset ?? MoodCheckInPreset(name: "", rating: settings.minMood / 2 + settings.maxMood / 2,
			minimum: settings.minMood, maximum: settings.maxMood)
		let controller = MoodPresetEditorViewController(preset: draft) { [weak self] value in
			guard let self = self else { return }
			var updated = self.presets
			if let index = updated.firstIndex(where: { $0.id == value.id }) { updated[index] = value } else { updated.append(value) }
			try self.preferences.save(presets: updated); self.presets = updated
			if #available(iOS 14.0, *) { WidgetCenter.shared.reloadTimelines(ofKind: "MoodCheckInWidget") }
		}
		navigationController?.pushViewController(controller, animated: true)
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { presets.count }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		(feedback.map { $0 + "\n" } ?? "") + "Tap a preset to record now. Tap its info button to edit. Reorder with Edit; the first three appear in the modern widget. Add up to 20 presets. Ratings retain their saved scales."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let preset = presets[indexPath.row], cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.textLabel?.text = preset.name
		cell.detailTextLabel?.text = "\(preset.rating) (\(preset.minimum)–\(preset.maximum))" + (preset.note.isEmpty ? "" : " · " + preset.note)
		cell.detailTextLabel?.numberOfLines = 0; cell.accessoryType = .detailButton
		cell.accessibilityIdentifier = "moodPreset." + preset.id.uuidString
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		do {
			let preset = presets[indexPath.row]
			try MoodPresetRecorder.record(preset)
			MoodReminderService.refresh(preferences: preferences, scheduler: reminderScheduler)
			feedback = "Recorded \(preset.name)."; UIAccessibility.post(notification: .announcement, argument: feedback)
			tableView.reloadData()
		} catch { showError(title: "Could not record check-in", error: error) }
	}
	override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) { editPreset(presets[indexPath.row]) }
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { true }
	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		var updated = presets; let value = updated.remove(at: sourceIndexPath.row); updated.insert(value, at: destinationIndexPath.row)
		save(updated)
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		var updated = presets; updated.remove(at: indexPath.row); save(updated)
	}
	private func save(_ updated: [MoodCheckInPreset]) {
		do {
			try preferences.save(presets: updated); presets = updated
			if #available(iOS 14.0, *) { WidgetCenter.shared.reloadTimelines(ofKind: "MoodCheckInWidget") }
		} catch { showError(title: "Could not save presets", error: error) }
		tableView.reloadData()
	}
}

final class MoodPresetEditorViewController: UITableViewController {
	private var preset: MoodCheckInPreset
	private let savePreset: (MoodCheckInPreset) throws -> Void
	private var fields: [UITextField] = []
	private let names = ["Name", "Rating", "Minimum", "Maximum", "Note"]
	init(preset: MoodCheckInPreset, save: @escaping (MoodCheckInPreset) throws -> Void) {
		self.preset = preset; savePreset = save; super.init(style: .grouped)
	}
	required init?(coder: NSCoder) { fatalError("Use init(preset:save:)") }
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Edit Check-in Preset"
		let values = [preset.name, String(preset.rating), String(preset.minimum), String(preset.maximum), preset.note]
		fields = zip(names, values).enumerated().map { index, pair in
			let field = UITextField(); field.placeholder = pair.0; field.text = pair.1
			UITestFixtureLoader.configureLiteralInputForUITesting(field)
			field.accessibilityIdentifier = "moodPreset" + pair.0; field.accessibilityLabel = pair.0
			field.keyboardType = (1...3).contains(index) ? .numbersAndPunctuation : .default
			field.clearButtonMode = .whileEditing
			return field
		}
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
	}
	override func numberOfSections(in tableView: UITableView) -> Int { 2 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { section == 0 ? names.count : ContextCategory.allCases.count }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { section == 0 ? "Check-in" : "Optional dated context" }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		section == 0 ? "A preset records its saved rating, scale and note at the current time." : "Each selected context is recorded for Mood at the check-in time. It describes context, not a cause."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		if indexPath.section == 0 {
			let field = fields[indexPath.row]; field.translatesAutoresizingMaskIntoConstraints = false
			cell.contentView.addSubview(field)
			NSLayoutConstraint.activate([field.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor),
				field.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor),
				field.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10), field.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)])
		} else {
			let value = ContextCategory.allCases[indexPath.row].rawValue
			cell.textLabel?.text = value; cell.accessoryType = preset.contexts.contains(value) ? .checkmark : .none
		}
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		guard indexPath.section == 1 else { return }
		let value = ContextCategory.allCases[indexPath.row].rawValue
		if preset.contexts.contains(value) { preset.contexts.removeAll { $0 == value } } else { preset.contexts.append(value) }
		tableView.reloadRows(at: [indexPath], with: .none)
	}
	@objc private func save() {
		view.endEditing(true)
		do {
			guard let rating = Double(fields[1].text ?? ""), let minimum = Double(fields[2].text ?? ""), let maximum = Double(fields[3].text ?? "") else {
				throw MoodTrackingError("Enter numbers for the rating, minimum and maximum, using a decimal point if needed.")
			}
			preset.name = (fields[0].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
			preset.rating = rating; preset.minimum = minimum; preset.maximum = maximum; preset.note = fields[4].text ?? ""
			try preset.validate(); try savePreset(preset)
			navigationController?.popViewController(animated: true)
		} catch { showError(title: "Could not save preset", error: error) }
	}
}
