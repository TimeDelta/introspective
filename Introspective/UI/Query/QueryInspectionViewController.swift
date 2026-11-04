import UIKit

import Common
import DependencyInjection
import Queries
import Samples
import Settings

/// Opening this screen explains the definition only. Wider diagnostic reads
/// start solely when the user explicitly asks to inspect the condition counts.
final class QueryInspectionViewController: UITableViewController {
	var query: Query? {
		didSet {
			invalidateInspection()
			if isViewLoaded { showPreview() }
		}
	}
	var loader: QueryInspectionLoading = QueryInspectionService()
	var convertTimeZones: Bool?
	var clock: () -> Date = Date.init
	private(set) var report: QueryInspectionReport?
	private(set) var statusText = "Interpretation only. No records have been read."
	private(set) var selectedRecordID: QueryInspectionRecordID?
	private var explanation: QueryExplanation?
	private var task: QueryInspectionTask?
	private var generation = UUID()
	private var isInspecting = false
	private var visible = false
	private var inspectButton: UIBarButtonItem!
	private var sections: [Section] = []
	private let dates: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium; formatter.timeStyle = .medium
		formatter.locale = .autoupdatingCurrent; formatter.timeZone = .autoupdatingCurrent
		return formatter
	}()

	private struct Row {
		let id: String
		let text: String
		let details: String
		let depth: Int
	}
	private struct Section {
		let title: String
		let rows: [Row]
	}

	/// Capture on the sample's owning queue. Do not retain a managed sample while
	/// a private-context inspection runs or while this controller is offscreen.
	func selectRecord(_ sample: Sample) throws {
		selectRecord(identity: try QueryInspectionRecordID.capture(sample))
	}

	func selectRecord(identity: QueryInspectionRecordID) {
		selectedRecordID = identity
		invalidateInspection()
		if isViewLoaded {
			title = "Why This Record Matched"
			showPreview()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = selectedRecordID == nil ? "Query Explanation" : "Why This Record Matched"
		tableView.accessibilityIdentifier = "queryInspection"
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 100
		inspectButton = UIBarButtonItem(title: "Inspect Counts", style: .plain,
			target: self, action: #selector(inspectConditionCounts))
		inspectButton.accessibilityIdentifier = "inspectQueryCounts"
		navigationItem.rightBarButtonItem = inspectButton
		showPreview()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		visible = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		visible = false
		if isInspecting {
			invalidateInspection()
			statusText = "Inspection cancelled. Inspect again to read a new snapshot."
			rebuildRows()
		}
	}

	deinit { task?.cancel() }

	/// A second tap cancels; no partial counts are published as a complete report.
	@objc func inspectConditionCounts() {
		guard !isInspecting else {
			invalidateInspection()
			statusText = "Inspection cancelled. No query was changed."
			rebuildRows()
			return
		}
		guard let query = query else { return }
		do {
			let definition = try QueryInspectionDefinition.capture(query)
			invalidateInspection()
			let token = generation
			isInspecting = true
			statusText = "Inspecting a snapshot on this device…"
			updateButton(); rebuildRows()
			let requested = loader.inspect(definition, selectedRecord: selectedRecordID) { [weak self] result in
				let publish = { [weak self] in
					guard let self = self, self.visible, self.generation == token, self.isInspecting else { return }
					self.task = nil; self.isInspecting = false
					guard let current = self.query,
						let currentDefinition = try? QueryInspectionDefinition.capture(current), currentDefinition == definition else {
						self.showPreview()
						self.statusText = "The query changed. Inspect again to count the current conditions."
						self.updateButton(); self.rebuildRows()
						return
					}
					switch result {
					case let .success(report):
						self.report = report; self.explanation = report.explanation
						self.statusText = "Snapshot inspected \(self.dates.string(from: report.evaluatedAt)). Counts are independent; overlapping OR conditions are never added."
					case .failure:
						self.report = nil
						self.statusText = "Could not inspect this query. Its definition and results were not changed. Try again after checking that the saved data is available."
					}
					self.updateButton(); self.rebuildRows()
					UIAccessibility.post(notification: .announcement, argument: self.statusText)
				}
				if Thread.isMainThread { publish() } else { DispatchQueue.main.async(execute: publish) }
			}
			if generation == token, isInspecting { task = requested }
			else { requested.cancel() }
		} catch {
			invalidateInspection()
			statusText = "This query cannot be inspected safely. Check its conditions in the builder. No query was changed."
			rebuildRows()
		}
	}

	private func invalidateInspection() {
		generation = UUID()
		task?.cancel(); task = nil
		isInspecting = false
		report = nil
		if isViewLoaded { updateButton() }
	}

	private func showPreview() {
		report = nil
		do {
			guard let query = query else { throw previewError() }
			explanation = try QueryExplanationBuilder.explain(query: query, evaluatedAt: clock(),
				convertTimeZones: convertTimeZones ?? injected(Settings.self).convertTimeZones)
			statusText = "Interpretation only. No records have been read."
		} catch {
			explanation = nil
			statusText = "This query cannot be explained safely. Check its conditions in the builder."
		}
		updateButton(); rebuildRows()
	}

	private func previewError() -> Error { NSError(domain: "QueryInspectionPreview", code: 1) }

	private func updateButton() {
		inspectButton?.title = isInspecting ? "Cancel" : "Inspect Counts"
		inspectButton?.accessibilityLabel = isInspecting ? "Cancel query inspection" : "Inspect condition counts"
		inspectButton?.isEnabled = query != nil && explanation != nil
	}

	private func rebuildRows() {
		let disclosure = "Inspect Counts reads all available records for each data type in this query on this device to compare conditions. It does not change your query or its results. No data is sent to an online service."
		sections = [Section(title: "On-device explanation", rows: [
			Row(id: "status", text: statusText, details: disclosure, depth: 0),
		])]
		if let explanation = explanation { append(explanation, isReference: false) }
		if let report = report, !report.diagnostics.isEmpty {
			sections.append(Section(title: "Diagnostics", rows: report.diagnostics.enumerated().map {
				Row(id: "diagnostic.\($0.offset)", text: $0.element, details: "", depth: 0)
			}))
		}
		if isViewLoaded { tableView.reloadData() }
	}

	private func append(_ stage: QueryExplanation, isReference: Bool) {
		var rows = [Row(id: stage.path + "/all", text: "All available \(stage.sampleTypeName.lowercased()) records",
			details: countText(stage.path + "/all"), depth: 0)]
		rows.append(Row(id: stage.path + "/results", text: "Complete \(isReference ? "reference " : "")query",
			details: countText(stage.path + "/results"), depth: 0))
		if let root = stage.root { append(root, depth: 0, to: &rows) }
		if let matcher = stage.matcherDescription {
			rows.append(Row(id: stage.path + "/matcher", text: "Relationship to reference records", details: matcher, depth: 0))
		}
		for (index, note) in stage.notes.enumerated() {
			rows.append(Row(id: stage.path + "/note.\(index)", text: note, details: "", depth: 0))
		}
		sections.append(Section(title: stage.sampleTypeName + (isReference ? " · Reference query" : " · Results"), rows: rows))
		if let child = stage.subquery { append(child, isReference: true) }
	}

	private func append(_ node: QueryExplanationNode, depth: Int, to rows: inout [Row]) {
		let details = node.details + [countText(node.path)]
		rows.append(Row(id: node.path, text: node.text, details: details.filter { !$0.isEmpty }.joined(separator: "\n"), depth: depth))
		for child in node.children { append(child, depth: depth + 1, to: &rows) }
	}

	private func countText(_ path: String) -> String {
		guard let count = report?.counts[path] else { return "Count not inspected." }
		var text = "\(count.matched) matching record\(count.matched == 1 ? "" : "s")."
		if let matches = count.selectedRecordMatches {
			text += matches ? " Selected record: matches." : " Selected record: does not match this condition in this snapshot."
		}
		return text
	}

	override func numberOfSections(in tableView: UITableView) -> Int { sections.count }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].rows.count }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { sections[section].title }
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = sections[indexPath.section].rows[indexPath.row]
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.textLabel?.text = row.text; cell.textLabel?.numberOfLines = 0
		cell.detailTextLabel?.text = row.details; cell.detailTextLabel?.numberOfLines = 0
		cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline)
		cell.textLabel?.adjustsFontForContentSizeCategory = true
		cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
		cell.indentationLevel = min(row.depth, 8)
		cell.selectionStyle = .none
		cell.accessibilityIdentifier = "queryExplanation." + row.id
		cell.isAccessibilityElement = true
		cell.accessibilityLabel = [row.text, row.details].filter { !$0.isEmpty }.joined(separator: ". ")
		return cell
	}
}
