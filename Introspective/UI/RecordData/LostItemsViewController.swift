import UIKit
import CoreData
import Common
import DependencyInjection
import Persistence
import Samples

final class LostItemsViewController: UITableViewController {
	private let period = UISegmentedControl(items: ["7 Days", "30 Days", "All Time"])
	private var events: [LostItemEvent] = []
	private var lost = 0
	private var found = 0
	private var balance = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Lost Items"
		navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Lost +1", style: .plain, target: self, action: #selector(recordLost)),
			UIBarButtonItem(title: "Found −1", style: .plain, target: self, action: #selector(recordFound))]
		period.selectedSegmentIndex = 0
		period.addTarget(self, action: #selector(reloadEvents), for: .valueChanged)
		period.frame = CGRect(x: 16, y: 8, width: view.bounds.width - 32, height: 36)
		let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 52))
		header.addSubview(period); tableView.tableHeaderView = header
	}
	override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); reloadEvents() }
	@objc private func recordLost() { record(1) }
	@objc private func recordFound() { record(-1) }
	private func record(_ change: Int) {
		do { try LostItemEvent.record(change: change); navigationItem.prompt = change > 0 ? "Lost item recorded" : "Found item recorded"; reloadEvents() }
		catch { showError(title: "Could not record item", error: error) }
	}
	@objc private func reloadEvents() {
		do {
			let database = injected(Database.self)
			let start = period.selectedSegmentIndex == 2 ? nil : MoodReviewSummary.dateInterval(forLastDays: [7, 30][period.selectedSegmentIndex]).start
			func count(_ change: Int, from start: Date?) throws -> Int {
				let request = LostItemEvent.fetchRequest()
				request.predicate = start.map { NSPredicate(format: "delta == %d AND timestamp >= %@", change, $0 as NSDate) } ?? NSPredicate(format: "delta == %d", change)
				return try database.count(request)
			}
			lost = try count(1, from: start); found = try count(-1, from: start)
			if period.selectedSegmentIndex == 2 { balance = lost - found }
			else { balance = try count(1, from: nil) - count(-1, from: nil) }
			let request = LostItemEvent.fetchRequest()
			request.predicate = start.map { NSPredicate(format: "timestamp >= %@", $0 as NSDate) }
			request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
			request.fetchLimit = 200
			events = try database.query(request)
			tableView.reloadData()
		} catch { showError(title: "Could not load lost items", error: error) }
	}
	override func numberOfSections(in tableView: UITableView) -> Int { 2 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { section == 0 ? 2 : events.count }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { section == 0 ? "Summary" : "Recent events" }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		section == 0 ? "Net recorded losses include all time and may be negative if earlier losses were not logged. Tap an event to add a note; swipe to remove an accidental entry." : "Showing up to 200 recent events. Summary counts include all matching events."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let identifier = "LostItemEventCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
		cell.selectionStyle = indexPath.section == 0 && indexPath.row == 0 ? .none : .default
		cell.accessoryType = .none
		cell.textLabel?.numberOfLines = 0
		cell.detailTextLabel?.numberOfLines = 0
		if indexPath.section == 0 && indexPath.row == 1 {
			cell.textLabel?.text = "Context and limitations"
			cell.detailTextLabel?.text = ContextMetric.lostItems.limitations
			cell.accessoryType = .disclosureIndicator
		} else if indexPath.section == 0 {
			cell.textLabel?.text = "Lost: \(lost) · Found: \(found)"
			cell.detailTextLabel?.text = "Net recorded losses (all time): \(balance)"
		} else {
			let event = events[indexPath.row]
			cell.textLabel?.text = event.description + (event.note.map { " · " + $0 } ?? "")
			cell.detailTextLabel?.text = injected(CalendarUtil.self).string(for: event.timestamp, dateStyle: .medium, timeStyle: .short)
		}
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		if indexPath.section == 0 && indexPath.row == 1 {
			let start = period.selectedSegmentIndex == 2 ? nil : MoodReviewSummary.dateInterval(forLastDays: [7, 30][period.selectedSegmentIndex]).start
			navigationController?.pushViewController(MetricContextViewController(metric: .lostItems, interval: start.map { DateInterval(start: $0, end: Date()) }, tracksPresent: true), animated: true)
			return
		}
		guard indexPath.section == 1 else { return }
		let event = events[indexPath.row]
		let alert = UIAlertController(title: "Event note", message: nil, preferredStyle: .alert)
		alert.addTextField { $0.text = event.note; $0.placeholder = "What was lost or found?" }
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
			guard let alert = alert else { return }
			let note = alert.textFields?.first?.text
			alert.dismiss(animated: false) { [weak self] in
				guard let self = self else { return }
				do {
					let transaction = try injected(Database.self).viewContextTransaction(for: LostItemEvent.self, sortedBy: "timestamp")
					try transaction.pull(savedObject: event).note = note
					try transaction.commit(); self.reloadEvents()
				} catch { self.showError(title: "Could not save note", error: error) }
			}
		})
		present(alert, animated: true)
	}
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { indexPath.section == 1 }
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		let event = events[indexPath.row]
		let alert = UIAlertController(title: "Delete this event?", message: "This corrects the lost/found counts.", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self, weak alert] _ in
			alert?.dismiss(animated: false) { [weak self] in
				guard let self = self else { return }
				do {
					let transaction = try injected(Database.self).viewContextTransaction(for: LostItemEvent.self, sortedBy: "timestamp")
					try transaction.delete(event); try transaction.commit(); self.reloadEvents()
				} catch { self.showError(title: "Could not delete event", error: error) }
			}
		})
		present(alert, animated: true)
	}
}
