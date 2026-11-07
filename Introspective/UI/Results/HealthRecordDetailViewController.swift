import UIKit
import HealthKit
import Samples
import UIExtensions

final class HealthResultSummaryCell: UITableViewCell {
	private let dates: DateFormatter = {
		let value = DateFormatter(); value.dateStyle = .medium; value.timeStyle = .short
		value.locale = .autoupdatingCurrent; value.timeZone = .autoupdatingCurrent
		return value
	}()
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.font = .preferredFont(forTextStyle: .body)
		textLabel?.adjustsFontForContentSizeCategory = true; textLabel?.numberOfLines = 0
		detailTextLabel?.font = .preferredFont(forTextStyle: .caption1)
		detailTextLabel?.adjustsFontForContentSizeCategory = true; detailTextLabel?.numberOfLines = 3
		accessoryType = .disclosureIndicator
	}
	required init?(coder: NSCoder) { fatalError("Use init(style:reuseIdentifier:)") }
	static func make(in tableView: UITableView, sample: HealthKitSample) -> UITableViewCell {
		let identifier = "healthCatalogResult"
		let cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? HealthResultSummaryCell)
			?? HealthResultSummaryCell(style: .subtitle, reuseIdentifier: identifier)
		cell.textLabel?.text = type(of: sample).name
		var detail = sample.description
		if let start = sample.originalHealthSample?.startDate ?? sample.dates()[.start] {
			detail += "\n" + cell.dates.string(from: start)
		}
		cell.detailTextLabel?.text = detail
		return cell
	}
}

/// Inspects the immutable record returned by Health. It deliberately has no
/// recording, edit, or delete action.
final class HealthRecordDetailViewController: UITableViewController {
	let record: HKSample
	private var sections: [HealthRecordSection]
	private let seriesReader = HealthSpecializedSeriesReader()
	private lazy var documentReader = HealthDocumentContentReader()
	private var cancelSeries: (() -> Void)?
	private var generation = UUID()

	init(sample: HealthKitSample) {
		let original = sample.originalHealthSample ?? sample.hkSample()
		record = original
		sections = HealthRecordDetails.sections(for: sample)
		super.init(style: .insetGrouped)
		title = type(of: sample).name
	}

	init(record: HKSample, title: String) {
		self.record = record
		sections = HealthRecordDetails.sections(for: record)
		super.init(style: .insetGrouped)
		self.title = title
	}

	required init?(coder: NSCoder) { fatalError("Use init(sample:)") }
	deinit { cancelSeries?() }

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.accessibilityIdentifier = "healthRecordDetails"
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 75
		var actions = [UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareRecord))]
		var related: [UIAction] = [UIAction(title: "Attachments", image: UIImage(systemName: "paperclip")) { [weak self] _ in
			guard let self = self else { return }
			self.navigationController?.pushViewController(HealthRecordAttachmentsViewController(record: self.record), animated: true)
		}]
		if record is HKCDADocumentSample {
			related.append(UIAction(title: "Read original document", image: UIImage(systemName: "doc.text")) { [weak self] _ in self?.readDocument() })
		}
		if let workout = record as? HKWorkout {
			related.append(UIAction(title: "Workout routes", image: UIImage(systemName: "point.topleft.down.curvedto.point.bottomright.up")) { [weak self] _ in
				self?.navigationController?.pushViewController(HealthWorkoutRoutesViewController(workout: workout), animated: true)
			})
		}
		let more = UIBarButtonItem(title: "More", image: nil, primaryAction: nil, menu: UIMenu(children: related))
		more.accessibilityIdentifier = "healthRecordRelatedData"
		actions.append(more)
		if record is HKElectrocardiogram || record is HKWorkoutRoute || record is HKHeartbeatSeriesSample
			|| (record as? HKQuantitySample).map({ $0.count > 1 }) == true {
			let measurements = UIBarButtonItem(title: "Measurements", style: .plain,
				target: self, action: #selector(showMeasurements))
			measurements.accessibilityIdentifier = "healthRecordMeasurements"
			actions.append(measurements)
		}
		navigationItem.rightBarButtonItems = actions
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if isMovingFromParent || isBeingDismissed || navigationController?.isBeingDismissed == true {
			generation = UUID(); cancelSeries?(); cancelSeries = nil
		}
	}

	override func numberOfSections(in tableView: UITableView) -> Int { sections.count }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		sections[section].fields.count
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		sections[section].title
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		section == sections.count - 1 ? "These values come from the original Health record. Make changes in Health or the app that recorded it." : nil
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let field = sections[indexPath.section].fields[indexPath.row]
		return HealthDetailFieldCell.make(in: tableView, field: field)
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		let field = sections[indexPath.section].fields[indexPath.row]
		navigationController?.pushViewController(HealthFieldTextViewController(field: field), animated: true)
	}

	@objc private func showMeasurements() {
		cancelSeries?()
		let token = UUID(); generation = token
		navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = false }
		navigationItem.prompt = "Reading recorded measurements…"
		cancelSeries = seriesReader.read(sample: record) { [weak self] result in
			DispatchQueue.main.async {
				guard let self = self, self.generation == token else { return }
				self.cancelSeries = nil
				self.navigationItem.prompt = nil
				self.navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = true }
				switch result {
				case let .success(series):
					self.navigationController?.pushViewController(HealthSeriesViewController(series: series, source: self.record), animated: true)
				case let .failure(error): self.showError(title: "Could not read measurements", error: error)
				}
			}
		}
	}

	private func readDocument() {
		guard let document = record as? HKCDADocumentSample else { return }
		cancelSeries?(); let token = UUID(); generation = token
		navigationItem.prompt = "Reading original document…"
		navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = false }
		cancelSeries = documentReader.read(document: document) { [weak self] result in
			DispatchQueue.main.async {
				guard let self = self, self.generation == token else { return }
				self.cancelSeries = nil; self.navigationItem.prompt = nil
				self.navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = true }
				switch result {
				case .success(let value):
					self.sections = HealthRecordDetails.sections(for: value); self.tableView.reloadData()
				case .failure(let error): self.showError(title: "Could not read document", error: error)
				}
			}
		}
	}

	@objc private func shareRecord(_ sender: UIBarButtonItem) {
		HealthRecordSharing.present(title: title ?? "Health record", sections: sections, from: self, anchor: sender)
	}
}

