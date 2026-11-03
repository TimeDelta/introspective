import CoreData
import UIKit

import Common
import DependencyInjection
import Queries
import UIExtensions

final class PinnedQueryDashboardViewController: UITableViewController {
	var preferences: PinnedQueryPreferences = .shared
	lazy var loader: PinnedQueryDashboardLoading = PinnedQueryDashboardService()
	/// Explore supplies the app's results navigation; tests can inspect the exact records.
	var showRecords: ((PinnedQueryDashboardRecords) -> Void)?
	private(set) var cards: [PinnedQueryCard] = []
	private var observers: [NSObjectProtocol] = []
	private var refreshTask: PinnedQueryDashboardTask?
	private var openingTask: PinnedQueryDashboardTask?
	private var healthTask: PinnedQueryDashboardTask?
	private var observedPinIDs: Set<String>?
	private var healthGeneration = UUID()
	private var pendingRefresh: DispatchWorkItem?
	private var generation = UUID()
	private var visible = false
	private var inBackground = false
	private var openingID: String?
	private var preferencesError: String?
	private var pinButton: UIBarButtonItem!
	private var reloadButton: UIBarButtonItem!
	private let dates: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium; formatter.timeStyle = .short
		formatter.locale = .autoupdatingCurrent; formatter.timeZone = .autoupdatingCurrent
		return formatter
	}()
	private let percentages: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent; formatter.maximumFractionDigits = 1
		return formatter
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Pinned Queries"
		tableView.accessibilityIdentifier = "pinnedQueryDashboard"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 160
		setTableViewInsetsForTabBar()
		pinButton = UIBarButtonItem(title: "Pin Queries", style: .plain, target: self, action: #selector(choosePins))
		pinButton.accessibilityIdentifier = "pinDashboardQueries"
		reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshDashboard))
		reloadButton.accessibilityLabel = "Refresh dashboard"
		reloadButton.accessibilityIdentifier = "refreshQueryDashboard"
		navigationItem.rightBarButtonItems = [pinButton, reloadButton]
		navigationItem.leftBarButtonItem = editButtonItem
		navigationItem.leftItemsSupplementBackButton = true
		refreshControl = UIRefreshControl()
		refreshControl?.accessibilityIdentifier = "pinnedQueryRefresh"
		refreshControl?.addTarget(self, action: #selector(refreshDashboard), for: .valueChanged)
		observeChanges()
		updateEmptyState()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		visible = true
		if !isEditing { refreshDashboard() }
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		visible = false
		cancelWork()
		cancelHealthObservation()
	}

	deinit {
		pendingRefresh?.cancel(); refreshTask?.cancel(); openingTask?.cancel(); healthTask?.cancel()
		for observer in observers { NotificationCenter.default.removeObserver(observer) }
	}

	private func observeChanges() {
		let center = NotificationCenter.default
		observers.append(center.addObserver(forName: .NSManagedObjectContextDidSave, object: nil, queue: nil) { [weak self] note in
			// Only inspect change counts on the context's posting queue. No managed
			// object or notification payload crosses into the UI callback.
			let changed = [NSInsertedObjectsKey, NSUpdatedObjectsKey, NSDeletedObjectsKey].contains {
				((note.userInfo?[$0] as? NSSet)?.count ?? 0) > 0
			}
			guard changed else { return }
			let queryChanged = [NSInsertedObjectsKey, NSUpdatedObjectsKey, NSDeletedObjectsKey].contains { key in
				(note.userInfo?[key] as? NSSet)?.allObjects.contains {
					($0 as? NSManagedObject)?.entity.name == StoredQuery.entityName
				} == true
			}
			DispatchQueue.main.async { [weak self] in
				if queryChanged { self?.cancelHealthObservation() }
				self?.scheduleRefresh()
			}
		})
		observers.append(center.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] _ in
			self?.inBackground = true
			self?.cancelWork(); self?.cancelHealthObservation()
		})
		observers.append(center.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
			self?.inBackground = false
			self?.scheduleRefresh()
		})
		for name in [UIApplication.significantTimeChangeNotification,
			Notification.Name.NSCalendarDayChanged, .NSSystemTimeZoneDidChange, NSLocale.currentLocaleDidChangeNotification] {
			observers.append(center.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
				self?.scheduleRefresh()
			})
		}
	}

	private func scheduleRefresh() {
		guard visible, !inBackground, !isEditing else { return }
		pendingRefresh?.cancel()
		let work = DispatchWorkItem { [weak self] in
			guard let self = self, self.visible, !self.inBackground, !self.isEditing else { return }
			self.refreshDashboard()
		}
		pendingRefresh = work
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: work)
	}

	private func cancelWork() {
		generation = UUID()
		pendingRefresh?.cancel(); pendingRefresh = nil
		refreshTask?.cancel(); refreshTask = nil
		openingTask?.cancel(); openingTask = nil
		openingID = nil
		refreshControl?.endRefreshing()
	}

	private func cancelHealthObservation() {
		healthGeneration = UUID()
		healthTask?.cancel(); healthTask = nil; observedPinIDs = nil
	}

	private func observeHealthChanges(for pins: [PinnedQueryReference]) {
		let ids = Set(pins.map { $0.id })
		guard observedPinIDs != ids else { return }
		cancelHealthObservation()
		observedPinIDs = ids
		guard !ids.isEmpty else { return }
		let token = healthGeneration
		healthTask = loader.observeHealthChanges(pins) { [weak self] in
			guard let self = self, self.visible, !self.inBackground,
				self.healthGeneration == token, self.observedPinIDs == ids else { return }
			self.scheduleRefresh()
		}
	}

	@objc func refreshDashboard() {
		guard visible, !inBackground, !isEditing else { refreshControl?.endRefreshing(); return }
		cancelWork()
		preferencesError = nil
		do {
			cards = try preferences.pins().map { PinnedQueryCard(pin: $0, sampleTypeName: nil, queryDescription: nil, state: .loading) }
		} catch {
			cards = []; preferencesError = error.localizedDescription
			cancelHealthObservation()
			updateEmptyState(); tableView.reloadData(); return
		}
		updateEmptyState(); tableView.reloadData()
		observeHealthChanges(for: cards.map { $0.pin })
		guard !cards.isEmpty else { return }
		let token = generation
		refreshTask = loader.refresh(cards.map { $0.pin }, onCard: { [weak self] card in
			guard let self = self, self.visible, !self.isEditing, self.generation == token,
				let index = self.cards.firstIndex(where: { $0.pin.id == card.pin.id }) else { return }
			if self.cards[index].pin.lastKnownName != card.pin.lastKnownName {
				do { try self.preferences.pin(card.pin) }
				catch { self.preferencesError = error.localizedDescription }
			}
			self.cards[index] = card
			self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
		}, completion: { [weak self] in
			guard let self = self, self.visible, self.generation == token else { return }
			self.refreshControl?.endRefreshing()
		})
	}

	private func updateEmptyState() {
		let empty = UILabel()
		empty.text = preferencesError ?? "Pin saved queries to see their current results here. Save a query in Explore → Query, then choose Pin Queries."
		empty.numberOfLines = 0; empty.textAlignment = .center
		empty.font = .preferredFont(forTextStyle: .body); empty.adjustsFontForContentSizeCategory = true
		empty.textColor = .secondaryLabel
		let background = UIView()
		empty.translatesAutoresizingMaskIntoConstraints = false; background.addSubview(empty)
		NSLayoutConstraint.activate([empty.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 24),
			empty.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -24),
			empty.centerYAnchor.constraint(equalTo: background.centerYAnchor)])
		tableView.backgroundView = cards.isEmpty ? background : nil
		editButtonItem.isEnabled = !cards.isEmpty
	}

	@objc private func choosePins() {
		if isEditing { setEditing(false, animated: false) }
		let controller = PinnedQueryPickerViewController(preferences: preferences)
		navigationController?.pushViewController(controller, animated: true)
	}

	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		if editing { cancelWork() }
		else if visible { refreshDashboard() }
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cards.count }

	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		guard !cards.isEmpty else { return nil }
		let instructions = "Tap a card to open current matching records. Swipe left to unpin; Edit to reorder. Dates describe matching records, not the query's coverage. Health counts include only records available to this app."
		return preferencesError.map { instructions + "\n" + $0 } ?? instructions
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let card = cards[indexPath.row]
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.textLabel?.text = card.pin.lastKnownName
		cell.textLabel?.font = .preferredFont(forTextStyle: .headline)
		cell.textLabel?.numberOfLines = 0; cell.textLabel?.adjustsFontForContentSizeCategory = true
		cell.detailTextLabel?.numberOfLines = 0; cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
		cell.detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline)
		cell.accessibilityIdentifier = "dashboardQuery." + card.pin.id
		var lines = [String]()
		if let type = card.sampleTypeName { lines.append(type) }
		if let query = card.queryDescription, !query.isEmpty { lines.append(query) }
		switch card.state {
		case .loading:
			lines.append("Refreshing…")
			cell.selectionStyle = .none
		case let .unavailable(message):
			lines.append("Unavailable: " + message)
			cell.selectionStyle = .none
		case let .ready(summary):
			lines.append("\(summary.count) matching \(summary.count == 1 ? "record" : "records") available")
			if let value = summary.meanRatingPosition {
				let percentage = percentages.string(from: NSNumber(value: value)) ?? "\(value * 100)%"
				lines.append("Mean rating: \(percentage) of saved scales · \(summary.validRatingCount) valid")
			}
			if summary.excludedRatingCount > 0 { lines.append("\(summary.excludedRatingCount) invalid or missing ratings excluded from mean") }
			if let first = summary.earliestDate, let last = summary.latestDate {
				lines.append("Matching records: " + dates.string(from: first) + (first == last ? "" : " – " + dates.string(from: last)))
			}
			lines.append("Evaluated " + dates.string(from: summary.evaluatedAt))
			if openingID == card.pin.id { lines.append("Opening current records…") }
			cell.accessoryType = .disclosureIndicator
		}
		cell.detailTextLabel?.text = lines.joined(separator: "\n")
		return cell
	}

	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		guard !isEditing, openingID == nil, cards.indices.contains(indexPath.row), case .ready = cards[indexPath.row].state else { return nil }
		return indexPath
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		guard !isEditing, openingID == nil, cards.indices.contains(indexPath.row), case .ready = cards[indexPath.row].state else { return }
		let pin = cards[indexPath.row].pin
		openingID = pin.id
		tableView.reloadRows(at: [indexPath], with: .none)
		let token = generation
		openingTask = loader.openResults(pin) { [weak self] result in
			guard let self = self, self.visible, !self.isEditing, self.generation == token,
				self.openingID == pin.id, let index = self.cards.firstIndex(where: { $0.pin.id == pin.id }) else { return }
			self.openingID = nil
			self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
			switch result {
			case let .success(records):
				if let show = self.showRecords { show(records) }
				else { self.showError(title: "Could not open query results", message: "Return to Explore and reopen Pinned Queries.") }
			case let .failure(error): self.showError(title: "Could not open query results", error: error)
			}
		}
	}

	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { true }

	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		guard cards.indices.contains(sourceIndexPath.row), cards.indices.contains(destinationIndexPath.row) else { return }
		do {
			try preferences.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
			let card = cards.remove(at: sourceIndexPath.row); cards.insert(card, at: destinationIndexPath.row)
		} catch { showError(title: "Could not reorder pinned queries", error: error); tableView.reloadData() }
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete, cards.indices.contains(indexPath.row) else { return }
		do {
			try preferences.unpin(id: cards[indexPath.row].pin.id)
			cancelWork(); cards.remove(at: indexPath.row)
			cancelHealthObservation()
			tableView.deleteRows(at: [indexPath], with: .automatic); updateEmptyState()
			if visible, !isEditing { scheduleRefresh() }
		} catch { showError(title: "Could not unpin query", error: error) }
	}

	override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? { "Unpin" }
}

