import UIKit
import CoreData
import Common
import DependencyInjection
import Persistence
import Samples

/// Describes recorded check-ins; missing answers and days never become zero stress.
final class StressReviewViewController: UITableViewController {
	var clock: () -> Date = { Date() }
	var calendarProvider: () -> Calendar = { .current }
	var loadCheckIns: (DateInterval, Date) throws -> [StressCheckIn] = { interval, now in
		let request = StressCheckIn.fetchRequest()
		request.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@ AND timestamp <= %@",
			interval.start as NSDate, interval.end as NSDate, now as NSDate)
		request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
		request.fetchBatchSize = 200
		request.relationshipKeyPathsForPrefetching = ["responses"]
		return try injected(Database.self).query(request)
	}
	/// Detail history has its own bound so an infrequent stressor is not hidden by
	/// the overview's newest 200 check-ins for other stressors.
	var loadStressorCheckIns: (UUID, DateInterval, Date) throws -> [StressCheckIn] = { id, interval, now in
		let request = StressCheckIn.fetchRequest()
		request.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@ AND timestamp <= %@ AND ANY responses.stressorKey == %@",
			interval.start as NSDate, interval.end as NSDate, now as NSDate, id.uuidString)
		request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
		request.fetchLimit = 200
		request.relationshipKeyPathsForPrefetching = ["responses"]
		return try injected(Database.self).query(request)
	}
	private let period: UISegmentedControl = {
		let value = UISegmentedControl(items: ["7 Days", "30 Days", "90 Days", "Compare"])
		value.selectedSegmentIndex = 0; return value
	}()
	private let changeDateButton = UIButton(type: .system)
	private let header = UIView()
	private var changeDateHeight: NSLayoutConstraint?
	private weak var detail: StressReviewDetailViewController?
	private var changeDate: Date?
	private var changeCalendar: Calendar?
	private var content: StressReviewContent?
	private var entries: [StressReviewEntry] = []
	private var pendingEntries: [StressReviewEntry] = []
	private var loadError: String?
	private var calculation: DispatchWorkItem?
	private var generation = UUID()
	private var observers: [NSObjectProtocol] = []
	private var formatter = StressReviewFormatter(calendar: .current)

	deinit {
		calculation?.cancel()
		for observer in observers { NotificationCenter.default.removeObserver(observer) }
	}
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Stress Review"
		tableView.accessibilityIdentifier = "stressReview"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 110
		period.accessibilityIdentifier = "stressReviewPeriod"
		period.accessibilityLabel = "Stress review period"
		period.addTarget(self, action: #selector(reloadReview), for: .valueChanged)
		changeDateButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
		changeDateButton.titleLabel?.adjustsFontForContentSizeCategory = true
		changeDateButton.titleLabel?.numberOfLines = 0
		changeDateButton.titleLabel?.lineBreakMode = .byWordWrapping
		changeDateButton.titleLabel?.textAlignment = .center
		changeDateButton.accessibilityIdentifier = "stressReviewChangeDate"
		changeDateButton.accessibilityLabel = "Choose the date of a change"
		changeDateButton.addTarget(self, action: #selector(chooseChangeDate), for: .touchUpInside)
		let height = changeDateButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
		height.priority = UILayoutPriority(999); height.isActive = true; changeDateHeight = height
		let stack = UIStackView(arrangedSubviews: [period, changeDateButton]); stack.axis = .vertical; stack.spacing = 8
		stack.translatesAutoresizingMaskIntoConstraints = false; header.addSubview(stack)
		NSLayoutConstraint.activate([stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
			stack.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
			stack.topAnchor.constraint(equalTo: header.topAnchor, constant: 10),
			stack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10)])
		changeDateButton.isHidden = true; tableView.tableHeaderView = header
		let appointment = UIBarButtonItem(title: "Appointment Prep", style: .plain, target: self, action: #selector(prepareForAppointment))
		appointment.accessibilityIdentifier = "stressReviewAppointmentPrep"
		navigationItem.rightBarButtonItem = appointment; appointment.isEnabled = false
		refreshControl = UIRefreshControl(); refreshControl?.addTarget(self, action: #selector(reloadReview), for: .valueChanged)
		for name in [UIApplication.didBecomeActiveNotification, .NSCalendarDayChanged, .NSSystemTimeZoneDidChange] {
			observers.append(NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
				guard let self = self, self.viewIfLoaded?.window != nil else { return }
				self.reloadReview()
			})
		}
	}
	override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); reloadReview() }
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		calculation?.cancel(); calculation = nil; generation = UUID(); pendingEntries = []
		navigationItem.prompt = nil; refreshControl?.endRefreshing()
	}
	override func viewDidLayoutSubviews() { super.viewDidLayoutSubviews(); resizeHeader() }
	private func resizeHeader() {
		let width = tableView.bounds.width
		guard width > 0 else { return }
		let titleSize = changeDateButton.titleLabel?.sizeThatFits(CGSize(width: max(1, width - 32), height: .greatestFiniteMagnitude))
		changeDateHeight?.constant = max(44, ceil(titleSize?.height ?? 0) + 16)
		let fitting = header.systemLayoutSizeFitting(CGSize(width: width, height: 0),
			withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
		let height = ceil(fitting.height)
		guard header.frame.width != width || header.frame.height != height else { return }
		header.frame = CGRect(x: 0, y: 0, width: width, height: height); tableView.tableHeaderView = header
	}

	/// A date-only choice uses its first valid local instant, including midnight DST gaps.
	func setComparisonDate(_ date: Date) {
		let now = clock(), calendar = calendarProvider()
		guard date.timeIntervalSinceReferenceDate.isFinite, now.timeIntervalSinceReferenceDate.isFinite else { return }
		changeDate = calendar.startOfDay(for: min(date, now)); changeCalendar = calendar
		period.selectedSegmentIndex = 3
		if isViewLoaded { reloadReview() }
	}
	@objc private func chooseChangeDate() {
		let controller = StressReviewDateViewController(date: changeDate ?? clock(), now: clock(), calendar: calendarProvider()) { [weak self] in
			self?.setComparisonDate($0)
		}
		navigationController?.pushViewController(controller, animated: true)
	}

	@objc func reloadReview() {
		calculation?.cancel(); let token = UUID(); generation = token
		content = nil; entries = []; pendingEntries = []; loadError = nil
		navigationItem.rightBarButtonItem?.isEnabled = false
		let now = clock(), calendar = calendarProvider()
		formatter = StressReviewFormatter(calendar: calendar)
		let comparing = period.selectedSegmentIndex == 3
		changeDateButton.isHidden = !comparing
		if comparing {
			if let date = changeDate, let previous = changeCalendar,
				previous.identifier == calendar.identifier, previous.timeZone != calendar.timeZone {
				var components = previous.dateComponents([.era, .year, .month, .day], from: date)
				components.isLeapMonth = previous.dateComponents(in: previous.timeZone, from: date).isLeapMonth
				components.calendar = calendar; components.timeZone = calendar.timeZone
				changeDate = calendar.date(from: components) ?? date
			}
			if changeDate == nil, now.timeIntervalSinceReferenceDate.isFinite {
				changeDate = calendar.date(byAdding: .day, value: -7, to: calendar.startOfDay(for: now))
			}
			changeCalendar = calendar
		}
		changeDateButton.setTitle(changeDate.map { "Change date: " + formatter.fullDate($0) } ?? "Choose a change date", for: .normal)
		resizeHeader()
		let first: DateInterval
		let second: DateInterval?
		if comparing, let date = changeDate,
			let windows = StressReviewWindow.comparisonIntervals(changeDate: date, asOf: now, calendar: calendar) {
			first = windows.before; second = windows.after
		} else if !comparing, let interval = StressReviewWindow.recentInterval(days: [7, 30, 90][max(0, min(2, period.selectedSegmentIndex))], asOf: now, calendar: calendar) {
			first = interval; second = nil
		} else {
			failLoad("Choose a valid past change date, then pull to refresh."); return
		}
		let interval = DateInterval(start: first.start, end: second?.end ?? first.end)
		do {
			let records = try loadCheckIns(interval, now).filter {
				$0.timestamp.timeIntervalSinceReferenceDate.isFinite && $0.timestamp >= interval.start && $0.timestamp < interval.end && $0.timestamp <= now
			}.sorted { $0.timestamp > $1.timestamp }
			// Copy values on the managed objects' owning queue. The worker never receives managed objects.
			let snapshots = records.map { StressReviewRecordSnapshot($0) }
			pendingEntries = Array(zip(records, snapshots).prefix(200).map { StressReviewEntry(checkIn: $0.0, snapshot: $0.1) })
			StressTrackingStore.releaseSnapshots(of: records)
			navigationItem.prompt = "Updating stress review…"; tableView.reloadData()
			let work = DispatchWorkItem { [weak self] in
				let result = makeStressReviewContent(records: snapshots, first: first, second: second, now: now, calendar: calendar)
				DispatchQueue.main.async { [weak self] in
					guard let self = self, self.generation == token else { return }
					self.content = result; self.entries = self.pendingEntries; self.pendingEntries = []; self.calculation = nil
					self.navigationItem.prompt = nil; self.navigationItem.rightBarButtonItem?.isEnabled = true
					self.refreshControl?.endRefreshing(); self.tableView.reloadData()
					if let detail = self.detail {
						self.updateDetail(detail, item: result.stressors.first { $0.id == detail.stressorID },
							interval: interval, asOf: result.asOf)
					}
				}
			}
			calculation = work; DispatchQueue.global(qos: .userInitiated).async(execute: work)
		} catch { failLoad("Could not load stress check-ins. Pull to refresh to try again.") }
	}
	private func failLoad(_ message: String) {
		loadError = message; content = nil; entries = []; pendingEntries = []; calculation = nil
		navigationItem.prompt = nil; refreshControl?.endRefreshing(); tableView.reloadData()
		detail?.update(item: nil, entries: [], formatter: formatter, asOf: clock(), error: message)
	}

	override func numberOfSections(in tableView: UITableView) -> Int { 3 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let content = content else { return section == 0 ? 1 : 0 }
		switch section { case 0: return content.overall.after == nil ? 2 : 3; case 1: return content.stressors.count; default: return entries.count }
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		["Overall stress", "Personal stressors", "Check-ins"][section]
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if let error = loadError { return section == 0 ? error : nil }
		switch section {
		case 0: return "Means describe positions on five ordinal anchors, not a validated clinical score. Daily means give each recorded day with valid ratings equal weight; the per-check-in mean is separate. Missing days and unanswered ratings are never zero. Before/after patterns do not establish a cause; other changes and recording frequency can affect them."
		case 1: return "Each stressor is reviewed separately using its stable identity, including archived stressors. Names in individual entries are preserved as recorded. Offered counts exclude check-ins before an item was added or after it was removed. Skipped and Not applicable are separate from None. Stressors are never summed."
		default:
			guard let content = content else { return nil }
			return "Showing the newest \(entries.count) of \(content.recordCount) matching check-ins. Summaries include all matching records. Tap an entry to review or edit it. Appointment Prep creates a readable summary; sharing requires an explicit action."
		}
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = stressReviewCell()
		guard let content = content else {
			cell.textLabel?.text = loadError == nil ? "Updating stress review…" : "Stress review unavailable"
			cell.detailTextLabel?.text = loadError; cell.selectionStyle = .none
			return cell
		}
		switch indexPath.section {
		case 0:
			cell.selectionStyle = .none
			if indexPath.row == 0 {
				cell.textLabel?.text = "Overall stress"; cell.detailTextLabel?.text = formatter.summary(content.overall, now: content.asOf)
				cell.accessibilityIdentifier = "stressReviewOverallSummary"
			} else if indexPath.row == 1 {
				cell.textLabel?.text = "Rating distribution"; cell.detailTextLabel?.text = formatter.distribution(content.overall)
				cell.accessibilityIdentifier = "stressReviewOverallDistribution"
			} else {
				cell.textLabel?.text = "Change in daily mean"; cell.detailTextLabel?.text = formatter.change(content.overall)
			}
		case 1:
			let item = content.stressors[indexPath.row]
			cell.textLabel?.text = item.name; cell.detailTextLabel?.text = formatter.summary(item, now: content.asOf)
			cell.accessibilityIdentifier = "stressReviewStressor.\(item.id!.uuidString)"; cell.accessoryType = .disclosureIndicator
		default:
			let record = entries[indexPath.row].snapshot
			cell.textLabel?.text = formatter.entryTitle(record)
			cell.detailTextLabel?.text = record.note?.isEmpty == false ? record.note : "No note"
			cell.accessoryType = .disclosureIndicator
		}
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		if indexPath.section == 2 { edit(entries[indexPath.row].checkIn) }
		else if indexPath.section == 1, let content = content {
			let item = content.stressors[indexPath.row]
			let interval = DateInterval(start: content.overall.before.interval.start,
				end: content.overall.after?.interval.end ?? content.overall.before.interval.end)
			let controller = StressReviewDetailViewController(item: item, entries: [], formatter: formatter, asOf: content.asOf) { [weak self] in self?.edit($0) }
			updateDetail(controller, item: item, interval: interval, asOf: content.asOf)
			detail = controller
			navigationController?.pushViewController(controller, animated: true)
		}
	}
	private func updateDetail(_ controller: StressReviewDetailViewController, item: StressReviewItem?,
		interval: DateInterval, asOf now: Date) {
		guard let item = item else {
			controller.update(item: nil, entries: [], formatter: formatter, asOf: now)
			return
		}
		do {
			let records = try loadStressorCheckIns(controller.stressorID, interval, now)
			defer { StressTrackingStore.releaseSnapshots(of: records) }
			let matching = records.filter {
				$0.timestamp.timeIntervalSinceReferenceDate.isFinite && $0.timestamp >= interval.start
					&& $0.timestamp < interval.end && $0.timestamp <= now
					&& $0.responses.contains { $0.stressorID == controller.stressorID }
			}.sorted { $0.timestamp > $1.timestamp }.prefix(200)
			let snapshots = matching.map { StressReviewEntry(checkIn: $0, snapshot: StressReviewRecordSnapshot($0)) }
			controller.update(item: item, entries: snapshots, formatter: formatter, asOf: now)
		} catch {
			controller.update(item: nil, entries: [], formatter: formatter, asOf: now,
				error: "Could not load this stressor's check-ins. Return to Stress Review and pull to refresh to try again.")
		}
	}
	private func edit(_ record: StressCheckIn) {
		let editor = StressCheckInViewController(checkIn: record)
		editor.onSave = { [weak self] _ in self?.reloadReview() }
		navigationController?.pushViewController(editor, animated: true)
	}
	@objc private func prepareForAppointment() {
		guard let content = content else { return }
		let controller = StressAppointmentPreparationViewController(content: content, formatter: formatter)
		navigationController?.pushViewController(controller, animated: true)
	}
}

