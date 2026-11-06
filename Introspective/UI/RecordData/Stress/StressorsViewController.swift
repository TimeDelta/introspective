import UIKit
import Common
import Samples

/// Definitions are archived, so past check-ins retain their IDs and original name snapshots.
final class StressorsViewController: UITableViewController {
	var loadDefinitions: () throws -> [StressorDefinition] = { try StressTrackingStore.definitions(includeArchived: true) }
	var createDefinition: (String) throws -> Void = { _ = try StressTrackingStore.createStressor(name: $0) }
	var renameDefinition: (UUID, String) throws -> Void = { try StressTrackingStore.renameStressor(id: $0, to: $1) }
	var archiveDefinition: (UUID, Bool) throws -> Void = { try StressTrackingStore.setArchived(id: $0, archived: $1) }
	var reorderDefinitions: ([UUID]) throws -> Void = { try StressTrackingStore.reorderStressors(ids: $0) }
	private(set) var active: [StressorDefinition] = []
	private(set) var archived: [StressorDefinition] = []
	private var loadError: String?

	override func viewDidLoad() {
		super.viewDidLoad(); title = "Personal Stressors"
		tableView.accessibilityIdentifier = "stressors"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 56
		navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addStressor)), editButtonItem]
		refreshControl = UIRefreshControl(); refreshControl?.addTarget(self, action: #selector(reloadDefinitions), for: .valueChanged)
	}
	override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); reloadDefinitions() }
	@objc func reloadDefinitions() {
		defer { refreshControl?.endRefreshing(); tableView.reloadData() }
		do {
			let definitions = try loadDefinitions()
			active = definitions.filter { !$0.archived }; archived = definitions.filter { $0.archived }
			loadError = nil
		} catch {
			active = []; archived = []
			loadError = "Could not load personal stressors. Pull to refresh to try again."
		}
	}
	override func numberOfSections(in tableView: UITableView) -> Int { 2 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { section == 0 ? active.count : archived.count }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		section == 0 ? "Included in new check-ins · \(active.count)" : "Archived · \(archived.count)"
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if let error = loadError { return section == 0 ? error : nil }
		if section == 0 {
			return "You decide how many stressors to track. Start with a few, such as one to three, and add only what helps you. Tap + to add; tap a name to rename or archive. Use Edit to reorder. Overall stress is available without any personal stressors."
		}
		return "Archived stressors are left out of new check-ins. Earlier ratings and their original names remain in history. Tap an archived stressor to include it again."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "stressor") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "stressor")
		let definition = (indexPath.section == 0 ? active : archived)[indexPath.row]
		cell.textLabel?.text = definition.name; cell.textLabel?.numberOfLines = 0
		cell.textLabel?.font = .preferredFont(forTextStyle: .body); cell.textLabel?.adjustsFontForContentSizeCategory = true
		cell.detailTextLabel?.text = indexPath.section == 0 ? "Included in new check-ins" : "Archived — tap to restore"
		cell.detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline); cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
		cell.detailTextLabel?.numberOfLines = 0; cell.accessoryType = .disclosureIndicator
		cell.accessibilityIdentifier = "stressor.\(definition.id.uuidString)"
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		let definition = (indexPath.section == 0 ? active : archived)[indexPath.row]
		if indexPath.section == 1 { setArchived(definition.id, archived: false) }
		else { showNameEditor(definition) }
	}
	@objc private func addStressor() { showNameEditor(nil) }
	private func showNameEditor(_ definition: StressorDefinition?) {
		let alert = UIAlertController(title: definition == nil ? "Add Personal Stressor" : "Edit Personal Stressor",
			message: "Choose a short name that makes sense to you. Changes to the name apply to future check-ins.", preferredStyle: .alert)
		alert.addTextField { field in field.text = definition?.name; field.placeholder = "For example, work or caregiving"; field.accessibilityIdentifier = "stressorName" }
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
			guard let name = alert?.textFields?.first?.text else { return }
			alert?.dismiss(animated: false) { [weak self] in self?.saveName(name, id: definition?.id) }
		})
		if let definition = definition {
			alert.addAction(UIAlertAction(title: "Archive", style: .default) { [weak self, weak alert] _ in
				alert?.dismiss(animated: false) { [weak self] in self?.setArchived(definition.id, archived: true) }
			})
		}
		present(alert, animated: true)
	}
	func saveName(_ name: String, id: UUID?) {
		do {
			if let id = id { try renameDefinition(id, name) } else { try createDefinition(name) }
			reloadDefinitions()
		} catch { showError(title: "Could not save stressor", error: error) }
	}
	func setArchived(_ id: UUID, archived: Bool) {
		do { try archiveDefinition(id, archived); reloadDefinitions() }
		catch { showError(title: "Could not update stressor", error: error) }
	}
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { indexPath.section == 0 }
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { .none }
	override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { false }
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { indexPath.section == 0 && active.count > 1 }
	override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
		toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
		IndexPath(row: min(proposedDestinationIndexPath.row, max(0, active.count - 1)), section: 0)
	}
	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		guard sourceIndexPath.section == 0, destinationIndexPath.section == 0,
			active.indices.contains(sourceIndexPath.row), active.indices.contains(destinationIndexPath.row) else { reloadDefinitions(); return }
		let moved = active.remove(at: sourceIndexPath.row); active.insert(moved, at: destinationIndexPath.row)
		do { try reorderDefinitions(active.map { $0.id }); reloadDefinitions() }
		catch { reloadDefinitions(); showError(title: "Could not reorder stressors", error: error) }
	}
}