private final class PinnedQueryPickerViewController: UITableViewController, UISearchResultsUpdating {
	private let preferences: PinnedQueryPreferences
	private var queries: [StoredQuery] = []
	private var displayed: [StoredQuery] = []
	private var pinned = Set<String>()
	private let search = UISearchController(searchResultsController: nil)
	private var loadError: String?

	init(preferences: PinnedQueryPreferences) { self.preferences = preferences; super.init(style: .plain) }
	required init?(coder: NSCoder) { fatalError("Use init(preferences:)") }

	override func viewDidLoad() {
		super.viewDidLoad(); title = "Pin Queries"
		tableView.accessibilityIdentifier = "pinnedQueryPicker"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 55
		search.searchResultsUpdater = self; search.obscuresBackgroundDuringPresentation = false
		search.searchBar.placeholder = "Search saved queries"
		navigationItem.searchController = search; navigationItem.hidesSearchBarWhenScrolling = false
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
		definesPresentationContext = true
		do { queries = try injected(StoredQueriesDAO.self).getAllQueries(); pinned = Set(try preferences.pins().map { $0.id }) }
		catch { loadError = error.localizedDescription }
		updateSearchResults(for: search)
	}

	@objc private func done() { navigationController?.popViewController(animated: true) }
	func updateSearchResults(for searchController: UISearchController) {
		displayed = queries.filter { $0.matchesSearchText(searchController.searchBar.text ?? "") }
		let label = UILabel()
		label.numberOfLines = 0; label.textAlignment = .center
		label.text = loadError ?? (queries.isEmpty ? "No saved queries. Save a query from Explore → Query first." : "No matching saved queries.")
		tableView.backgroundView = displayed.isEmpty ? label : nil
		tableView.reloadData()
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { displayed.count }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		"Tap to pin or unpin. Keep up to \(PinnedQueryPreferences.maximumPins) queries. Unpinning leaves the saved query and its records intact."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let query = displayed[indexPath.row], cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		cell.textLabel?.text = query.name; cell.textLabel?.numberOfLines = 0
		cell.textLabel?.font = .preferredFont(forTextStyle: .body); cell.textLabel?.adjustsFontForContentSizeCategory = true
		cell.accessoryType = pinned.contains(query.objectID.uriRepresentation().absoluteString) ? .checkmark : .none
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		guard loadError == nil else { return }
		let query = displayed[indexPath.row], id = query.objectID.uriRepresentation().absoluteString
		do {
			guard !query.objectID.isTemporaryID, !query.isDeleted else { throw PinnedQueryPreferencesError.invalidReference }
			if pinned.contains(id) { try preferences.unpin(id: id); pinned.remove(id) }
			else {
				let pin = PinnedQueryReference(id: id, lastKnownName: String(query.name.prefix(PinnedQueryPreferences.maximumNameLength)))
				try preferences.pin(pin); pinned.insert(id)
			}
			tableView.reloadRows(at: [indexPath], with: .none)
		} catch { showError(title: "Could not change pinned queries", error: error) }
	}
}
