import UIKit
import Common
import Samples

/// A new check-in starts without answers. Historical edits retain their offered stressor snapshots.
final class StressCheckInViewController: UITableViewController, UITextViewDelegate {
	var onSave: ((StressCheckIn) -> Void)?
	var clock: () -> Date = { Date() }
	var guideDefaults: UserDefaults = .standard
	var loadStressors: () throws -> [StressStressorSnapshot] = {
		try StressTrackingStore.definitions().map { StressStressorSnapshot(id: $0.id, name: $0.name) }
	}
	var persistCheckIn: (StressCheckInDraft, StressCheckIn?) throws -> StressCheckIn = {
		try StressTrackingStore.save(draft: $0, editing: $1)
	}
	private(set) var draft: StressCheckInDraft
	private(set) var showsIntroduction = false
	private let checkIn: StressCheckIn?
	private var usesRecordedMoment = false
	private var definitionsLoaded = false
	private var loadError: String?
	private let note = UITextView()
	private let dates: DateFormatter = {
		let value = DateFormatter(); value.dateStyle = .medium; value.timeStyle = .medium
		value.locale = .autoupdatingCurrent; return value
	}()
	private static let guideKey = "stressCheckInIntroductionDismissed.v1"

	init(checkIn: StressCheckIn? = nil, now: Date = Date()) {
		self.checkIn = checkIn
		usesRecordedMoment = checkIn != nil
		draft = checkIn?.draft ?? StressCheckInDraft(date: now, overallRating: nil)
		super.init(style: .grouped)
		// The form edits values, not managed relationships. Refault clean records
		// after copying them so inverse parent/response links do not keep a cycle.
		if let checkIn = checkIn { StressTrackingStore.releaseSnapshots(of: [checkIn]) }
	}
	required init?(coder: NSCoder) { fatalError("Use init(checkIn:now:)") }
	deinit {
		if let checkIn = checkIn { StressTrackingStore.releaseSnapshots(of: [checkIn]) }
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = checkIn == nil ? "Stress Check-in" : "Edit Stress Check-in"
		tableView.accessibilityIdentifier = "stressCheckIn"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 72
		tableView.keyboardDismissMode = .onDrag
		navigationItem.rightBarButtonItems = [
			UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save)),
			UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(showGuide)),
		]
		navigationItem.rightBarButtonItems?.last?.accessibilityLabel = "Stress check-in guide"
		note.text = draft.note; note.delegate = self
		note.font = .preferredFont(forTextStyle: .body); note.adjustsFontForContentSizeCategory = true
		note.backgroundColor = .clear
		note.accessibilityLabel = "Stress check-in note"; note.accessibilityIdentifier = "stressCheckInNote"
		showsIntroduction = checkIn == nil && !guideDefaults.bool(forKey: Self.guideKey)
		if checkIn != nil { definitionsLoaded = true }
		else {
			refreshControl = UIRefreshControl()
			refreshControl?.addTarget(self, action: #selector(retryLoad), for: .valueChanged)
		}
		refreshSaveState()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		dates.timeZone = .current; dates.calendar = .current
		if checkIn == nil { reloadStressors() }
	}

	/// Refresh configuration without carrying answers from a previous saved check-in.
	func reloadStressors() {
		do {
			let active = try loadStressors()
			var answers: [UUID: StressResponseDraft] = [:]
			for response in draft.responses { answers[response.stressorID] = response }
			draft.responses = active.enumerated().map { index, definition in
				var answer = answers[definition.id] ?? StressResponseDraft(stressorID: definition.id, nameSnapshot: definition.name)
				answer.nameSnapshot = definition.name; answer.order = index
				return answer
			}
			definitionsLoaded = true; loadError = nil
		} catch {
			definitionsLoaded = false
			loadError = "Could not load your stressors. Pull to refresh to try again. Your draft has not been saved."
		}
		refreshSaveState(); tableView.reloadData()
		refreshControl?.endRefreshing()
	}

	func setOverallRating(_ rating: Int?) {
		draft.overallRating = rating; refreshSaveState()
		if isViewLoaded { tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none) }
	}
	func setResponse(at index: Int, status: StressResponseStatus, rating: Int?) {
		guard draft.responses.indices.contains(index) else { return }
		draft.responses[index].status = status; draft.responses[index].rating = rating
		refreshSaveState()
		if isViewLoaded { tableView.reloadRows(at: [IndexPath(row: index, section: 2)], with: .none) }
	}
	func textViewDidChange(_ textView: UITextView) {
		draft.note = textView.text; refreshSaveState()
	}
	private func refreshSaveState() {
		let valid = (try? draft.validate()) != nil
		navigationItem.rightBarButtonItems?.first?.isEnabled = definitionsLoaded && valid
	}
	@objc func save() {
		guard definitionsLoaded else { return }
		view.endEditing(true)
		do {
			try draft.validate()
			let saved = try persistCheckIn(draft, checkIn)
			onSave?(saved)
			navigationController?.popViewController(animated: true)
		} catch { showError(title: "Could not save stress check-in", error: error) }
	}
	@objc func useNow() {
		draft.date = clock()
		usesRecordedMoment = false
		refreshSaveState()
		if isViewLoaded { tableView.reloadData() }
	}
	func setManualDate(_ date: Date, calendar: Calendar = .current) {
		// Preserve the estimated-time signal used by accuracy/forgetfulness analysis;
		// automatic and Now timestamps stay precise. See docs/timestamp-precision.md.
		guard date.timeIntervalSinceReferenceDate.isFinite,
			let minute = calendar.dateInterval(of: .minute, for: date)?.start else { return }
		draft.date = minute
		usesRecordedMoment = true
		refreshSaveState()
		if isViewLoaded { tableView.reloadData() }
	}
	@objc func dismissIntroduction() {
		guideDefaults.set(true, forKey: Self.guideKey); showsIntroduction = false
		tableView.reloadSections(IndexSet(integer: 0), with: .none)
	}
	@objc private func showGuide() { navigationController?.pushViewController(StressGuideViewController(style: .grouped), animated: true) }
	@objc private func retryLoad() { reloadStressors() }

	override func numberOfSections(in tableView: UITableView) -> Int { 5 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0: return showsIntroduction ? 1 : 0
		case 1, 4: return 1
		case 2: return draft.responses.count + (checkIn == nil ? 1 : 0)
		default: return 2
		}
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		[showsIntroduction ? "What can this help with?" : nil,
			usesRecordedMoment ? "Overall stress at this check-in" : "Overall stress right now",
			usesRecordedMoment ? "Personal stressors at this check-in" : "Personal stressors right now", "Time", "Optional note"][section]
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		switch section {
		case 1: return "Choose your overall stress from None to Overwhelming. An answer is required to save."
		case 2:
			if let error = loadError { return error }
			return checkIn == nil
				? "Overall stress works on its own. You decide how many personal stressors to include; starting with a few, such as one to three, can keep check-ins manageable. Unanswered items are saved as Skipped, never as None."
				: "These are the stressors offered when this check-in was recorded, with their names at that time. Editing your current list does not change this history."
		case 3: return "Automatic times and Now retain full precision. Choosing a time manually clears seconds and fractions."
		case 4: return "Add context that may help you evaluate a change or prepare for an appointment. Notes and ratings stay on your device unless you choose to export them."
		default: return nil
		}
	}
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		indexPath.section == 4 ? 150 : UITableView.automaticDimension
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.textLabel?.numberOfLines = 0; cell.detailTextLabel?.numberOfLines = 0
		cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.textLabel?.adjustsFontForContentSizeCategory = true
		cell.detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline)
		cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
		switch indexPath.section {
		case 0:
			cell.textLabel?.text = "Evaluate changes and prepare for appointments"
			cell.detailTextLabel?.text = "Record before and after a change, then review the dates, pressures and notes you want to discuss. Overall stress is enough; personal stressors are optional. The guide has examples."
			let dismiss = UIButton(type: .system); dismiss.setTitle("Got it", for: .normal)
			dismiss.titleLabel?.font = .preferredFont(forTextStyle: .body)
			dismiss.accessibilityLabel = "Dismiss stress check-in introduction"
			dismiss.frame = CGRect(x: 0, y: 0, width: 64, height: 44)
			dismiss.addTarget(self, action: #selector(dismissIntroduction), for: .touchUpInside)
			cell.accessoryView = dismiss; cell.selectionStyle = .none
		case 1:
			cell.textLabel?.text = usesRecordedMoment ? "How much stress were you feeling at this check-in?" : "How much stress are you feeling right now?"
			cell.detailTextLabel?.text = draft.overallRating.flatMap { StressRating(rawValue: $0)?.title } ?? "Choose a rating"
			cell.accessibilityIdentifier = "stressOverallRating"; cell.accessoryType = .disclosureIndicator
		case 2:
			if draft.responses.indices.contains(indexPath.row) {
				let answer = draft.responses[indexPath.row]
				cell.textLabel?.text = answer.nameSnapshot
				cell.detailTextLabel?.text = answer.status == .rated ? answer.rating.flatMap { StressRating(rawValue: $0)?.title } ?? "Invalid rating" : answer.status.title
				cell.accessibilityIdentifier = "stressResponse.\(answer.stressorID.uuidString)"
				cell.accessoryType = .disclosureIndicator
			} else {
				cell.textLabel?.text = "Manage personal stressors"; cell.accessoryType = .disclosureIndicator
				cell.accessibilityIdentifier = "stressManageStressors"
			}
		case 3:
			cell.textLabel?.text = indexPath.row == 0 ? (draft.date.timeIntervalSinceReferenceDate.isFinite ? dates.string(from: draft.date) : "Invalid time") : "Now"
			cell.accessibilityIdentifier = indexPath.row == 0 ? "stressTimestamp" : "stressTimestampNow"
			if indexPath.row == 0 { cell.accessoryType = .disclosureIndicator }
		default:
			cell.selectionStyle = .none
			note.translatesAutoresizingMaskIntoConstraints = false
			cell.contentView.addSubview(note)
			NSLayoutConstraint.activate([note.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor),
				note.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor),
				note.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
				note.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)])
		}
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		switch indexPath.section {
		case 1:
			let picker = StressRatingChoiceViewController(name: "Overall stress", status: draft.overallRating == nil ? .skipped : .rated,
				rating: draft.overallRating, personal: false, recordedMoment: usesRecordedMoment) { [weak self] _, rating in self?.setOverallRating(rating) }
			navigationController?.pushViewController(picker, animated: true)
		case 2:
			guard draft.responses.indices.contains(indexPath.row) else {
				navigationController?.pushViewController(StressorsViewController(style: .grouped), animated: true); return
			}
			let response = draft.responses[indexPath.row]
			let picker = StressRatingChoiceViewController(name: response.nameSnapshot, status: response.status,
				rating: response.rating, personal: true, recordedMoment: usesRecordedMoment) { [weak self] status, rating in
					guard let self = self, let index = self.draft.responses.firstIndex(where: { $0.stressorID == response.stressorID }) else { return }
					self.setResponse(at: index, status: status, rating: rating)
				}
			navigationController?.pushViewController(picker, animated: true)
		case 3:
			if indexPath.row == 1 { useNow() }
			else {
				let picker = StressTimestampViewController(date: draft.date) { [weak self] in self?.setManualDate($0) }
				navigationController?.pushViewController(picker, animated: true)
			}
		default: break
		}
	}
}

