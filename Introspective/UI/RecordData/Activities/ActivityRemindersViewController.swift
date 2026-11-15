import UIKit
import UserNotifications
import Common
import Samples
import UIExtensions

final class ActivityRemindersViewController: UITableViewController {
	var preferences: ActivityReminderPreferences = .shared
	var refreshReminders: (@escaping (Error?) -> Void) -> Void = { completion in
		ActivityReminderService.refresh(completion: completion)
	}
	var requestAuthorization: (@escaping (Bool, Error?) -> Void) -> Void = { completion in
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: completion)
	}
	private var settings = ActivityReminderSettings()
	private var canSave = true
	private var saving = false

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Activity Reminders"
		tableView.accessibilityIdentifier = "activityReminders"
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 54
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
		do { settings = try preferences.settings() }
		catch {
			canSave = false
			navigationItem.rightBarButtonItem?.isEnabled = false
			showError(title: "Could not load activity reminders", error: error)
		}
	}

	override func numberOfSections(in tableView: UITableView) -> Int { 2 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		section == 0 ? 1 : ActivityReminderSettings.allowedIntervals.count
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		section == 0 ? "Still doing this?" : "Prompt interval"
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		section == 0
			? "Optional reminders ask about running activities. Activity names and notes do not appear in notifications. Changes apply when you tap Save."
			: "Each running activity gets one prompt. Continue schedules another after this interval. Stop now ends that timer; End earlier opens its time editor. Ignoring a prompt does not create repeated reminders."
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.textLabel?.adjustsFontForContentSizeCategory = true
		cell.textLabel?.numberOfLines = 0
		if indexPath.section == 0 {
			cell.textLabel?.text = "Enable activity reminders"
			let toggle = UISwitch()
			toggle.isOn = settings.enabled
			toggle.isEnabled = canSave && !saving
			toggle.accessibilityIdentifier = "activityRemindersEnabled"
			toggle.accessibilityLabel = "Enable activity reminders"
			toggle.addTarget(self, action: #selector(enabledChanged), for: .valueChanged)
			cell.accessoryView = toggle
			cell.selectionStyle = .none
		} else {
			let minutes = ActivityReminderSettings.allowedIntervals[indexPath.row]
			cell.textLabel?.text = minutes < 60 ? "\(minutes) minutes" : minutes == 60 ? "1 hour" : "\(minutes / 60) hours"
			cell.accessibilityIdentifier = "activityReminderInterval\(minutes)"
			cell.accessoryType = settings.intervalMinutes == minutes ? .checkmark : .none
		}
		return cell
	}

	@objc private func enabledChanged(_ toggle: UISwitch) { settings.enabled = toggle.isOn }
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		guard canSave, !saving, indexPath.section == 1 else { return }
		settings.intervalMinutes = ActivityReminderSettings.allowedIntervals[indexPath.row]
		tableView.reloadSections(IndexSet(integer: 1), with: .none)
	}

	@objc private func save() {
		guard canSave, !saving else { return }
		do { try settings.validate() }
		catch { showError(title: "Check activity reminders", error: error); return }
		saving = true
		navigationItem.rightBarButtonItem?.isEnabled = false
		tableView.isUserInteractionEnabled = false
		guard settings.enabled else { persist(); return }
		requestAuthorization { [weak self] granted, error in
			DispatchQueue.main.async {
				guard let self = self else { return }
				guard granted, error == nil else {
					self.finishSaving()
					self.showError(title: "Notifications unavailable", message: "Allow notifications for Introspective in iOS Settings to enable activity reminders.")
					return
				}
				self.persist()
			}
		}
	}

	private func persist() {
		do {
			try preferences.save(settings: settings)
			refreshReminders { [weak self] error in
				DispatchQueue.main.async {
					guard let self = self else { return }
					self.finishSaving()
					if let error = error { self.showError(title: "Could not schedule activity reminders", error: error) }
					else { self.navigationController?.popViewController(animated: true) }
				}
			}
		} catch {
			finishSaving()
			showError(title: "Could not save activity reminders", error: error)
		}
	}
	private func finishSaving() {
		saving = false
		tableView.isUserInteractionEnabled = true
		navigationItem.rightBarButtonItem?.isEnabled = canSave
		tableView.reloadData()
	}
}
