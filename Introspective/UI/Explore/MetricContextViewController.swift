import UIKit
import Common
import DependencyInjection
import Persistence
import Samples
import UIExtensions

final class MetricContextViewController: UITableViewController {
	private let metric: ContextMetric
	private let interval: DateInterval?
	private let tracksPresent: Bool
	private let scope = UISegmentedControl(items: ["Selected period", "All time"])
	private var entries: [MetricContextEntry] = []
	private var total = 0
	init(metric: ContextMetric = .all, interval: DateInterval? = nil, tracksPresent: Bool = false) {
		self.metric = metric; self.interval = interval; self.tracksPresent = tracksPresent
		super.init(style: .grouped)
	}
	required init?(coder: NSCoder) { fatalError("Use init(metric:interval:)") }
	override func viewDidLoad() {
		super.viewDidLoad()
		title = metric == .all ? "Metric Context" : "\(metric.title) Context"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEntry))
		scope.selectedSegmentIndex = interval == nil ? 1 : 0
		scope.accessibilityIdentifier = "context period"
		scope.isEnabled = interval != nil
		scope.addTarget(self, action: #selector(reload), for: .valueChanged)
		scope.frame = CGRect(x: 16, y: 8, width: view.bounds.width - 32, height: 36)
		let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 52))
		header.addSubview(scope); tableView.tableHeaderView = header
	}
	override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); reload() }
	@objc private func reload() {
		do {
			let selected = scope.selectedSegmentIndex == 0 ? interval.map {
				tracksPresent ? DateInterval(start: $0.start, end: max($0.start, Date())) : $0
			} : nil
			let request = MetricContextEntry.request(metric: metric, interval: selected)
			total = try injected(Database.self).count(request)
			request.fetchLimit = 200
			entries = try injected(Database.self).query(request)
			tableView.reloadData()
		} catch { showError(title: "Could not load context", error: error) }
	}
	@objc private func addEntry() { navigationController?.pushViewController(MetricContextEditor(metric: metric), animated: true) }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { entries.count }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { "Dated context · \(total) entries" }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		metric.limitations + " Add dated context such as illness, travel, or device use. Tap to edit; swipe to delete. Showing up to 200 recent entries. All time includes entries outside the selected period."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "context") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "context")
		let entry = entries[indexPath.row]
		cell.textLabel?.text = entry.category + (entry.note.flatMap { $0.isEmpty ? nil : " · " + $0 } ?? "")
		cell.textLabel?.numberOfLines = 0; cell.detailTextLabel?.numberOfLines = 0
		var date = injected(CalendarUtil.self).string(for: entry.timestamp, dateStyle: .medium, timeStyle: .short)
		if let end = entry.endDate { date += " – " + injected(CalendarUtil.self).string(for: end, dateStyle: .medium, timeStyle: .short) }
		cell.detailTextLabel?.text = entry.metric.title + " · " + date
		cell.accessoryType = .disclosureIndicator
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		navigationController?.pushViewController(MetricContextEditor(entry: entries[indexPath.row], metric: metric), animated: true)
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		let entry = entries[indexPath.row]
		let alert = UIAlertController(title: "Delete this context entry?", message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self, weak alert] _ in
			alert?.dismiss(animated: false) { [weak self] in
				guard let self = self else { return }
				do {
					try entry.delete(); self.reload()
				} catch { self.showError(title: "Could not delete context", error: error) }
			}
		})
		present(alert, animated: true)
	}
}

