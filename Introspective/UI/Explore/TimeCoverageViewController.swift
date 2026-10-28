import UIKit
import CoreData
import HealthKit
import Common
import DependencyInjection
import Persistence
import Samples

final class TimeCoverageViewController: UITableViewController {
	private let date = UIDatePicker()
	private let period = UISegmentedControl(items: ["Day", "7 Days", "30 Days"])
	private let sleep = UISwitch()
	private var summary: TimeCoverageSummary?
	private var generation = UUID()
	private var stop: (() -> Void)?

	deinit { stop?() }

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Time Coverage"
		date.datePickerMode = .date
		date.maximumDate = Date()
		period.selectedSegmentIndex = 0
		let label = UILabel(); label.text = "Include sleep from Health"
		let sleepRow = UIStackView(arrangedSubviews: [label, sleep])
		sleepRow.distribution = .equalSpacing
		let stack = UIStackView(arrangedSubviews: [date, period, sleepRow])
		stack.axis = .vertical; stack.spacing = 12
		stack.translatesAutoresizingMaskIntoConstraints = false
		let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
		header.addSubview(stack)
		NSLayoutConstraint.activate([stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
			stack.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
			stack.topAnchor.constraint(equalTo: header.topAnchor, constant: 8)])
		tableView.tableHeaderView = header
		for control in [date as UIControl, period, sleep] { control.addTarget(self, action: #selector(reloadCoverage), for: .valueChanged) }
		date.accessibilityLabel = "Coverage end date"
		sleep.accessibilityLabel = "Include sleep from Health"
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		reloadCoverage()
	}

	@objc private func reloadCoverage() {
		stop?(); stop = nil
		generation = UUID()
		let token = generation
		let calendar = Calendar.current
		let day = calendar.startOfDay(for: date.date)
		let start = calendar.date(byAdding: .day, value: 1 - [1, 7, 30][period.selectedSegmentIndex], to: day)!
		let end = min(Date(), calendar.date(byAdding: .day, value: 1, to: day)!)
		guard end > start else { return }
		let window = DateInterval(start: start, end: end)
		do {
			let request = Activity.fetchRequest()
			request.predicate = NSPredicate(format: "startDate < %@ AND (endDate == nil OR endDate > %@)", end as NSDate, start as NSDate)
			let activities = try injected(Database.self).query(request)
			let intervals = activities.compactMap { activity -> DateInterval? in
				let end = activity.end ?? window.end
				return end > activity.start ? DateInterval(start: activity.start, end: end) : nil
			}
			guard sleep.isOn else { show(window, intervals); return }
			summary = nil; tableView.reloadData()
			let type = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
			HKHealthStore().requestAuthorization(toShare: [], read: [type]) { [weak self] _, error in
				DispatchQueue.main.async {
					guard let self = self, self.generation == token else { return }
					if let error = error { self.showError(title: "Could not read sleep", error: error); return }
					self.stop = injected(HealthKitUtil.self).getSamples(for: Sleep.self, from: start, to: end) { [weak self] samples, error in
						DispatchQueue.main.async {
							guard let self = self, self.generation == token else { return }
							self.stop = nil
							if let error = error { self.showError(title: "Could not read sleep", error: error); return }
							let asleep = (samples ?? []).compactMap { $0 as? HKCategorySample }.filter { sample in
								if #available(iOS 16.0, *) {
									return [HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue, HKCategoryValueSleepAnalysis.asleepCore.rawValue,
										HKCategoryValueSleepAnalysis.asleepDeep.rawValue, HKCategoryValueSleepAnalysis.asleepREM.rawValue].contains(sample.value)
								}
								return sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue
							}.filter { $0.endDate > $0.startDate }.map { DateInterval(start: $0.startDate, end: $0.endDate) }
							self.show(window, intervals + asleep)
						}
					}
				}
			}
		} catch { showError(title: "Could not calculate coverage", error: error) }
	}

	private func show(_ window: DateInterval, _ intervals: [DateInterval]) {
		summary = TimeCoverageSummary(interval: window, recordedIntervals: intervals)
		tableView.reloadData()
	}
	override func numberOfSections(in tableView: UITableView) -> Int { 2 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		section == 0 ? 2 : (summary?.gaps.count ?? 0)
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		section == 0 ? "Coverage" : "Unaccounted intervals"
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		guard section == 0 else { return nil }
		return "Recorded activities count once even when they overlap. Ongoing activities extend to the end of the selected period, capped at now. " +
			(sleep.isOn ? "Sleep includes only asleep records available from Health. No sleep records may also mean read access was denied." : "Sleep is excluded. Enable Health sleep to include it.")
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.selectionStyle = .none
		cell.textLabel?.numberOfLines = 0
		if indexPath.section == 0 {
			cell.textLabel?.text = indexPath.row == 0 ? "Accounted time" : "Unaccounted time"
			cell.detailTextLabel?.text = summary.map { TimeDuration(indexPath.row == 0 ? $0.covered : $0.unaccounted).description } ?? "Loading…"
		} else if let gap = summary?.gaps[indexPath.row] {
			let formatter = DateFormatter(); formatter.dateStyle = .short; formatter.timeStyle = .short
			cell.textLabel?.text = formatter.string(from: gap.start) + " – " + formatter.string(from: gap.end)
			cell.detailTextLabel?.text = TimeDuration(gap.duration).description
		}
		return cell
	}
}
