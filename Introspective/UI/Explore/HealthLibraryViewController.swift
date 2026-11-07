import UIKit

import DependencyInjection
import Queries
import Samples

/// Readers are injectable so the library can be exercised without requesting
/// Health authorization. A read always returns its cancellation operation.
typealias HealthLibrarySampleLoader = (Sample.Type, @escaping (Result<[Sample], Error>) -> Void) -> () -> Void
typealias HealthLibraryExternalLoader = (HealthTypeDescriptor, @escaping (Result<[HealthExternalRecord], Error>) -> Void) -> () -> Void

/// Browsing the catalog does not read Health records. Authorization is requested
/// only when the person opens a particular data type.
final class HealthLibraryViewController: UITableViewController, UISearchResultsUpdating {
	let searchController = UISearchController(searchResultsController: nil)
	private let descriptors: [HealthTypeDescriptor]
	private let sampleTypes: [Int16: Sample.Type]
	private let sampleLoader: HealthLibrarySampleLoader
	private let externalLoader: HealthLibraryExternalLoader
	private(set) var groups: [String] = []
	private(set) var filteredDescriptors: [HealthTypeDescriptor] = []
	private var sections: [[HealthTypeDescriptor]] = []

	init(descriptors: [HealthTypeDescriptor] = HealthCatalog.availableDescriptors,
		sampleTypes: [Int16: Sample.Type] = Dictionary(uniqueKeysWithValues: HealthCatalog.availableEntries.map { ($0.descriptor.id, $0.sampleType) }),
		sampleLoader: HealthLibrarySampleLoader? = nil, externalLoader: HealthLibraryExternalLoader? = nil) {
		self.descriptors = descriptors
		self.sampleTypes = sampleTypes
		self.sampleLoader = sampleLoader ?? HealthLibraryRecordsViewController.readSamples
		self.externalLoader = externalLoader ?? HealthLibraryRecordsViewController.externalReader()
		super.init(style: .insetGrouped)
		title = "Health Data"
	}

	required init?(coder: NSCoder) { fatalError("Use init(descriptors:sampleTypes:sampleLoader:externalLoader:)") }

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.accessibilityIdentifier = "healthLibrary"
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 64
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search all Health data"
		searchController.searchBar.accessibilityIdentifier = "healthLibrarySearch"
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true
		updateSearchResults(for: searchController)
	}

	func updateSearchResults(for searchController: UISearchController) {
		let terms = normalized(searchController.searchBar.text ?? "").split(whereSeparator: { $0.isWhitespace })
		filteredDescriptors = descriptors.filter { descriptor in
			let searchable = normalized([descriptor.name, descriptor.group, descriptor.family.libraryName,
				descriptor.identifier].joined(separator: " "))
			return terms.allSatisfy { searchable.contains($0) }
		}.sorted {
			if $0.group != $1.group { return $0.group.localizedStandardCompare($1.group) == .orderedAscending }
			if $0.name != $1.name { return $0.name.localizedStandardCompare($1.name) == .orderedAscending }
			return $0.id < $1.id
		}
		groups = Array(Set(filteredDescriptors.map { $0.group })).sorted { $0.localizedStandardCompare($1) == .orderedAscending }
		let byGroup = Dictionary(grouping: filteredDescriptors, by: { $0.group })
		sections = groups.map { byGroup[$0] ?? [] }
		if filteredDescriptors.isEmpty {
			let label = UILabel()
			label.text = "No Health data types match this search."
			label.textAlignment = .center; label.numberOfLines = 0
			label.font = .preferredFont(forTextStyle: .body)
			label.adjustsFontForContentSizeCategory = true
			label.accessibilityIdentifier = "healthLibraryNoMatches"
			tableView.backgroundView = label
		} else { tableView.backgroundView = nil }
		tableView.reloadData()
	}

	private func normalized(_ value: String) -> String {
		value.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .autoupdatingCurrent)
	}

	override func numberOfSections(in tableView: UITableView) -> Int { sections.count }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].count }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { groups[section] }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		section == sections.count - 1 ? "Choose a data type to read records shared with this app. Changes are made in Health or the app that recorded them." : nil
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let descriptor = sections[indexPath.section][indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "healthLibraryType")
			?? UITableViewCell(style: .subtitle, reuseIdentifier: "healthLibraryType")
		cell.textLabel?.text = descriptor.name
		cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.textLabel?.adjustsFontForContentSizeCategory = true
		cell.textLabel?.numberOfLines = 0
		cell.detailTextLabel?.text = descriptor.family.libraryName
		cell.detailTextLabel?.font = .preferredFont(forTextStyle: .caption1)
		cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
		cell.detailTextLabel?.numberOfLines = 0
		cell.accessoryType = .disclosureIndicator
		cell.accessibilityIdentifier = "healthLibraryType.\(descriptor.id)"
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let descriptor = sections[indexPath.section][indexPath.row]
		let records = HealthLibraryRecordsViewController(descriptor: descriptor, sampleType: sampleTypes[descriptor.id],
			sampleLoader: sampleLoader, externalLoader: externalLoader)
		navigationController?.pushViewController(records, animated: true)
	}
}