final class HealthDetailFieldCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.font = .preferredFont(forTextStyle: .headline)
		textLabel?.adjustsFontForContentSizeCategory = true
		textLabel?.numberOfLines = 0
		detailTextLabel?.font = .preferredFont(forTextStyle: .body)
		detailTextLabel?.adjustsFontForContentSizeCategory = true
		detailTextLabel?.numberOfLines = 4
		accessoryType = .disclosureIndicator
	}
	required init?(coder: NSCoder) { fatalError("Use init(style:reuseIdentifier:)") }
	static func make(in tableView: UITableView, field: HealthRecordField) -> UITableViewCell {
		let identifier = "healthRecordField"
		let cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? HealthDetailFieldCell)
			?? HealthDetailFieldCell(style: .subtitle, reuseIdentifier: identifier)
		cell.textLabel?.text = field.name
		// Large FHIR/CDA payloads are opened on demand, rather than laid out in
		// their entirety in every scrolling table row.
		cell.detailTextLabel?.text = String(field.value.prefix(1_000))
		return cell
	}
}

final class HealthFieldTextViewController: UIViewController {
	let field: HealthRecordField
	init(field: HealthRecordField) { self.field = field; super.init(nibName: nil, bundle: nil); title = field.name }
	required init?(coder: NSCoder) { fatalError("Use init(field:)") }
	override func loadView() {
		let text = UITextView()
		text.isEditable = false; text.isSelectable = true
		text.font = .preferredFont(forTextStyle: .body)
		text.adjustsFontForContentSizeCategory = true
		text.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
		text.text = field.value
		text.accessibilityIdentifier = "healthRecordFieldText"
		view = text
	}
}

enum HealthRecordSharing {
	static func data(title: String, sections: [HealthRecordSection]) throws -> Data {
		let object: [String: Any] = ["title": title, "sections": sections.map { section in
			["title": section.title, "fields": section.fields.map { ["name": $0.name, "value": $0.value] }]
		}]
		return try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys])
	}
	static func present(title: String, sections: [HealthRecordSection], from controller: UIViewController,
		anchor: UIBarButtonItem) {
		guard controller.presentedViewController == nil, controller.viewIfLoaded?.window != nil else { return }
		let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
		do {
			try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
			let file = directory.appendingPathComponent("Health-record.json")
			try data(title: title, sections: sections).write(to: file, options: .atomic)
			let share = UIActivityViewController(activityItems: [file], applicationActivities: nil)
			share.popoverPresentationController?.barButtonItem = anchor
			share.completionWithItemsHandler = { _, _, _, _ in try? FileManager.default.removeItem(at: directory) }
			controller.present(share, animated: true)
		} catch {
			try? FileManager.default.removeItem(at: directory)
			controller.showError(title: "Could not prepare Health record", error: error)
		}
	}
}