private struct StressReviewEntry {
	let checkIn: StressCheckIn
	let snapshot: StressReviewRecordSnapshot
}
private struct StressReviewResponseSnapshot {
	let id: UUID
	let name: String
	let status: StressResponseStatus
	let rating: Int?
}
private struct StressReviewRecordSnapshot {
	let date: Date
	let rating: Int
	let note: String?
	let kind: String
	let scale: Int
	let responses: [StressReviewResponseSnapshot]
	init(_ record: StressCheckIn) {
		date = record.timestamp; rating = Int(record.overallRating); note = record.note
		kind = record.measurementKind; scale = Int(record.scaleVersion)
		responses = record.orderedResponses.map {
			let status = StressResponseStatus(rawValue: $0.statusKey)
			// Preserve malformed state/rating combinations for exclusion; the convenience
			// rating accessor intentionally returns nil for every non-rated response.
			let rawRating: Int? = $0.ratingValue.map {
				let value = $0.doubleValue
				return value.isFinite && value >= 0 && value <= 4 && value.rounded() == value ? Int(value) : Int.min
			}
			return StressReviewResponseSnapshot(id: $0.stressorID, name: $0.nameSnapshot,
				status: status ?? .rated, rating: status == nil ? nil : rawRating)
		}
	}
	var observation: StressRatingObservation { StressRatingObservation(date: date, rating: rating, measurementKind: kind, scaleVersion: scale) }
}
private struct StressReviewItem {
	let id: UUID?
	let name: String
	let before: StressPeriodAnalytics
	let after: StressPeriodAnalytics?
}
private struct StressReviewContent {
	let overall: StressReviewItem
	let stressors: [StressReviewItem]
	let recordCount: Int
	let recent: [StressReviewRecordSnapshot]
	let asOf: Date
}
private func makeStressReviewContent(records: [StressReviewRecordSnapshot], first: DateInterval, second: DateInterval?, now: Date, calendar: Calendar) -> StressReviewContent {
	func item(id: UUID?, name: String, observations: [StressRatingObservation]) -> StressReviewItem {
		StressReviewItem(id: id, name: name,
			before: StressPeriodAnalytics(observations: observations, interval: first, asOf: now, calendar: calendar),
			after: second.map { StressPeriodAnalytics(observations: observations, interval: $0, asOf: now, calendar: calendar) })
	}
	var groups: [UUID: [StressRatingObservation]] = [:]
	var names: [UUID: (name: String, date: Date)] = [:]
	for record in records {
		for response in record.responses {
			let value = StressRatingObservation(date: record.date, rating: response.rating, status: response.status, measurementKind: record.kind, scaleVersion: record.scale)
			groups[response.id, default: []].append(value)
			if names[response.id] == nil || record.date > names[response.id]!.date {
				names[response.id] = (response.name, record.date)
			}
		}
	}
	let stressors = groups.map { item(id: $0.key, name: names[$0.key]!.name, observations: $0.value) }.sorted {
		let order = $0.name.localizedStandardCompare($1.name)
		return order == .orderedSame ? $0.id!.uuidString < $1.id!.uuidString : order == .orderedAscending
	}
	return StressReviewContent(overall: item(id: nil, name: "Overall stress", observations: records.map { $0.observation }),
		stressors: stressors, recordCount: records.count, recent: Array(records.prefix(200)), asOf: now)
}

