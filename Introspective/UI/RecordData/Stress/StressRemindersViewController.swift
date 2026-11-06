import UIKit
import UserNotifications
import Common
import Samples

final class StressRemindersViewController: UITableViewController {
	var preferences: StressReminderPreferences = .shared
	var scheduler: StressReminderScheduler = .shared
	var requestAuthorization: (@escaping (Bool, Error?) -> Void) -> Void = { completion in
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: completion)
	}
	private var settings = StressReminderSettings()
	private let formatter: DateFormatter = {
		let value = DateFormatter(); value.timeStyle = .short; value.timeZone = TimeZone(secondsFromGMT: 0); return value
	}()

	override func viewDidLoad() {
		super.viewDidLoad(); title = "Stress Reminders"
		tableView.accessibilityIdentifier = "stressReminders"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 54
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
		do { settings = try preferences.reminders() }
		catch { navigationItem.rightBarButtonItem?.isEnabled = false; showError(title: "Could not load reminders", error: error) }
	}
	override func numberOfSections(in tableView: UITableView) -> Int { 4 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { section == 2 ? 3 : 1 }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		["Reminders", "Daily time", "Quiet hours", "After a stress check-in"][section]
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		switch section {
		case 0: return "Optional notifications use generic check-in text. Stressor names, ratings and notes do not appear. Changes apply when you tap Save."
		case 1: return "One daily prompt schedules the next 14 days. Reopen the app at least every 14 days to continue reminders. Opening the app also refreshes for your current time zone."
		case 2: return "Choose a reminder time outside quiet hours. Local calendar dates and daylight-saving changes are respected."
		default: return "Skip the rest of a day after a stress check-in is recorded for that day. Recording a mood does not suppress stress reminders. Backdated entries do not complete today."
		}
	}
	private func time(_ minute: Int) -> String { formatter.string(from: Date(timeIntervalSince1970: Double(minute * 60))) }
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
		cell.textLabel?.numberOfLines = 0; cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.textLabel?.adjustsFontForContentSizeCategory = true
		if indexPath.section == 1 || (indexPath.section == 2 && indexPath.row > 0) {
			cell.textLabel?.text = indexPath.section == 1 ? "Reminder time" : indexPath.row == 1 ? "Start" : "End"
			cell.detailTextLabel?.text = time(indexPath.section == 1 ? settings.minute : indexPath.row == 1 ? settings.quietStart : settings.quietEnd)
			cell.accessoryType = .disclosureIndicator
		} else {
			let toggle = UISwitch(); toggle.tag = indexPath.section
			let title: String
			if indexPath.section == 0 { title = "Enable stress reminders"; toggle.isOn = settings.enabled }
			else if indexPath.section == 2 { title = "Enable quiet hours"; toggle.isOn = settings.quietHoursEnabled }
			else { title = "Skip recorded stress days"; toggle.isOn = settings.skipRecordedDays }
			cell.textLabel?.text = title; cell.selectionStyle = .none
			toggle.accessibilityLabel = title; toggle.accessibilityIdentifier = "stressReminderToggle\(indexPath.section)"
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
		let initial = indexPath.section == 1 ? settings.minute : indexPath.row == 1 ? settings.quietStart : settings.quietEnd
		let controller = StressReminderTimeViewController(minute: initial) { [weak self] minute in
			guard let self = self else { return }
			if indexPath.section == 1 { self.settings.minute = minute }
			else if indexPath.row == 1 { self.settings.quietStart = minute }
			else { self.settings.quietEnd = minute }
			self.tableView.reloadData()
		}
		navigationController?.pushViewController(controller, animated: true)
	}
	@objc private func save() {
		do { try settings.validate() } catch { showError(title: "Check reminder time", error: error); return }
		guard settings.enabled else { persist(); return }
		navigationItem.rightBarButtonItem?.isEnabled = false
		requestAuthorization { [weak self] granted, error in
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
			StressReminderService.refresh(preferences: preferences, scheduler: scheduler) { [weak self] error in
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

private final class StressReminderTimeViewController: UIViewController {
	let picker = UIDatePicker()
	let initial: Int
	let accept: (Int) -> Void
	init(minute: Int, accept: @escaping (Int) -> Void) { initial = minute; self.accept = accept; super.init(nibName: nil, bundle: nil) }
	required init?(coder: NSCoder) { fatalError("Use init(minute:accept:)") }
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Choose Time"; view.backgroundColor = .systemBackground
		picker.datePickerMode = .time; picker.preferredDatePickerStyle = .wheels; picker.timeZone = TimeZone(secondsFromGMT: 0)
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
