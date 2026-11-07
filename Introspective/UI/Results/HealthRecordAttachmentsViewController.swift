import UIKit
import HealthKit
import QuickLook
import Samples
import UIExtensions

final class HealthRecordAttachmentsViewController: UITableViewController {
	typealias Loader = (HKObject, @escaping (Result<[HKAttachment], Error>) -> Void) -> () -> Void
	let record: HKObject
	var loadAttachments: Loader?
	private lazy var reader = HealthRecordAttachmentReader()
	private var attachments: [HKAttachment] = []
	private var cancelRead: (() -> Void)?
	private var generation = UUID()
	private var errorText: String?
	private var reading = false
	private var downloadDirectory: URL?

	init(record: HKObject) { self.record = record; super.init(style: .insetGrouped); title = "Attachments" }
	required init?(coder: NSCoder) { fatalError("Use init(record:)") }
	deinit {
		cancelRead?()
		if let directory = downloadDirectory { try? FileManager.default.removeItem(at: directory) }
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.accessibilityIdentifier = "healthRecordAttachments"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 75
		refreshControl = UIRefreshControl(); refreshControl?.addTarget(self, action: #selector(reloadAttachments), for: .valueChanged)
		reloadAttachments()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if isMovingFromParent || isBeingDismissed || navigationController?.isBeingDismissed == true {
			generation = UUID(); cancelRead?(); cancelRead = nil
			clearDownload()
		}
	}
	@objc func reloadAttachments() {
		cancelRead?(); let token = UUID(); generation = token
		clearDownload(); tableView.isUserInteractionEnabled = true; navigationItem.prompt = nil
		reading = true; errorText = nil; attachments = []; tableView.reloadData()
		let completion: (Result<[HKAttachment], Error>) -> Void = { [weak self] result in
			DispatchQueue.main.async {
				guard let self = self, self.generation == token else { return }
				self.generation = UUID(); self.cancelRead = nil; self.reading = false
				self.refreshControl?.endRefreshing()
				switch result {
				case .success(let values): self.attachments = values.sorted { $0.creationDate > $1.creationDate }
				case .failure(let error): self.errorText = error.localizedDescription
				}
				self.tableView.reloadData()
			}
		}
		cancelRead = loadAttachments?(record, completion) ?? reader.readAttachments(for: record, completion: completion)
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { max(1, attachments.count) }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		"Only attachments shared with this app are returned. Tap a file to open it or its information button to inspect the recorded metadata."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard !attachments.isEmpty else {
			let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
			cell.textLabel?.text = reading ? "Reading attachments…" : errorText == nil ? "No attachments returned" : "Could not read attachments"
			cell.detailTextLabel?.text = errorText; cell.detailTextLabel?.numberOfLines = 0
			cell.selectionStyle = .none; return cell
		}
		let item = attachments[indexPath.row]
		let cell = HealthDetailFieldCell.make(in: tableView, field: .init(name: item.name,
			value: "\(item.contentType.identifier) · \(item.size) bytes\n" + HealthRecordDetails.dateText(item.creationDate)))
		cell.accessoryType = .detailDisclosureButton
		return cell
	}
	override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		guard attachments.indices.contains(indexPath.row) else { return }
		let item = attachments[indexPath.row]
		navigationController?.pushViewController(HealthValueRecordViewController(title: item.name,
			sections: HealthRecordAttachmentReader.sections(for: item)), animated: true)
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		guard attachments.indices.contains(indexPath.row), !reading else { return }
		let attachment = attachments[indexPath.row]
		let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
		do { try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true) }
		catch { showError(title: "Could not open attachment", error: error); return }
		// Use a generated basename, never an untrusted attachment path. Its
		// original display name remains available in the metadata and preview.
		let preferred = attachment.contentType.preferredFilenameExtension ?? "data"
		let ext = preferred.count <= 16 && preferred.allSatisfy({ $0.isASCII && ($0.isLetter || $0.isNumber) }) ? preferred : "data"
		let file = directory.appendingPathComponent("Health-attachment").appendingPathExtension(ext)
		downloadDirectory = directory
		let token = UUID(); generation = token; reading = true
		navigationItem.prompt = "Reading attachment…"; tableView.isUserInteractionEnabled = false
		cancelRead = reader.download(attachment, to: file) { [weak self] result in
			DispatchQueue.main.async {
				guard let self = self, self.generation == token else {
					try? FileManager.default.removeItem(at: directory); return
				}
				self.generation = UUID(); self.cancelRead = nil; self.reading = false
				self.navigationItem.prompt = nil; self.tableView.isUserInteractionEnabled = true
				switch result {
				case .success(let url):
					self.downloadDirectory = nil
					self.navigationController?.pushViewController(HealthAttachmentPreviewController(file: url,
						title: attachment.name, ownedDirectory: directory), animated: true)
				case .failure(let error):
					self.clearDownload()
					self.showError(title: "Could not open attachment", error: error)
				}
			}
		}
	}
	private func clearDownload() {
		if let directory = downloadDirectory { try? FileManager.default.removeItem(at: directory) }
		downloadDirectory = nil
	}
}

