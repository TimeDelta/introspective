import UIKit
import UserNotifications
import Common
import Samples

final class MoodRemindersViewController: UITableViewController {
	var preferences: MoodTrackingPreferences = .shared
	private var settings = MoodReminderSettings()
	private let formatter: DateFormatter = {
		let value = DateFormatter(); value.timeStyle = .short; value.timeZone = TimeZone(secondsFromGMT: 0); return value
	}()
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Mood Reminders"; tableView.accessibilityIdentifier = "moodReminders"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
		do { settings = try preferences.reminders() }
		catch { showError(title: "Could not load reminders", error: error) }
	}
	override func numberOfSections(in tableView: UITableView) -> Int { 4 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section { case 0, 3: return 1; case 1: return settings.times.count + (settings.times.count < 3 ? 1 : 0); default: return 3 }
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { ["Reminders", "Daily times", "Quiet hours", "After a check-in"][section] }
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		switch section {
		case 0: return "Optional local notifications use generic text, without ratings, preset names or notes. Changes apply when you tap Save."
		case 1: return "Up to three daily times. Schedules the next 14 days and refreshes when you open the app or record a check-in. Reopen the app at least every 14 days to continue reminders."
		case 2: return "Reminder times must be outside quiet hours. Local dates and daylight-saving changes are respected; opening the app refreshes the schedule after a time-zone change."
		default: return "Skip the rest of a day after any mood is recorded for that day. Backdated entries do not suppress today's prompts. No streaks or missed-day penalties."
		}
	}
	private func time(_ minute: Int) -> String {
		// These are wall-clock choices, not instants on today's possibly shortened DST day.
		formatter.string(from: Date(timeIntervalSince1970: Double(minute * 60)))
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
		if indexPath.section == 1 {
			if indexPath.row < settings.times.count { cell.textLabel?.text = time(settings.times[indexPath.row]) }
			else { cell.textLabel?.text = "Add time" }
			cell.accessoryType = .disclosureIndicator
		} else if indexPath.section == 2 && indexPath.row > 0 {
			cell.textLabel?.text = indexPath.row == 1 ? "Start" : "End"
			cell.detailTextLabel?.text = time(indexPath.row == 1 ? settings.quietStart : settings.quietEnd)
			cell.accessoryType = .disclosureIndicator
		} else {
			let toggle = UISwitch(); toggle.tag = indexPath.section
			let title: String
			if indexPath.section == 0 { title = "Enable reminders"; toggle.isOn = settings.enabled }
			else if indexPath.section == 2 { title = "Enable quiet hours"; toggle.isOn = settings.quietHoursEnabled }
			else { title = "Skip recorded days"; toggle.isOn = settings.skipRecordedDays }
			cell.textLabel?.text = title; toggle.accessibilityLabel = title
			toggle.addTarget(self, action: #selector(changed), for: .valueChanged); cell.accessoryView = toggle
		}
		return cell
	}
	@objc private func changed(_ toggle: UISwitch) {
		switch toggle.tag { case 0: settings.enabled = toggle.isOn; case 2: settings.quietHoursEnabled = toggle.isOn; default: settings.skipRecordedDays = toggle.isOn }
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		guard indexPath.section == 1 || (indexPath.section == 2 && indexPath.row > 0) else { return }
		let initial = indexPath.section == 1 ? (indexPath.row < settings.times.count ? settings.times[indexPath.row] : 12 * 60) : (indexPath.row == 1 ? settings.quietStart : settings.quietEnd)
		let controller = MoodReminderTimeViewController(minute: initial) { [weak self] minute in
			guard let self = self else { return }
			if indexPath.section == 1 {
				if indexPath.row < self.settings.times.count { self.settings.times[indexPath.row] = minute } else { self.settings.times.append(minute) }
				self.settings.times = Array(Set(self.settings.times)).sorted()
			} else if indexPath.row == 1 { self.settings.quietStart = minute } else { self.settings.quietEnd = minute }
			self.tableView.reloadData()
		}
		navigationController?.pushViewController(controller, animated: true)
	}
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		indexPath.section == 1 && indexPath.row < settings.times.count && settings.times.count > 1
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete, indexPath.section == 1, settings.times.count > 1 else { return }
		settings.times.remove(at: indexPath.row); tableView.reloadData()
	}
	@objc private func save() {
		do { try settings.validate() } catch { showError(title: "Check reminder times", error: error); return }
		guard settings.enabled else { persist(); return }
		navigationItem.rightBarButtonItem?.isEnabled = false
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { [weak self] granted, error in
			DispatchQueue.main.async {
				guard let self = self else { return }
				self.navigationItem.rightBarButtonItem?.isEnabled = true
				guard granted, error == nil else {
					self.showError(title: "Notifications unavailable", message: "Allow notifications for Introspective in iOS Settings to enable reminders.")
					return
				}
				self.persist()
			}
		}
	}
	private func persist() {
		do {
			try preferences.save(reminders: settings)
			navigationItem.rightBarButtonItem?.isEnabled = false
			MoodReminderService.refresh(preferences: preferences) { [weak self] error in
				DispatchQueue.main.async {
					guard let self = self else { return }
					self.navigationItem.rightBarButtonItem?.isEnabled = true
					if let error = error { self.showError(title: "Could not schedule reminders", error: error) }
					else { self.navigationController?.popViewController(animated: true) }
				}
			}
		} catch { showError(title: "Could not save reminders", error: error) }
	}
}

private final class MoodReminderTimeViewController: UIViewController {
	let picker = UIDatePicker()
	let initial: Int
	let accept: (Int) -> Void
	init(minute: Int, accept: @escaping (Int) -> Void) { initial = minute; self.accept = accept; super.init(nibName: nil, bundle: nil) }
	required init?(coder: NSCoder) { fatalError("Use init(minute:accept:)") }
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Choose Time"; view.backgroundColor = .systemBackground
		picker.datePickerMode = .time
		picker.timeZone = TimeZone(secondsFromGMT: 0)
		if #available(iOS 13.4, *) { picker.preferredDatePickerStyle = .wheels }
		picker.date = Date(timeIntervalSince1970: Double(initial * 60))
		picker.translatesAutoresizingMaskIntoConstraints = false; view.addSubview(picker)
		NSLayoutConstraint.activate([picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor), picker.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
	}
	@objc private func done() {
		var calendar = Calendar(identifier: .gregorian); calendar.timeZone = TimeZone(secondsFromGMT: 0)!
		let components = calendar.dateComponents([.hour, .minute], from: picker.date)
		accept((components.hour ?? 0) * 60 + (components.minute ?? 0)); navigationController?.popViewController(animated: true)
	}
}