private final class StressReviewFormatter {
	private let dates = DateFormatter()
	private let fullDates = DateFormatter()
	private let times = DateFormatter()
	private let numbers = NumberFormatter()
	init(calendar: Calendar) {
		for formatter in [dates, fullDates, times] {
			formatter.calendar = calendar; formatter.timeZone = calendar.timeZone; formatter.locale = .autoupdatingCurrent
		}
		dates.dateStyle = .medium; fullDates.dateStyle = .full
		times.dateStyle = .medium; times.timeStyle = .short
		numbers.numberStyle = .decimal; numbers.maximumFractionDigits = 1; numbers.locale = .autoupdatingCurrent
	}
	func fullDate(_ date: Date) -> String { fullDates.string(from: date) }
	private func number(_ value: Double?) -> String { value.flatMap { numbers.string(from: NSNumber(value: $0)) } ?? "Unavailable" }
	func period(_ interval: DateInterval) -> String { dates.string(from: interval.start) + " – " + dates.string(from: interval.end.addingTimeInterval(-1)) }
	func summary(_ item: StressReviewItem, now: Date) -> String {
		func text(_ value: StressPeriodAnalytics, label: String) -> String {
			label + ": " + period(value.interval) + (value.interval.end > now ? " (incomplete, through now)" : "")
				+ "\nDaily mean: \(number(value.dailyAverageRating)) · Per-check-in mean: \(number(value.averageRating)) (0–4 anchors)"
				+ "\n\(value.recordedDayCount) recorded / \(value.ratedDayCount) rated / \(value.calendarDayCount) elapsed local days"
				+ "\n\(value.offeredCount) offered · \(value.ratedCount) rated · \(value.skippedCount) skipped · \(value.notApplicableCount) not applicable · \(value.excludedCount) excluded (\(value.invalidRatingCount) invalid, \(value.unsupportedMeasurementCount) unsupported question/scale)"
		}
		let first = text(item.before, label: item.after == nil ? "Period" : "Before")
		return item.after.map { first + "\n\n" + text($0, label: "After") } ?? first
	}
	func distribution(_ item: StressReviewItem) -> String {
		func text(_ value: StressPeriodAnalytics, label: String) -> String {
			label + "\n" + StressRating.allCases.map { rating in
				let count = value.distribution[rating.rawValue]
				let percent = value.ratedCount > 0 ? number(Double(count) / Double(value.ratedCount) * 100) + "%" : "Unavailable"
				return "\(rating.title): \(count) (\(percent))"
			}.joined(separator: "\n")
		}
		let first = text(item.before, label: item.after == nil ? "Valid rated check-ins" : "Before")
		return item.after.map { first + "\n\n" + text($0, label: "After") } ?? first
	}
	func change(_ item: StressReviewItem) -> String {
		guard let before = item.before.dailyAverageRating, let after = item.after?.dailyAverageRating else { return "Unavailable: record valid ratings in both periods to compare." }
		return "\(number(after - before)) anchor points after minus before. This is a description of recorded days, not evidence of the change's effect."
	}
	func entryTitle(_ record: StressReviewRecordSnapshot) -> String {
		let rating = StressRating(rawValue: record.rating)?.title ?? "Invalid overall rating"
		let supported = record.kind == StressCheckInDraft.supportedMeasurementKind && record.scale == StressCheckInDraft.currentScaleVersion
		return times.string(from: record.date) + " · " + rating + (supported ? "" : " (unsupported question/scale)")
	}
	func responseText(_ response: StressReviewResponseSnapshot) -> String {
		let value: String
		if response.status == .rated { value = response.rating.flatMap { StressRating(rawValue: $0)?.title } ?? "Invalid rating" }
		else { value = response.rating == nil ? response.status.title : "Invalid response" }
		return response.name + ": " + value
	}
}
private func stressReviewCell() -> UITableViewCell {
	let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
	cell.textLabel?.numberOfLines = 0; cell.detailTextLabel?.numberOfLines = 0
	cell.textLabel?.font = .preferredFont(forTextStyle: .body); cell.textLabel?.adjustsFontForContentSizeCategory = true
	cell.detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline); cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
	return cell
}

