import UIKit
import HealthKit
import Common
import Samples
import DependencyInjection
import Persistence

/// Descriptive Health measurements, not an inferred attention or rest score.
final class ActivityLevelsViewController: UITableViewController {
	private let period = UISegmentedControl(items: ["Today", "7 Days", "30 Days"])
	private let store = HKHealthStore()
	private var queries: [HKQuery] = []
	private var generation = UUID()
	private var values = ["—", "—", "—"]
	private var status = ""
	private var contextCounts: [Int?] = [nil, nil, nil]
	private let metrics: [ContextMetric] = [.activeEnergy, .steps, .workouts]
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
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Context", style: .plain, target: self, action: #selector(showAllContext))
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
	private func selectedInterval() -> DateInterval {
		DateInterval(start: MoodReviewSummary.dateInterval(forLastDays: [1, 7, 30][period.selectedSegmentIndex]).start, end: Date())
	}
	@objc private func showAllContext() { showContext(.all) }
	private func showContext(_ metric: ContextMetric) {
		navigationController?.pushViewController(MetricContextViewController(metric: metric, interval: selectedInterval()), animated: true)
	}
	@objc private func load() {
		cancelQueries()
		let token = generation
		values = ["Loading…", "Loading…", "Loading…"]; status = ""
		let contextInterval = selectedInterval()
		contextCounts = metrics.map { try? injected(Database.self).count(MetricContextEntry.request(metric: $0, interval: contextInterval)) }
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
	override func numberOfSections(in tableView: UITableView) -> Int { metrics.count }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		metrics[section].limitations + " Missing Health data may mean no records or denied access. Tap to review or add dated context." + (status.isEmpty ? "" : " " + status)
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "activity-level") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "activity-level")
		let index = indexPath.section
		cell.textLabel?.text = metrics[index].title
		cell.detailTextLabel?.text = values[index] + " · " + (contextCounts[index].map { "\($0) context entries" } ?? "Context unavailable")
		cell.detailTextLabel?.numberOfLines = 0; cell.accessoryType = .disclosureIndicator
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		showContext(metrics[indexPath.section])
	}
}
