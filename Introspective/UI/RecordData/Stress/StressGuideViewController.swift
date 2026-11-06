import UIKit

/// Practical, replayable help without a mandatory modal tutorial.
final class StressGuideViewController: UITableViewController {
	private let topics: [(title: String, body: String)] = [
		("Choose the amount of detail", "Overall stress works on its own. Add any number of personal stressors that are useful to you. Starting with a few, such as one to three, can make regular check-ins easier. You can archive a stressor whenever you want; its earlier ratings remain in history."),
		("Rate how you feel right now", "Use the same question each time: how much stress are you feeling right now? The anchors run from None to Overwhelming. Each personal rating asks how much stress that situation is causing you right now. None is an explicit zero. Not applicable and Skipped are separate states, and missing check-ins are never zero ratings."),
		("Evaluate a change", "For example, record before and after a workplace adjustment, a change in support, or a new routine. In Stress Review, compare periods around a date and review overall stress alongside the relevant personal stressor. Check the recorded dates and how often you answered. Other changes may also affect the pattern, so the comparison does not establish a cause."),
		("Prepare for an appointment", "Review a period before your appointment. Look at recorded dates, recurring pressures and notes, then choose the examples and questions you want to discuss. A summary can help describe your experience; it is not a diagnosis or a validated clinical score. You control whether to export any records."),
		("Keep history interpretable", "Renaming a personal stressor changes future check-ins. Earlier check-ins keep the name they had when recorded. Overall stress and personal stressors are reviewed individually; the app does not add stressor ratings into a total. A day with more check-ins is not automatically a more stressful day."),
		("Choose reminders and privacy", "Reminders are optional. Stress reminders use generic notification text without personal stressor names, ratings or notes. Check-in records and review calculations stay on your device. Use the app's export controls only when you choose to share data."),
	]
	override func viewDidLoad() {
		super.viewDidLoad(); title = "Stress Check-in Guide"
		tableView.accessibilityIdentifier = "stressGuide"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 180
	}
	override func numberOfSections(in tableView: UITableView) -> Int { topics.count }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { topics[section].title }
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "guide") ?? UITableViewCell(style: .default, reuseIdentifier: "guide")
		cell.selectionStyle = .none; cell.textLabel?.text = topics[indexPath.section].body
		cell.textLabel?.numberOfLines = 0; cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.textLabel?.adjustsFontForContentSizeCategory = true
		return cell
	}
}