private final class StressReviewDetailViewController: UITableViewController {
	let stressorID: UUID
	private var item: StressReviewItem?
	private var entries: [StressReviewEntry]
	private var formatter: StressReviewFormatter
	private var asOf: Date
	private var loadError: String?
	let edit: (StressCheckIn) -> Void
	init(item: StressReviewItem, entries: [StressReviewEntry], formatter: StressReviewFormatter, asOf: Date, edit: @escaping (StressCheckIn) -> Void) {
		stressorID = item.id!; self.item = item; self.entries = entries; self.formatter = formatter; self.asOf = asOf; self.edit = edit
		super.init(style: .grouped)
			title = item.name
	}
	required init?(coder: NSCoder) { fatalError("Use init(item:entries:formatter:asOf:edit:)") }
	override func viewDidLoad() { super.viewDidLoad(); tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 100 }
	func update(item: StressReviewItem?, entries: [StressReviewEntry], formatter: StressReviewFormatter, asOf: Date, error: String? = nil) {
		self.item = item; self.entries = entries; self.formatter = formatter; self.asOf = asOf; loadError = error
		if let item = item { title = item.name }
		if isViewLoaded { tableView.reloadData() }
	}
	override func numberOfSections(in tableView: UITableView) -> Int { 2 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { section == 0 ? (item == nil ? 1 : item?.after == nil ? 2 : 3) : entries.count }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { section == 0 ? "Recorded stress" : "Check-ins" }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		section == 0 ? "Ordinal anchor summaries are descriptive. Missing or unoffered days are not zero. Changes do not establish a cause."
				: "Showing up to 200 of this stressor's newest check-ins across the selected period. Summary includes all offered responses, including older entries. Tap to edit the whole check-in."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = stressReviewCell()
		if indexPath.section == 0 {
			guard let item = item else {
				cell.textLabel?.text = loadError == nil ? "No matching responses" : "Stress review unavailable"
				cell.detailTextLabel?.text = loadError ?? "This stressor has no check-ins in the selected period."
				cell.selectionStyle = .none; return cell
			}
			cell.textLabel?.text = ["Summary", "Rating distribution", "Change in daily mean"][indexPath.row]
			cell.detailTextLabel?.text = indexPath.row == 0 ? formatter.summary(item, now: asOf) : indexPath.row == 1 ? formatter.distribution(item) : formatter.change(item)
			cell.selectionStyle = .none
		} else {
			let record = entries[indexPath.row].snapshot
			cell.textLabel?.text = formatter.entryTitle(record)
			let response = record.responses.first { $0.id == stressorID }.map { formatter.responseText($0) } ?? "Not offered"
			cell.detailTextLabel?.text = response + (record.note.map { "\n" + $0 } ?? "")
			cell.accessoryType = .disclosureIndicator
		}
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		if indexPath.section == 1 { edit(entries[indexPath.row].checkIn) }
	}
}