final class HealthSeriesViewController: UITableViewController {
	let series: HealthSeriesSnapshot
	let source: HKSample?
	init(series: HealthSeriesSnapshot, source: HKSample? = nil) {
		self.series = series; self.source = source; super.init(style: .plain); title = "Recorded Measurements"
	}
	required init?(coder: NSCoder) { fatalError("Use init(series:)") }
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.accessibilityIdentifier = "healthSeriesMeasurements"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 64
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch series {
		case .ecg(let values): return values.count
		case .route(let values): return values.count
		case .heartbeat(let values): return values.count
		case .quantity(let values): return values.count
		}
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		switch series {
		case .ecg: return "Offsets are seconds from the original ECG start. Missing voltage measurements remain unavailable."
		case .route: return "Locations retain their recorded timestamps and accuracy. No route points are inferred."
		case .heartbeat: return "Offsets are seconds from the original series start. Recorded gaps are preserved."
		case .quantity: return "Each quantity keeps its original start and end instants. Gaps and different interval lengths are preserved."
		}
	}
	func fields(at row: Int) -> [HealthRecordField] {
		switch series {
		case .ecg(let values):
			let value = values[row]
			return [.init(name: "Offset (s)", value: String(value.timeSinceSampleStart)),
				.init(name: "Voltage (mV)", value: value.voltageInMillivolts.map { String($0) } ?? "Unavailable")]
		case .heartbeat(let values):
			let value = values[row]
			return [.init(name: "Offset (s)", value: String(value.timeSinceSeriesStart)),
				.init(name: "Preceded by a gap", value: value.precededByGap ? "Yes" : "No")]
		case .quantity(let values):
			let value = values[row]
			return [.init(name: "Start", value: HealthRecordDetails.dateText(value.dateInterval.start)),
				.init(name: "End", value: HealthRecordDetails.dateText(value.dateInterval.end)),
				.init(name: "Start reference seconds", value: String(value.dateInterval.start.timeIntervalSinceReferenceDate)),
				.init(name: "End reference seconds", value: String(value.dateInterval.end.timeIntervalSinceReferenceDate)),
				.init(name: "Quantity", value: value.quantity.description)]
		case .route(let values):
			let value = values[row]
			return [.init(name: "Timestamp", value: HealthRecordDetails.dateText(value.timestamp)),
				.init(name: "Timestamp reference seconds", value: String(value.timestamp.timeIntervalSinceReferenceDate)),
				.init(name: "Latitude", value: String(value.latitude)), .init(name: "Longitude", value: String(value.longitude)),
				.init(name: "Altitude (m)", value: String(value.altitude)),
				.init(name: "Horizontal accuracy (m)", value: String(value.horizontalAccuracy)),
				.init(name: "Vertical accuracy (m)", value: String(value.verticalAccuracy)),
				.init(name: "Speed (m/s)", value: value.speed.map { String($0) } ?? "Unavailable"),
				.init(name: "Course (degrees)", value: value.course.map { String($0) } ?? "Unavailable")]
		}
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let values = fields(at: indexPath.row)
		return HealthDetailFieldCell.make(in: tableView, field: .init(name: values[0].value,
			value: values.dropFirst().map { $0.name + ": " + $0.value }.joined(separator: "\n")))
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		let fields = fields(at: indexPath.row)
		let sections = [HealthRecordSection(title: "Recorded measurement", fields: fields)]
		navigationController?.pushViewController(HealthValueRecordViewController(title: "Recorded Measurement", sections: sections), animated: true)
	}
}

/// Non-time-series records and individual series rows share the same read-only
/// field viewer. Missing timestamps are never replaced with today's date.
final class HealthValueRecordViewController: UITableViewController {
	let sections: [HealthRecordSection]
	init(title: String, sections: [HealthRecordSection]) {
		self.sections = sections; super.init(style: .insetGrouped); self.title = title
	}
	required init?(coder: NSCoder) { fatalError("Use init(title:sections:)") }
	override func viewDidLoad() {
		super.viewDidLoad(); tableView.accessibilityIdentifier = "healthValueRecord"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 75
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
	}
	override func numberOfSections(in tableView: UITableView) -> Int { sections.count }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].fields.count }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { sections[section].title }
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		HealthDetailFieldCell.make(in: tableView, field: sections[indexPath.section].fields[indexPath.row])
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		navigationController?.pushViewController(HealthFieldTextViewController(field: sections[indexPath.section].fields[indexPath.row]), animated: true)
	}
	@objc private func share(_ sender: UIBarButtonItem) {
		HealthRecordSharing.present(title: title ?? "Health record", sections: sections, from: self, anchor: sender)
	}
}