private final class StressRatingChoiceViewController: UITableViewController {
	private let name: String
	private let status: StressResponseStatus
	private let rating: Int?
	private let personal: Bool
	private let recordedMoment: Bool
	private let accept: (StressResponseStatus, Int?) -> Void
	init(name: String, status: StressResponseStatus, rating: Int?, personal: Bool, recordedMoment: Bool, accept: @escaping (StressResponseStatus, Int?) -> Void) {
		self.name = name; self.status = status; self.rating = rating; self.personal = personal; self.recordedMoment = recordedMoment; self.accept = accept
		super.init(style: .grouped)
	}
	required init?(coder: NSCoder) { fatalError("Use init(name:status:rating:personal:accept:)") }
	override func viewDidLoad() { super.viewDidLoad(); title = name; tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 48 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { personal ? 7 : 6 }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if recordedMoment { return personal ? "How much stress was this causing you at this check-in?" : "How much stress were you feeling at this check-in?" }
		return personal ? "How much stress is this causing you right now?" : "How much stress are you feeling right now?"
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		personal ? "None is an explicit zero rating. Not applicable and Skipped do not contribute a rating to averages." : "Choose one anchor consistently. This is your own description of stress, not a clinical score."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		cell.textLabel?.numberOfLines = 0; cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.textLabel?.adjustsFontForContentSizeCategory = true
		let selected: Bool
		if let value = StressRating(rawValue: indexPath.row) {
			cell.textLabel?.text = "\(value.rawValue) — \(value.title)"
			selected = status == .rated && rating == value.rawValue
		} else if personal && indexPath.row == 5 {
			cell.textLabel?.text = "Not applicable"; selected = status == .notApplicable
		} else {
			cell.textLabel?.text = personal ? "Skip this stressor" : "Clear rating"
			selected = status == .skipped
		}
		cell.accessoryType = selected ? .checkmark : .none
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let value = StressRating(rawValue: indexPath.row) { accept(.rated, value.rawValue) }
		else if personal && indexPath.row == 5 { accept(.notApplicable, nil) }
		else { accept(.skipped, nil) }
		navigationController?.popViewController(animated: true)
	}
}

private final class StressTimestampViewController: UIViewController {
	private let picker = UIDatePicker()
	private let date: Date
	private var changed = false
	private let accept: (Date) -> Void
	init(date: Date, accept: @escaping (Date) -> Void) { self.date = date; self.accept = accept; super.init(nibName: nil, bundle: nil) }
	required init?(coder: NSCoder) { fatalError("Use init(date:accept:)") }
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Check-in Time"; view.backgroundColor = .systemBackground
		picker.datePickerMode = .dateAndTime; picker.preferredDatePickerStyle = .wheels; picker.date = date
		picker.accessibilityLabel = "Stress check-in time"; picker.accessibilityIdentifier = "stressTimestampPicker"
		picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
		picker.translatesAutoresizingMaskIntoConstraints = false; view.addSubview(picker)
		NSLayoutConstraint.activate([picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor), picker.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
	}
	@objc private func dateChanged() { changed = true }
	@objc private func done() {
		if changed { accept(picker.date) }
		navigationController?.popViewController(animated: true)
	}
}