private final class StressAppointmentPreparationViewController: UITableViewController {
	let content: StressReviewContent
	let formatter: StressReviewFormatter
	init(content: StressReviewContent, formatter: StressReviewFormatter) { self.content = content; self.formatter = formatter; super.init(style: .grouped) }
	required init?(coder: NSCoder) { fatalError("Use init(content:formatter:)") }
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Appointment Prep"; tableView.accessibilityIdentifier = "stressAppointmentPreparation"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 110
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share))
	}
	override func numberOfSections(in tableView: UITableView) -> Int { 2 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { section == 0 ? 1 + content.stressors.count : content.recent.count }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { section == 0 ? "Discussion summary" : "Dates and notes" }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		section == 0 ? "Use this to choose what to discuss. These are self-reported ordinal ratings and descriptive patterns, not diagnoses or proof of a cause."
			: "Summaries include all \(content.recordCount) matching check-ins. The newest \(content.recent.count) entries and their notes are shown here and included if you explicitly tap Share. Nothing is sent automatically."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = stressReviewCell(); cell.selectionStyle = .none
		if indexPath.section == 0 {
			let item = indexPath.row == 0 ? content.overall : content.stressors[indexPath.row - 1]
			cell.textLabel?.text = item.name
			cell.detailTextLabel?.text = formatter.summary(item, now: content.asOf) + "\n\n" + formatter.distribution(item)
				+ (item.after == nil ? "" : "\n\n" + formatter.change(item))
		} else {
			let record = content.recent[indexPath.row]
			cell.textLabel?.text = formatter.entryTitle(record)
			cell.detailTextLabel?.text = (record.responses.map { formatter.responseText($0) } + [record.note?.isEmpty == false ? record.note! : "No note"]).joined(separator: "\n")
		}
		return cell
	}
	@objc private func share(_ sender: UIBarButtonItem) {
		var report = ["Stress check-in discussion summary", "Recorded through " + formatter.fullDate(content.asOf),
			"Self-reported right-now stress, 0 None to 4 Overwhelming. Descriptive ordinal ratings; missing answers are not zero and patterns do not establish a cause."]
		for item in [content.overall] + content.stressors {
			report.append(item.name + "\n" + formatter.summary(item, now: content.asOf) + "\n" + formatter.distribution(item)
				+ (item.after == nil ? "" : "\n" + formatter.change(item)))
		}
		report.append("Summaries include all \(content.recordCount) matching check-ins. Newest \(content.recent.count) entries follow:")
		for record in content.recent {
			report.append(formatter.entryTitle(record) + "\n" + record.responses.map { formatter.responseText($0) }.joined(separator: "\n") + (record.note.map { "\nNote: " + $0 } ?? ""))
		}
		let controller = UIActivityViewController(activityItems: [report.joined(separator: "\n\n")], applicationActivities: nil)
		controller.popoverPresentationController?.barButtonItem = sender
		present(controller, animated: true)
	}
}

private final class StressReviewDateViewController: UIViewController {
	private let picker = UIDatePicker()
	private let initial: Date
	private let now: Date
	private let calendar: Calendar
	private let accept: (Date) -> Void
	init(date: Date, now: Date, calendar: Calendar, accept: @escaping (Date) -> Void) {
		initial = date; self.now = now; self.calendar = calendar; self.accept = accept
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) { fatalError("Use init(date:now:calendar:accept:)") }
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Date of Change"; view.backgroundColor = .systemBackground
		picker.datePickerMode = .date; picker.preferredDatePickerStyle = .wheels
		picker.calendar = calendar; picker.timeZone = calendar.timeZone
		picker.maximumDate = now; picker.date = min(initial, now)
		picker.accessibilityIdentifier = "stressReviewChangeDatePicker"
		picker.translatesAutoresizingMaskIntoConstraints = false; view.addSubview(picker)
		NSLayoutConstraint.activate([picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor), picker.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
	}
	@objc private func done() { accept(calendar.startOfDay(for: picker.date)); navigationController?.popViewController(animated: true) }
}
