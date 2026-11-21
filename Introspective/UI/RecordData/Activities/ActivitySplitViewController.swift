import UIKit

import Common
import DependencyInjection
import Samples
import UIExtensions

/// Preview both segments before changing the saved record. The outer bounds
/// remain the original stored instants; only the split boundary is editable.
final class ActivitySplitViewController: UITableViewController {
	private let snapshot: ActivitySplitSnapshot
	private let saved: (ActivityRecordingResult) -> Void
	private var splitTime: Date
	private var secondDefinition: ActivityRecordingDefinition
	private var saving = false
	private lazy var dateSelection = ActivityReviewDateSelection(owner: self)

	init(snapshot: ActivitySplitSnapshot, saved: @escaping (ActivityRecordingResult) -> Void) {
		self.snapshot = snapshot; self.saved = saved
		let upper = snapshot.end ?? Date()
		let midpoint = snapshot.start.addingTimeInterval(upper.timeIntervalSince(snapshot.start) / 2)
		let minute = Calendar.autoupdatingCurrent.dateInterval(of: .minute, for: midpoint)?.start ?? midpoint
		// Estimate whole minutes when possible, while still allowing very short records.
		splitTime = minute > snapshot.start && minute < upper ? minute : midpoint
		secondDefinition = ActivityRecordingDefinition(id: snapshot.definitionID, name: snapshot.name)
		super.init(style: .insetGrouped)
	}
	required init?(coder: NSCoder) { fatalError("Use init(snapshot:saved:)") }

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Split Activity"
		tableView.accessibilityIdentifier = "activitySplitEditor"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 68
		let save = UIBarButtonItem(title: "Split", style: .done, target: self, action: #selector(saveSplit))
		save.accessibilityIdentifier = "saveActivitySplit"
		navigationItem.rightBarButtonItem = save
		updateSave()
	}

	override func numberOfSections(in tableView: UITableView) -> Int { 2 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 2 }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		section == 0 ? "First part" : "Second part"
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		section == 0 ? "Choose the time when the first activity ended and the second began." :
			"Both parts keep the original notes and tags. Other activity records keep their own times. Nothing changes until you tap Split."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		let isFirst = indexPath.section == 0
		let isActivity = indexPath.row == 0
		cell.textLabel?.text = isActivity ? (isFirst ? snapshot.name : secondDefinition.name) :
			(isFirst ? "Split time" : "Original end")
		if isActivity {
			cell.detailTextLabel?.text = isFirst ? "Starts \(display(snapshot.start))" : "Starts at the split time"
		} else {
			cell.detailTextLabel?.text = isFirst ? display(splitTime) : snapshot.end.map(display) ?? "Still running"
		}
		let editable = isFirst != isActivity
		cell.accessoryType = editable ? .disclosureIndicator : .none
		cell.selectionStyle = editable ? .default : .none
		cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.detailTextLabel?.font = .preferredFont(forTextStyle: .caption1)
		for label in [cell.textLabel, cell.detailTextLabel] {
			label?.numberOfLines = 0; label?.adjustsFontForContentSizeCategory = true
		}
		cell.accessibilityIdentifier = isFirst ? (isActivity ? "activitySplitFirst" : "activitySplitTime") :
			(isActivity ? "activitySplitDefinition" : "activitySplitEnd")
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		guard !saving else { return }
		if indexPath.section == 0, indexPath.row == 1 {
			chooseTime(source: tableView.cellForRow(at: indexPath))
		} else if indexPath.section == 1, indexPath.row == 0 {
			do {
				let definitions = try ActivityQuickRecorder.snapshot().definitions
				let chooser = ActivitySplitDefinitionChooser(definitions: definitions, selectedID: secondDefinition.id) { [weak self] definition in
					self?.secondDefinition = definition; self?.tableView.reloadData(); self?.updateSave()
				}
				navigationController?.pushViewController(chooser, animated: true)
			} catch { showError(title: "Could not load activities", error: error) }
		}
	}

	private func display(_ date: Date) -> String {
		injected(CalendarUtil.self).string(for: date, dateStyle: .medium, timeStyle: .medium)
	}
	private func isInterior(_ date: Date, now: Date = Date()) -> Bool {
		date > snapshot.start && date < (snapshot.end ?? now) && date <= now
	}
	private func updateSave() { navigationItem.rightBarButtonItem?.isEnabled = !saving && isInterior(splitTime) }
	private func chooseTime(source: UIView?) {
		let now = Date()
		let sheet = UIAlertController(title: "Split time", message: "Both parts meet at this time.", preferredStyle: .actionSheet)
		for minutes in [5, 15, 30] {
			let date = try? ActivityBackdate.date(value: minutes, unit: .minute, now: now)
			let action = UIAlertAction(title: "\(minutes) minutes ago", style: .default) { [weak self] _ in
				guard let self = self, let date = date else { return }
				self.splitTime = date; self.tableView.reloadData(); self.updateSave()
			}
			action.isEnabled = date.map { isInterior($0, now: now) } ?? false
			sheet.addAction(action)
		}
		sheet.addAction(UIAlertAction(title: "Choose time…", style: .default) { [weak self] _ in
			guard let self = self else { return }
			self.dateSelection.present(initial: self.splitTime, minimum: self.snapshot.start,
				maximum: min(self.snapshot.end ?? now, now)) { [weak self] date in
				self?.splitTime = date; self?.tableView.reloadData(); self?.updateSave()
			}
		})
		sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		if let popover = sheet.popoverPresentationController {
			popover.sourceView = source ?? tableView; popover.sourceRect = source?.bounds ?? tableView.bounds
		}
		present(sheet, animated: false)
	}
	@objc private func saveSplit() {
		guard !saving, isInterior(splitTime) else { return }
		saving = true; updateSave()
		do {
			let result = try ActivitySplitService.split(snapshot, at: splitTime, secondDefinitionID: secondDefinition.id, recordedAt: Date())
			ActivityRecordingUndoSession.shared.clear()
			saved(result)
		} catch {
			saving = false; updateSave()
			showError(title: "Could not split activity", error: error)
		}
	}
}