private final class HealthAttachmentPreviewController: QLPreviewController, QLPreviewControllerDataSource {
	private let file: URL
	private let ownedDirectory: URL
	init(file: URL, title: String, ownedDirectory: URL) {
		self.file = file; self.ownedDirectory = ownedDirectory
		super.init(nibName: nil, bundle: nil); self.title = title; dataSource = self
	}
	required init?(coder: NSCoder) { fatalError("Use init(file:title:ownedDirectory:)") }
	deinit { try? FileManager.default.removeItem(at: ownedDirectory) }
	func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }
	func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem { file as NSURL }
}

final class HealthWorkoutRoutesViewController: UITableViewController {
	let workout: HKWorkout
	private lazy var store = HKHealthStore()
	private var routes: [HKWorkoutRoute] = []
	private var cancelRead: (() -> Void)?
	private var generation = UUID()
	private var errorText: String?
	private var reading = false
	init(workout: HKWorkout) { self.workout = workout; super.init(style: .insetGrouped); title = "Workout Routes" }
	required init?(coder: NSCoder) { fatalError("Use init(workout:)") }
	deinit { cancelRead?() }
	override func viewDidLoad() {
		super.viewDidLoad(); tableView.accessibilityIdentifier = "healthWorkoutRoutes"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 70
		reloadRoutes()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if isMovingFromParent || isBeingDismissed || navigationController?.isBeingDismissed == true {
			generation = UUID(); cancelRead?(); cancelRead = nil
		}
	}
	private func reloadRoutes() {
		cancelRead?(); let token = UUID(); generation = token
		reading = true; errorText = nil; routes = []; tableView.reloadData()
		let permissions: Set<HKObjectType> = [HKSeriesType.workoutRoute(), HKObjectType.workoutType()]
		HealthReadAuthorizationClient(store: store).request(types: permissions) { [weak self] error in
			DispatchQueue.main.async {
				guard let self = self, self.generation == token else { return }
				if let error = error {
					self.reading = false; self.errorText = error.localizedDescription; self.tableView.reloadData(); return
				}
				let query = HKSampleQuery(sampleType: HKSeriesType.workoutRoute(),
					predicate: HKQuery.predicateForObjects(from: self.workout), limit: Int(HKObjectQueryNoLimit),
					sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]) { [weak self] _, samples, error in
					DispatchQueue.main.async {
						guard let self = self, self.generation == token else { return }
						self.generation = UUID(); self.cancelRead = nil; self.reading = false
						if let error = error { self.errorText = error.localizedDescription }
						else if let samples = samples, let routes = samples as? [HKWorkoutRoute] { self.routes = routes }
						else { self.errorText = "Health did not return the requested route records." }
						self.tableView.reloadData()
					}
				}
				let store = self.store
				self.cancelRead = { store.stop(query) }; store.execute(query)
			}
		}
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { max(1, routes.count) }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		"Health returns only the routes shared with this app. An empty list can also mean this workout has no recorded route."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard !routes.isEmpty else {
			let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
			cell.textLabel?.text = reading ? "Reading routes…" : errorText == nil ? "No routes returned" : "Could not read routes"
			cell.detailTextLabel?.text = errorText; cell.detailTextLabel?.numberOfLines = 0; cell.selectionStyle = .none
			return cell
		}
		let route = routes[indexPath.row]
		return HealthDetailFieldCell.make(in: tableView, field: .init(name: "Route \(indexPath.row + 1)",
			value: HealthRecordDetails.dateText(route.startDate)))
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		guard routes.indices.contains(indexPath.row) else { return }
		navigationController?.pushViewController(HealthRecordDetailViewController(record: routes[indexPath.row], title: "Workout Route"), animated: true)
	}
}