/// A read-only list for both ordinary dated samples and families with a public
/// dedicated reader. Profile values and medication-list entries stay undated.
final class HealthLibraryRecordsViewController: UITableViewController {
	let descriptor: HealthTypeDescriptor
	private let sampleType: Sample.Type?
	private let sampleLoader: HealthLibrarySampleLoader
	private let externalLoader: HealthLibraryExternalLoader
	private var cancelRead: (() -> Void)?
	private var generation = UUID()
	private(set) var samples: [HealthKitSample] = []
	private(set) var externalRecords: [HealthExternalRecord] = []
	private(set) var isLoading = false
	private(set) var statusText = ""
	private let progress = UIActivityIndicatorView(style: .medium)
	private let statusLabel = UILabel()
	private let statusView = UIView()
	private let dates: DateFormatter = {
		let value = DateFormatter(); value.dateStyle = .medium; value.timeStyle = .short
		value.locale = .autoupdatingCurrent; value.timeZone = .autoupdatingCurrent
		return value
	}()

	init(descriptor: HealthTypeDescriptor, sampleType: Sample.Type?,
		sampleLoader: HealthLibrarySampleLoader? = nil, externalLoader: HealthLibraryExternalLoader? = nil) {
		self.descriptor = descriptor; self.sampleType = sampleType
		self.sampleLoader = sampleLoader ?? Self.readSamples
		self.externalLoader = externalLoader ?? Self.externalReader()
		super.init(style: .insetGrouped)
		title = descriptor.name
	}
	required init?(coder: NSCoder) { fatalError("Use init(descriptor:sampleType:sampleLoader:externalLoader:)") }
	deinit { cancelRead?() }

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.accessibilityIdentifier = "healthLibraryRecords"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 80
		statusLabel.numberOfLines = 0; statusLabel.textAlignment = .center
		statusLabel.font = .preferredFont(forTextStyle: .body)
		statusLabel.adjustsFontForContentSizeCategory = true
		statusLabel.accessibilityIdentifier = "healthLibraryReadStatus"
		let stack = UIStackView(arrangedSubviews: [progress, statusLabel])
		stack.axis = .vertical; stack.alignment = .center; stack.spacing = 16
		stack.translatesAutoresizingMaskIntoConstraints = false; statusView.addSubview(stack)
		NSLayoutConstraint.activate([
			stack.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
			stack.leadingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: 24),
			stack.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: -24),
		])
		let reload = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadRecords))
		reload.accessibilityIdentifier = "healthLibraryReload"
		navigationItem.rightBarButtonItem = reload
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(reloadRecords), for: .valueChanged)
		reloadRecords()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if isMovingFromParent || isBeingDismissed || navigationController?.isBeingDismissed == true { cancelLoading() }
	}

	override func didMove(toParent parent: UIViewController?) {
		super.didMove(toParent: parent)
		// A navigation stack can remove a loaded controller before it ever
		// appears. That removal has no disappearance callback.
		if parent == nil { cancelLoading() }
	}

	/// Invalidate before calling cancellation: a reader may complete synchronously
	/// from its cancellation operation.
	func cancelLoading() {
		generation = UUID()
		let cancel = cancelRead; cancelRead = nil
		if isLoading { statusText = "Reading canceled. Reload to try again." }
		isLoading = false; cancel?()
		if isViewLoaded { render() }
	}

	@objc func reloadRecords() {
		cancelLoading()
		let token = UUID(); generation = token
		samples = []; externalRecords = []
		if descriptor.family == .attachment {
			statusText = "Attachments belong to a parent Health record. Open an individual record, then choose Attachments to read files shared with this app."
			render(); return
		}
		isLoading = true; statusText = "Reading \(descriptor.name)…"; render()
		let cancel: () -> Void
		if let sampleType = sampleType {
			cancel = sampleLoader(sampleType) { [weak self] result in
				DispatchQueue.global(qos: .userInitiated).async {
					let prepared = result.flatMap { values in Self.prepareSamples(values, expectedType: sampleType) }
					DispatchQueue.main.async { [weak self] in
						guard let self = self, self.generation == token else { return }
						self.finishSamples(prepared)
					}
				}
			}
		} else {
			cancel = externalLoader(descriptor) { [weak self] result in
				DispatchQueue.global(qos: .userInitiated).async {
					let prepared = result.map { values in
						values.enumerated().sorted { lhs, rhs in
							let left = lhs.element.dates[.start], right = rhs.element.dates[.start]
							if left == right { return lhs.offset < rhs.offset }
							guard let left = left else { return false }
							guard let right = right else { return true }
							return left > right
						}.map { $0.element }
					}
					DispatchQueue.main.async { [weak self] in
						guard let self = self, self.generation == token else { return }
						self.finishExternal(prepared)
					}
				}
			}
		}
		// Publication is always asynchronous, so even a synchronous injected reader
		// installs cancellation before its completion is applied on the main queue.
		if generation == token, isLoading { cancelRead = cancel } else { cancel() }
	}

	nonisolated private static func prepareSamples(_ values: [Sample], expectedType: Sample.Type) -> Result<[HealthKitSample], Error> {
		var healthSamples: [(offset: Int, sample: HealthKitSample, date: Date?)] = []
		healthSamples.reserveCapacity(values.count)
		for (offset, value) in values.enumerated() {
			guard let health = value as? HealthKitSample, type(of: value) == expectedType else {
				return .failure(HealthCatalogError.unexpectedSample(expectedType.name))
			}
			healthSamples.append((offset, health, health.originalHealthSample?.startDate))
		}
		return .success(healthSamples.sorted { lhs, rhs in
			if lhs.date == rhs.date { return lhs.offset < rhs.offset }
			guard let left = lhs.date else { return false }
			guard let right = rhs.date else { return true }
			return left > right
		}.map { $0.sample })
	}

	private func finishSamples(_ result: Result<[HealthKitSample], Error>) {
		finish(result.map { values in self.samples = values; return values.count })
	}
	private func finishExternal(_ result: Result<[HealthExternalRecord], Error>) {
		finish(result.map { values in self.externalRecords = values; return values.count })
	}
	private func finish(_ result: Result<Int, Error>) {
		generation = UUID()
		isLoading = false; cancelRead = nil
		switch result {
		case .success(let count):
			statusText = count == 0 ? "No records are visible to this app. Health may have no matching records, or access may be limited. You can review access in Health and reload." : "\(count) records"
		case .failure(let error): statusText = "Could not read \(descriptor.name). \(error.localizedDescription) Reload to try again."
		}
		render()
	}

	private func render() {
		statusLabel.text = statusText
		if isLoading { progress.startAnimating() } else { progress.stopAnimating() }
		progress.isHidden = !isLoading
		tableView.backgroundView = samples.isEmpty && externalRecords.isEmpty ? statusView : nil
		if !isLoading { refreshControl?.endRefreshing() }
		tableView.reloadData()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { samples.count + externalRecords.count }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		samples.isEmpty && externalRecords.isEmpty ? nil : "These records are read only here. Make changes in Health or the app that recorded them."
	}
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { false }
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if !samples.isEmpty {
			let sample = samples[indexPath.row]
			let cell = HealthResultSummaryCell.make(in: tableView, sample: sample)
			cell.accessibilityIdentifier = "healthLibrarySample.\(sample.sourceIdentifier?.uuidString ?? String(indexPath.row))"
			return cell
		}
		let record = externalRecords[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "healthExternalRecord")
			?? UITableViewCell(style: .subtitle, reuseIdentifier: "healthExternalRecord")
		cell.textLabel?.text = record.title
		cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.textLabel?.adjustsFontForContentSizeCategory = true; cell.textLabel?.numberOfLines = 0
		cell.detailTextLabel?.text = record.dates[.start].map { dates.string(from: $0) }
		cell.detailTextLabel?.font = .preferredFont(forTextStyle: .caption1)
		cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
		cell.detailTextLabel?.numberOfLines = 0
		cell.accessoryType = .disclosureIndicator
		cell.accessibilityIdentifier = "healthLibraryExternal.\(indexPath.row)"
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if !samples.isEmpty {
			navigationController?.pushViewController(HealthRecordDetailViewController(sample: samples[indexPath.row]), animated: true)
		} else {
			let record = externalRecords[indexPath.row]
			navigationController?.pushViewController(HealthValueRecordViewController(title: record.title, sections: record.sections), animated: true)
		}
	}

	static func readSamples(_ type: Sample.Type, completion: @escaping (Result<[Sample], Error>) -> Void) -> () -> Void {
		do {
			let query = try injected(QueryFactory.self).queryFor(type)
			query.mostRecentEntryOnly = false
			query.runQuery { result, error in
				if let error = error { completion(.failure(error)) }
				else if let result = result { completion(.success(result.samples)) }
				else { completion(.failure(HealthLibraryReadError.missingResult)) }
			}
			return { query.stop() }
		} catch { completion(.failure(error)); return {} }
	}
	static func externalReader() -> HealthLibraryExternalLoader {
		let reader = HealthExternalRecordReader()
		return { descriptor, completion in reader.read(descriptor: descriptor, completion: completion) }
	}
}

private enum HealthLibraryReadError: LocalizedError {
	case missingResult
	var errorDescription: String? { "The Health read did not return a result." }
}

private extension HealthTypeFamily {
	var libraryName: String {
		switch self {
		case .quantity: return "Measurements"
		case .category: return "Categories and events"
		case .correlation: return "Related measurements"
		case .clinical: return "Clinical records"
		case .document: return "Health documents"
		case .characteristic: return "Health profile"
		case .activitySummary: return "Daily activity summaries"
		case .workout: return "Workouts"
		case .workoutRoute: return "Workout routes"
		case .heartbeatSeries: return "Heartbeat series"
		case .electrocardiogram: return "Electrocardiograms"
		case .audiogram: return "Audiograms"
		case .visionPrescription: return "Vision prescriptions"
		case .stateOfMind: return "State of mind"
		case .scoredAssessment: return "Scored assessments"
		case .medicationDose: return "Medication dose events"
		case .userAnnotatedMedication: return "Medication list"
		case .verifiableClinical: return "Verifiable clinical records"
		case .attachment: return "Record attachments"
		}
	}
}
