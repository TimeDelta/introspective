import UIKit
import HealthKit
import Common
import Samples

/// Descriptive Health measurements, not an inferred attention or rest score.
final class ActivityLevelsViewController: UITableViewController {
	private let period = UISegmentedControl(items: ["Today", "7 Days", "30 Days"])
	private let store = HKHealthStore()
	private var queries: [HKQuery] = []
	private var generation = UUID()
	private var values = ["—", "—", "—"]
	private var status = ""
	private let formatter: NumberFormatter = {
		let value = NumberFormatter()
		value.numberStyle = .decimal
		value.maximumFractionDigits = 1
		return value
	}()
	deinit { for query in queries { store.stop(query) } }
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Activity Levels"
		period.selectedSegmentIndex = 0
		period.frame = CGRect(x: 16, y: 8, width: view.bounds.width - 32, height: 36)
		let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 52))
		header.addSubview(period); tableView.tableHeaderView = header
		period.addTarget(self, action: #selector(load), for: .valueChanged)
	}
	override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); load() }
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		cancelQueries()
	}
	private func cancelQueries() {
		// Also invalidate an authorization callback that has not started its queries yet.
		generation = UUID()
		for query in queries { store.stop(query) }
		queries.removeAll()
	}
	@objc private func load() {
		cancelQueries()
		let token = generation
		values = ["Loading…", "Loading…", "Loading…"]; status = ""
		tableView.reloadData()
		guard HKHealthStore.isHealthDataAvailable() else { values = ["Unavailable", "Unavailable", "Unavailable"]; tableView.reloadData(); return }
		let types: Set<HKObjectType> = [ActiveEnergy.sampleType, Steps.sampleType, Workout.sampleType]
		store.requestAuthorization(toShare: [], read: types) { [weak self] _, error in
			DispatchQueue.main.async {
				guard let self = self, self.generation == token else { return }
				if let error = error { self.values = ["Unavailable", "Unavailable", "Unavailable"]; self.status = error.localizedDescription; self.tableView.reloadData(); return }
				let start = MoodReviewSummary.dateInterval(forLastDays: [1, 7, 30][self.period.selectedSegmentIndex]).start
				let end = Date()
				let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [.strictStartDate])
				self.sum(ActiveEnergy.quantityType, unit: .kilocalorie(), suffix: " kcal", row: 0, predicate: predicate, token: token)
				self.sum(Steps.quantityType, unit: .count(), suffix: " steps", row: 1, predicate: predicate, token: token)
				let query = HKSampleQuery(sampleType: Workout.sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, samples, error in
					// Release Health's sample array before waiting for the main queue.
					let count = samples?.count ?? 0
					DispatchQueue.main.async {
						guard let self = self, self.generation == token else { return }
						self.values[2] = error == nil ? "\(count) recorded workouts" : "Unavailable"
						self.tableView.reloadData()
					}
				}
				self.queries.append(query); self.store.execute(query)
			}
		}
	}
	private func sum(_ type: HKQuantityType, unit: HKUnit, suffix: String, row: Int, predicate: NSPredicate, token: UUID) {
		let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, error in
			DispatchQueue.main.async {
				guard let self = self, self.generation == token else { return }
				if let quantity = result?.sumQuantity(), error == nil {
					self.values[row] = (self.formatter.string(from: NSNumber(value: quantity.doubleValue(for: unit))) ?? "—") + suffix
				} else { self.values[row] = "No available data" }
				self.tableView.reloadData()
			}
		}
		queries.append(query); store.execute(query)
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 3 }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		"Active energy and steps use Health's cumulative statistics. Workouts count records started in the selected period. Missing data may mean no records or denied read access. Phone motion is not collected. These measurements describe recorded activity; device placement, exercise type, and daily circumstances affect them. They are not an ADHD or restfulness score." + (status.isEmpty ? "" : " " + status)
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "activity-level") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "activity-level")
		cell.selectionStyle = .none
		cell.textLabel?.text = ["Active Energy", "Steps", "Workouts"][indexPath.row]
		cell.detailTextLabel?.text = values[indexPath.row]
		return cell
	}
}