private final class ActivitySplitDefinitionChooser: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
	private let definitions: [ActivityRecordingDefinition]
	private var shown: [ActivityRecordingDefinition]
	private let selectedID: String
	private let choose: (ActivityRecordingDefinition) -> Void
	private let search = UISearchController(searchResultsController: nil)
	private var pendingSelection: ActivityRecordingDefinition?
	private var selecting = false
	init(definitions: [ActivityRecordingDefinition], selectedID: String, choose: @escaping (ActivityRecordingDefinition) -> Void) {
		self.definitions = definitions; shown = definitions; self.selectedID = selectedID; self.choose = choose
		super.init(style: .insetGrouped)
	}
	required init?(coder: NSCoder) { fatalError("Use init(definitions:selectedID:choose:)") }
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Choose Activity"; tableView.accessibilityIdentifier = "activitySplitDefinitions"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 44
		search.searchResultsUpdater = self; search.delegate = self; search.obscuresBackgroundDuringPresentation = false
		navigationItem.searchController = search; definesPresentationContext = true
	}
	func updateSearchResults(for searchController: UISearchController) {
		let query = (searchController.searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
		shown = query.isEmpty ? definitions : definitions.filter { $0.name.localizedCaseInsensitiveContains(query) }
		tableView.reloadData()
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { shown.count }
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let definition = shown[indexPath.row]
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		cell.textLabel?.text = definition.name; cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.textLabel?.numberOfLines = 0; cell.textLabel?.adjustsFontForContentSizeCategory = true
		cell.accessoryType = definition.id == selectedID ? .checkmark : .none
		cell.accessibilityIdentifier = "activitySplitChoice.\(definition.id)"
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard !selecting else { return }
		selecting = true
		let selected = shown[indexPath.row]
		if search.isActive { pendingSelection = selected; search.isActive = false }
		else { finish(selected) }
	}
	func didDismissSearchController(_ searchController: UISearchController) {
		guard searchController === search, let selected = pendingSelection else { return }
		pendingSelection = nil; finish(selected)
	}
	private func finish(_ selected: ActivityRecordingDefinition) {
		guard let navigation = navigationController, navigation.topViewController === self else { return }
		navigation.popViewController(animated: false); choose(selected)
	}
}