final class MetricContextEditor: UITableViewController {
	var onSave: ((MetricContextEntry) -> Void)?
	private let entry: MetricContextEntry?
	private var category: ContextCategory
	private var metric: ContextMetric
	let startPicker = UIDatePicker()
	let endPicker = UIDatePicker()
	let includeEnd = UISwitch()
	private let note = UITextView()
	private var start: Date
	private var end: Date?
	// Keep the logical value outside UIDatePicker, which can round displayed dates.
	private var draftEnd: Date
	init(entry: MetricContextEntry? = nil, metric: ContextMetric) {
		self.entry = entry; self.metric = entry?.metric ?? metric
		category = entry.flatMap { ContextCategory(rawValue: $0.category) } ?? .other
		let initialStart = entry?.timestamp ?? Date()
		start = initialStart; end = entry?.endDate
		draftEnd = entry?.endDate ?? initialStart
		super.init(style: .grouped)
	}
	required init?(coder: NSCoder) { fatalError("Use init(entry:metric:)") }
	override func viewDidLoad() {
		super.viewDidLoad()
		title = entry == nil ? "Add Context" : "Edit Context"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
		for picker in [startPicker, endPicker] {
			picker.datePickerMode = .dateAndTime
			if #available(iOS 13.4, *) { picker.preferredDatePickerStyle = .wheels }
		}
		startPicker.date = start; endPicker.date = draftEnd
		startPicker.addTarget(self, action: #selector(startChanged), for: .valueChanged)
		endPicker.addTarget(self, action: #selector(endChanged), for: .valueChanged)
		includeEnd.isOn = end != nil
		includeEnd.addTarget(self, action: #selector(toggleEnd), for: .valueChanged)
		note.text = entry?.note; note.font = .preferredFont(forTextStyle: .body)
		note.accessibilityIdentifier = "context note"
		note.accessibilityLabel = "Context note"
		startPicker.accessibilityIdentifier = "context start"
		endPicker.accessibilityIdentifier = "context end"
		includeEnd.accessibilityIdentifier = "context includes end"
		tableView.keyboardDismissMode = .onDrag
		hideKeyboardOnTapNonTextInput()
	}
	@objc func startChanged() {
		start = injected(CalendarUtil.self).start(of: .minute, in: startPicker.date)
		startPicker.date = start
	}
	@objc func endChanged() {
		draftEnd = injected(CalendarUtil.self).start(of: .minute, in: endPicker.date)
		end = includeEnd.isOn ? draftEnd : nil
		endPicker.date = draftEnd
	}
	@objc func toggleEnd() {
		if includeEnd.isOn {
			draftEnd = max(start, draftEnd)
			end = draftEnd
			endPicker.date = draftEnd
		} else {
			end = nil
		}
		tableView.reloadSections(IndexSet(integer: 2), with: .none)
	}
	@objc func now() { start = Date(); startPicker.date = start }
	@objc func save() {
		guard end == nil || end! >= start else { showError(title: "The end must be after the start."); return }
		do {
			let saved: MetricContextEntry
			if let entry = entry {
				saved = try entry.update(category: category, metric: metric, at: start, until: end, note: note.text)
			} else { saved = try MetricContextEntry.record(category: category, metric: metric, at: start, until: end, note: note.text) }
			onSave?(saved)
			navigationController?.popViewController(animated: true)
		} catch { showError(title: "Could not save context", error: error) }
	}
	override func numberOfSections(in tableView: UITableView) -> Int { 4 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section { case 0: return ContextCategory.allCases.count; case 1: return ContextMetric.allCases.count; case 2: return includeEnd.isOn ? 4 : 3; default: return 1 }
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { ["Context", "Applies to", "Time", "Note"][section] }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == 1 { return metric.limitations }
		if section == 2 { return "Leave the end off to mark a single moment. Add an end to record a period." }
		return nil
	}
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 3 { return 150 }
		if indexPath.section == 2 && [1, 3].contains(indexPath.row) { return 180 }
		return UITableView.automaticDimension
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		if indexPath.section == 0 {
			let value = ContextCategory.allCases[indexPath.row]
			cell.textLabel?.text = value.rawValue; cell.accessoryType = category == value ? .checkmark : .none
		} else if indexPath.section == 1 {
			let value = ContextMetric.allCases[indexPath.row]
			cell.textLabel?.text = value.title; cell.accessoryType = metric == value ? .checkmark : .none
		} else if indexPath.section == 2 && indexPath.row == 0 {
			cell.textLabel?.text = "Start"
			let button = UIButton(type: .system); button.setTitle("Now", for: .normal); button.sizeToFit()
			button.addTarget(self, action: #selector(now), for: .touchUpInside); cell.accessoryView = button
		} else if indexPath.section == 2 && indexPath.row == 2 {
			cell.textLabel?.text = "Include end"; cell.accessoryView = includeEnd
		} else {
			let control: UIView = indexPath.section == 3 ? note : (indexPath.row == 1 ? startPicker : endPicker)
			control.translatesAutoresizingMaskIntoConstraints = false; cell.contentView.addSubview(control)
			NSLayoutConstraint.activate([control.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 12), control.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -12), control.topAnchor.constraint(equalTo: cell.contentView.topAnchor), control.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)])
		}
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		if indexPath.section == 0 { category = ContextCategory.allCases[indexPath.row] }
		else if indexPath.section == 1 { metric = ContextMetric.allCases[indexPath.row] }
		else { return }
		tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
	}
}
