//
//  TimelineTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import CoreData
import Presentr
import SwiftDate
import UIKit

import Attributes
import Common
import DependencyInjection
import SampleFetchers
import Samples
import UIExtensions

public protocol TimelineTableViewController: UITableViewController {
	/// - Note: Can always be changed by user. Default value is beginning of current day.
	var minDate: Date? { get set }
	/// - Note: Can always be changed by user. Default value is end of current day.
	var maxDate: Date? { get set }
}

public final class TimelineTableViewControllerImpl: UITableViewController, TimelineTableViewController {
	// MARK: - Static Variables

	private typealias Me = TimelineTableViewControllerImpl

	private static let log = Log(category: "Timeline")
	private static let signpost = Signpost(log: log)

	// MARK: Notification Names

	static let dateRangeSet = Notification.Name("timelineDateRangeSet")
	static let enabledDataTypesChanged = Notification.Name("timelineEnabledDataTypesChanged")
	static let sampleChanged = Notification.Name("timelineViewSampleChanged")

	// MARK: Presenters

	private static let dateFilterPresenter: Presentr = injected(UiUtil.self).customPresenter(
		width: .full,
		height: .custom(size: 300),
		center: .center
	)

	// MARK: - IBOutlets

	@IBOutlet final var previousDateRangeButton: UIBarButtonItem!
	@IBOutlet final var dateRangeButton: UIBarButtonItem!
	@IBOutlet final var nextDateRangeButton: UIBarButtonItem!

	// MARK: - Instance Variables

	public final var minDate: Date? = injected(CalendarUtil.self).start(of: .day, in: Date())
	public final var maxDate: Date? = injected(CalendarUtil.self).end(of: .day, in: Date())

	private final let fetchers: [(type: Sample.Type, fetcher: SampleFetcher)] = [
		(type: Activity.self, fetcher: injected(SampleFetcherFactory.self).activitySampleFetcher()),
		(type: BloodPressure.self, fetcher: injected(SampleFetcherFactory.self).bloodPressureSampleFetcher()),
		(type: BodyMassIndex.self, fetcher: injected(SampleFetcherFactory.self).bodyMassIndexSampleFetcher()),
		(type: DietarySugar.self, fetcher: injected(SampleFetcherFactory.self).dietarySugarSampleFetcher()),
		(type: FatigueImpl.self, fetcher: injected(SampleFetcherFactory.self).fatigueSampleFetcher()),
		(type: HeartRate.self, fetcher: injected(SampleFetcherFactory.self).heartRateSampleFetcher()),
		(type: LeanBodyMass.self, fetcher: injected(SampleFetcherFactory.self).leanBodyMassSampleFetcher()),
		(type: MedicationDose.self, fetcher: injected(SampleFetcherFactory.self).medicationDoseSampleFetcher()),
		(type: MoodImpl.self, fetcher: injected(SampleFetcherFactory.self).moodSampleFetcher()),
		(type: PainImpl.self, fetcher: injected(SampleFetcherFactory.self).painSampleFetcher()),
		(type: RestingHeartRate.self, fetcher: injected(SampleFetcherFactory.self).restingHeartRateSampleFetcher()),
		(type: SexualActivity.self, fetcher: injected(SampleFetcherFactory.self).sexualActivitySampleFetcher()),
		(type: Sleep.self, fetcher: injected(SampleFetcherFactory.self).sleepSampleFetcher()),
		(type: Steps.self, fetcher: injected(SampleFetcherFactory.self).stepsSampleFetcher()),
		(type: Weight.self, fetcher: injected(SampleFetcherFactory.self).weightSampleFetcher()),
	]

	private final var enabledSampleTypes: [String: Bool] = [
		enabledString(for: Activity.self):
			injected(UserDefaultsUtil.self).bool(forKey: .activityEnabledOnTimeline),
		enabledString(for: BloodPressure.self):
			injected(UserDefaultsUtil.self).bool(forKey: .bloodPressureEnabledOnTimeline),
		enabledString(for: BodyMassIndex.self):
			injected(UserDefaultsUtil.self).bool(forKey: .bodyMassIndexEnabledOnTimeline),
		enabledString(for: DietarySugar.self):
			injected(UserDefaultsUtil.self).bool(forKey: .dietarySugarEnabledOnTimeline),
		enabledString(for: FatigueImpl.self):
			injected(UserDefaultsUtil.self).bool(forKey: .fatigueEnabledOnTimeline),
		enabledString(for: HeartRate.self):
			injected(UserDefaultsUtil.self).bool(forKey: .heartRateEnabledOnTimeline),
		enabledString(for: LeanBodyMass.self):
			injected(UserDefaultsUtil.self).bool(forKey: .leanBodyMassEnabledOnTimeline),
		enabledString(for: MedicationDose.self):
			injected(UserDefaultsUtil.self).bool(forKey: .medicationDoseEnabledOnTimeline),
		enabledString(for: MoodImpl.self):
			injected(UserDefaultsUtil.self).bool(forKey: .moodEnabledOnTimeline),
		enabledString(for: PainImpl.self):
			injected(UserDefaultsUtil.self).bool(forKey: .painEnabledOnTimeline),
		enabledString(for: RestingHeartRate.self):
			injected(UserDefaultsUtil.self).bool(forKey: .restingHeartRateEnabledOnTimeline),
		enabledString(for: SexualActivity.self):
			injected(UserDefaultsUtil.self).bool(forKey: .sexualActivityEnabledOnTimeline),
		enabledString(for: Sleep.self):
			injected(UserDefaultsUtil.self).bool(forKey: .sleepEnabledOnTimeline),
		enabledString(for: Steps.self):
			injected(UserDefaultsUtil.self).bool(forKey: .stepsEnabledOnTimeline),
		enabledString(for: Weight.self):
			injected(UserDefaultsUtil.self).bool(forKey: .weightEnabledOnTimeline),
	]

	private var eventBuckets: [(day: Date, events: [Event])]? {
		didSet {
			DispatchQueue.main.async { self.tableView.reloadData() }
		}
	}

	private static let valueFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter
	}()

	// MARK: - UIViewController Overrides

	public override func viewDidLoad() {
		super.viewDidLoad()

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 88

		dateRangeButton.accessibilityLabel = "filter dates button"

		observe(selector: #selector(dateRangeSet), name: Me.dateRangeSet)
		observe(selector: #selector(enabledDataTypesChanged), name: Me.enabledDataTypesChanged)
		observe(selector: #selector(persistenceLayerDidRefresh), name: .persistenceLayerDidRefresh)
		observe(selector: #selector(persistenceLayerWillRefresh), name: .persistenceLayerWillRefresh)
		observe(selector: #selector(sampleChanged), name: Me.sampleChanged)

		let chooseDataTypesButton = barButton(title: "☑️ Data Types", action: #selector(chooseDataTypesButtonPressed))
		navigationItem.rightBarButtonItem = chooseDataTypesButton

		injected(UiUtil.self).setBackButton(
			for: self,
			title: navigationItem.backBarButtonItem?.title ?? "Back",
			action: #selector(goBack)
		)

		updatePreviousAndNextButtons()

		resetDateRangeButtonTitle()
		injected(AsyncUtil.self).run(qos: .userInitiated) { [weak self] in
			self?.fetchSamples()
		}
	}

	// MARK: - Table view data source

	public override func numberOfSections(in tableView: UITableView) -> Int {
		guard let eventBuckets = eventBuckets else {
			return 1
		}
		return eventBuckets.count
	}

	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let eventBuckets = eventBuckets else {
			return 1
		}
		return eventBuckets[section].events.count
	}

	// MARK: - Table view delegate

	public override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let eventBuckets = eventBuckets else { return nil }
		return injected(CalendarUtil.self).string(for: eventBuckets[section].day, dateStyle: .long, timeStyle: .none)
	}

	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let event = event(at: indexPath) else {
			return tableView.dequeueReusableCell(withIdentifier: "wait", for: indexPath)
		}
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: "timelineCell",
			for: indexPath
		) as? TimelineTableViewCell else {
			return UITableViewCell()
		}
		cell.date = event.date
		cell.descriptions = event.descriptions
		return cell
	}

	public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let event = event(at: indexPath) else {
			tableView.deselectRow(at: indexPath, animated: false)
			return
		}
		if let controller = event.delegate.editController(for: event.sample) {
			controller.notificationToSendOnAccept = Me.sampleChanged
			controller.indexPath = indexPath
			pushToNavigationController(controller)
		}
	}

	// MARK: - Actions

	@IBAction final func filterDatesButtonPressed(_: Any) {
		let controller = viewController(named: "dateRangeChooser", fromStoryboard: "Util") as! DateRangeViewController
		controller.initialFromDate = minDate
		controller.initialToDate = maxDate
		controller.datePickerMode = .date
		controller.notificationToSendOnAccept = Me.dateRangeSet
		customPresentViewController(Me.dateFilterPresenter, viewController: controller, animated: false)
	}

	@IBAction final func previousDateRangeButtonPressed(_: Any) {
		if let minDate = minDate, let maxDate = maxDate {
			let startOfMin = injected(CalendarUtil.self).start(of: .day, in: minDate)
			let startOfMax = injected(CalendarUtil.self).start(of: .day, in: maxDate)
			if startOfMin == startOfMax {
				self.minDate = minDate - 1.days
				self.maxDate = maxDate - 1.days
			} else {
				let difference = maxDate - minDate
				self.minDate = minDate - difference
				self.maxDate = maxDate - difference
			}
		} else if let maxDate = maxDate {
			self.maxDate = maxDate - 1.days
		} else if let minDate = minDate {
			self.minDate = minDate - 1.days
		}
		resetDateRangeButtonTitle()
		injected(AsyncUtil.self).run(qos: .userInitiated) { [weak self] in self?.fetchSamples() }
	}

	@IBAction final func nextDateRangeButtonPressed(_: Any) {
		if let minDate = minDate, let maxDate = maxDate {
			let startOfMin = injected(CalendarUtil.self).start(of: .day, in: minDate)
			let startOfMax = injected(CalendarUtil.self).start(of: .day, in: maxDate)
			if startOfMin == startOfMax {
				self.minDate = minDate + 1.days
				self.maxDate = maxDate + 1.days
			} else {
				let difference = maxDate - minDate
				self.minDate = minDate + difference
				self.maxDate = maxDate + difference
			}
		} else if let maxDate = maxDate {
			self.maxDate = maxDate + 1.days
		} else if let minDate = minDate {
			self.minDate = minDate + 1.days
		}
		resetDateRangeButtonTitle()
		injected(AsyncUtil.self).run(qos: .userInitiated) { [weak self] in self?.fetchSamples() }
	}

	@IBAction final func chooseDataTypesButtonPressed(_: Any) {
		let controller: MultiSelectAttributeValueViewController = viewController(
			named: "multiSelectAttribute",
			fromStoryboard: "AttributeList"
		)
		controller.multiSelectAttribute = TypedMultiSelectAttribute<String>(
			name: "Data Types",
			possibleValues: {
				injected(SampleFactory.self).allTypes().map { Me.enabledString(for: $0) }
			},
			possibleValueToString: { $0 }
		)
		controller.initialValue = enabledSampleTypes.filter { $0.value }.map { $0.key }
		controller.notificationToSendOnAccept = Me.enabledDataTypesChanged
		pushToNavigationController(controller)
	}

	@objc final func goBack() {
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: Activity.self)] ?? false,
			forKey: .activityEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: BloodPressure.self)] ?? false,
			forKey: .bloodPressureEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: BodyMassIndex.self)] ?? false,
			forKey: .bodyMassIndexEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: DietarySugar.self)] ?? false,
			forKey: .dietarySugarEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: FatigueImpl.self)] ?? false,
			forKey: .fatigueEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: HeartRate.self)] ?? false,
			forKey: .heartRateEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: LeanBodyMass.self)] ?? false,
			forKey: .leanBodyMassEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: MedicationDose.self)] ?? false,
			forKey: .medicationDoseEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: MoodImpl.self)] ?? false,
			forKey: .moodEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: PainImpl.self)] ?? false,
			forKey: .painEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: RestingHeartRate.self)] ?? false,
			forKey: .restingHeartRateEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: SexualActivity.self)] ?? false,
			forKey: .sexualActivityEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: Sleep.self)] ?? false,
			forKey: .sleepEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: Steps.self)] ?? false,
			forKey: .stepsEnabledOnTimeline
		)
		injected(UserDefaultsUtil.self).setUserDefault(
			enabledSampleTypes[Me.enabledString(for: Weight.self)] ?? false,
			forKey: .weightEnabledOnTimeline
		)
		popFromNavigationController()
	}

	// MARK: - Received Notifications

	@objc private final func persistenceLayerDidRefresh(notification _: Notification) {
		injected(AsyncUtil.self).run(qos: .userInteractive) { self.fetchSamples() }
	}

	@objc private final func persistenceLayerWillRefresh(notification _: Notification) {
		// all CoreData objects will soon be faults that cause exceptions
		eventBuckets = nil
	}

	@objc private func dateRangeSet(notification: Notification) {
		if let minDate: Date = value(for: .fromDate, from: notification) {
			self.minDate = injected(CalendarUtil.self).start(of: .day, in: minDate)
		} else {
			minDate = nil
		}
		if let maxDate: Date = value(for: .toDate, from: notification) {
			self.maxDate = injected(CalendarUtil.self).end(of: .day, in: maxDate)
		} else {
			maxDate = nil
		}
		updatePreviousAndNextButtons()
		injected(AsyncUtil.self).run(qos: .userInitiated) { [weak self] in
			self?.fetchSamples()
		}
		resetDateRangeButtonTitle()
	}

	@objc private func enabledDataTypesChanged(notification: Notification) {
		if let enabledTypes: [String] = value(for: .attributeValue, from: notification) {
			enabledSampleTypes = [String: Bool]()
			for type in enabledTypes {
				enabledSampleTypes[type] = true
			}
			injected(AsyncUtil.self).run(qos: .userInitiated) { [weak self] in
				self?.fetchSamples()
			}
		}
	}

	@objc private func sampleChanged(notification: Notification) {
//		if
//			let indexPath: IndexPath? = value(for: .indexPath, from: notification),
//			let sample: Sample = value(for: .sample, from: notification)
//		{
//			if let event = event(at: indexPath!) {
//				let originalSample = event.sample
//				// cannot force Sample to conform to Hashable due to associated type fo Equatable
//				var samples = Set<Sample>()
//				if let buckets = eventBuckets {
//					for var bucket in buckets {
//						bucket.events.removeAll(where: { $0.sample.equalTo(originalSample) })
//						samples.append(contentsOf: bucket.events.map{ $0.sample })
//					}
//				}
//				setEvents(for: samples)
//			}
//		} else {
		fetchSamples()
//		}
	}

	// MARK: - Helper Functions

	private func setEvents(for samples: [Sample]) {
		let signpostName2: StaticString = "Determining events"
		Me.signpost.begin(name: signpostName2)
		var events = [Event]()
		for sample in samples {
			appendEvents(for: sample, to: &events)
		}
		var eventsByDay = [(day: Date, events: [Event])]()
		var eventsForCurrentDay = [Event]()
		var currentDay: Date?
		let sortedEvents = sortEventsByMostRecentFirst(events)
		for event in sortedEvents {
			if let minDate = minDate {
				guard event.date >= minDate else { continue }
			}
			if let maxDate = maxDate {
				guard event.date <= maxDate else { continue }
			}
			let newDay = injected(CalendarUtil.self).start(of: .day, in: event.date)
			if newDay != currentDay {
				if let currentDay = currentDay {
					eventsByDay.append((day: currentDay, events: eventsForCurrentDay))
				}
				eventsForCurrentDay = [Event]()
				currentDay = newDay
			}
			eventsForCurrentDay.append(event)
		}
		if let currentDay = currentDay {
			eventsByDay.append((day: currentDay, events: eventsForCurrentDay))
		}
		Me.signpost.end(name: signpostName2, "Processed %d events", events.count)
		eventBuckets = eventsByDay
	}

	private func event(at indexPath: IndexPath) -> Event? {
		eventBuckets?[indexPath.section].events[indexPath.row]
	}

	private static func enabledString(for type: Sample.Type) -> String {
		type.name
	}

	private func updatePreviousAndNextButtons() {
		let enablePreviousAndNextButtons = minDate != nil || maxDate != nil
		previousDateRangeButton.isEnabled = enablePreviousAndNextButtons
		nextDateRangeButton.isEnabled = enablePreviousAndNextButtons
	}

	private func fetchSamples() {
		let signpostName1: StaticString = "Fetching samples"
		Me.signpost.begin(name: signpostName1)
		eventBuckets = nil // let ARC start cleaning up
		let fetchSync = DispatchGroup()
		var samples = [Sample]()
		for (type, fetcher) in fetchers {
			guard enabledSampleTypes[Me.enabledString(for: type)] == true else { continue }
			fetchSync.enter()
			injected(AsyncUtil.self).run(qos: .userInitiated) { [weak self] in
				do {
					let newSamples = try fetcher.getSamples(from: self?.minDate, to: self?.maxDate)
					samples.append(contentsOf: newSamples)
					fetchSync.leave()
				} catch {
					if !(error is Sample) {
						self?.showError(title: "Unable to retrieve \(fetcher.sampleTypePluralName)", error: error)
					}
				}
			}
		}
		fetchSync.wait()
		Me.signpost.end(name: signpostName1, "Fetched %d samples", samples.count)

		setEvents(for: samples)
	}

	private func sortEventsByMostRecentFirst(_ events: [Event]) -> [Event] {
		events.sorted(by: {
			let firstIsMoreRecent = $0.date > $1.date
			let stopEventFollowedByStartEventWithSameDate = $0.date == $1.date && $0 is StartEvent && $1 is StopEvent
			let wentToBedFollowedByFellAsleep = $0.date == $1.date && $0 is FellAsleepEvent && $1 is WentToBedEvent
			let wokeUpAndGotOPutOfBed = $0.date == $1.date && $0 is GotOutOfBedEvent && $1 is WokeUpEvent
			return firstIsMoreRecent ||
				stopEventFollowedByStartEventWithSameDate ||
				wentToBedFollowedByFellAsleep ||
				wokeUpAndGotOPutOfBed
		})
	}

	private func appendEvents(for sample: Sample, to events: inout [Event]) {
		if let activity = sample as? Activity {
			appendActivityEvents(for: activity, to: &events)
			return
		}
		if let bloodPressure = sample as? BloodPressure {
			appendBloodPreessureEvents(for: bloodPressure, to: &events)
			return
		}
		if let bodyMassIndex = sample as? BodyMassIndex {
			appendBodyMassIndexEvents(for: bodyMassIndex, to: &events)
			return
		}
		if let dietarySugar = sample as? DietarySugar {
			appendDietarySugar(for: dietarySugar, to: &events)
		}
		if let fatigue = sample as? Fatigue {
			appendFatigueEvents(for: fatigue, to: &events)
			return
		}
		if let heartRate = sample as? HeartRate {
			appendHeartRateEvents(for: heartRate, to: &events)
			return
		}
		if let leanBodyMass = sample as? LeanBodyMass {
			appendLeanBodyMassEvents(for: leanBodyMass, to: &events)
			return
		}
		if let mood = sample as? Mood {
			appendMoodEvents(for: mood, to: &events)
			return
		}
		if let medicationDose = sample as? MedicationDose {
			appendMedicationDoseEvents(for: medicationDose, to: &events)
			return
		}
		if let pain = sample as? Pain {
			appendPainEvents(for: pain, to: &events)
			return
		}
		if let restingHeartRate = sample as? RestingHeartRate {
			appendRestingHeartRateEvents(for: restingHeartRate, to: &events)
			return
		}
		if let sexualActivity = sample as? SexualActivity {
			appendSexualActivityEvents(for: sexualActivity, to: &events)
			return
		}
		if let sleep = sample as? Sleep {
			appendSleepEvents(for: sleep, to: &events)
			return
		}
		if let steps = sample as? Steps {
			appendStepsEvents(for: steps, to: &events)
			return
		}
		if let weight = sample as? Weight {
			appendWeightEvents(for: weight, to: &events)
			return
		}
		Me.log.error("Forgot sample type: %@", sample.attributedName)
	}

	private func appendActivityEvents(for activity: Activity, to events: inout [Event]) {
		events.append(StartActivityEvent(for: activity))
		if let stopEvent = StopActivityEvent(for: activity) {
			events.append(stopEvent)
		}
	}

	private func appendBloodPreessureEvents(for bloodPressure: BloodPressure, to events: inout [Event]) {
		events.append(BloodPressureEvent(for: bloodPressure))
	}

	private func appendBodyMassIndexEvents(for bodyMassIndex: BodyMassIndex, to events: inout [Event]) {
		events.append(BodyMassIndexEvent(for: bodyMassIndex))
	}

	private func appendDietarySugar(for dietarySugar: DietarySugar, to events: inout [Event]) {
		events.append(DietarySugarEvent(for: dietarySugar))
	}

	private func appendFatigueEvents(for fatigue: Fatigue, to events: inout [Event]) {
		events.append(FatigueEvent(for: fatigue))
	}

	private func appendHeartRateEvents(for heartRate: HeartRate, to events: inout [Event]) {
		events.append(HeartRateEvent(for: heartRate))
	}

	private func appendLeanBodyMassEvents(for leanBodyMass: LeanBodyMass, to events: inout [Event]) {
		events.append(LeanBodyMassEvent(for: leanBodyMass))
	}

	private func appendMoodEvents(for mood: Mood, to events: inout [Event]) {
		events.append(MoodEvent(for: mood))
	}

	private func appendMedicationDoseEvents(for medicationDose: MedicationDose, to events: inout [Event]) {
		events.append(TookMedicationEvent(for: medicationDose))
	}

	private func appendPainEvents(for pain: Pain, to events: inout [Event]) {
		events.append(PainEvent(for: pain))
	}

	private func appendRestingHeartRateEvents(for restingHeartRate: RestingHeartRate, to events: inout [Event]) {
		events.append(RestingHeartRateEvent(for: restingHeartRate))
	}

	private func appendSexualActivityEvents(for sexualActivity: SexualActivity, to events: inout [Event]) {
		events.append(SexualActivityEvent(for: sexualActivity))
	}

	private func appendSleepEvents(for sleep: Sleep, to events: inout [Event]) {
		if let event = WentToBedEvent(for: sleep) {
			events.append(event)
		}
		if let event = FellAsleepEvent(for: sleep) {
			events.append(event)
		}
		if let event = WokeUpEvent(for: sleep) {
			events.append(event)
		}
		if let event = GotOutOfBedEvent(for: sleep) {
			events.append(event)
		}
	}

	private func appendStepsEvents(for steps: Steps, to events: inout [Event]) {
		events.append(StartedWalkingEvent(for: steps))
		events.append(StoppedWalkingEvent(for: steps))
	}

	private func appendWeightEvents(for weight: Weight, to events: inout [Event]) {
		events.append(WeightEvent(for: weight))
	}

	private static func formatValue(_ value: Double) -> String {
		Me.valueFormatter.string(from: NSNumber(value: value))!
	}

	private final func resetDateRangeButtonTitle() {
		var dateText: String
		if let minDate = minDate, let maxDate = maxDate {
			let startOfMin = injected(CalendarUtil.self).start(of: .day, in: minDate)
			let startOfMax = injected(CalendarUtil.self).start(of: .day, in: maxDate)
			if startOfMin == startOfMax {
				dateText = "On "
				dateText += injected(CalendarUtil.self).string(for: minDate, dateStyle: .medium, timeStyle: .none)
			} else {
				dateText = "From "
				dateText += injected(CalendarUtil.self).string(for: minDate, dateStyle: .short, timeStyle: .none)
				dateText += " to "
				dateText += injected(CalendarUtil.self).string(for: maxDate, dateStyle: .short, timeStyle: .none)
			}
		} else if let minDate = minDate {
			dateText = "After "
			dateText += injected(CalendarUtil.self).string(for: minDate, dateStyle: .medium, timeStyle: .none)
		} else if let maxDate = maxDate {
			dateText = "Before "
			dateText += injected(CalendarUtil.self).string(for: maxDate, dateStyle: .medium, timeStyle: .none)
		} else {
			dateText = "Filter Dates"
		}
		dateRangeButton.title = dateText
		dateRangeButton.accessibilityValue = dateText
		dateRangeButton.accessibilityIdentifier = "filter dates button"
		dateRangeButton.accessibilityLabel = "filter dates button"
		dateRangeButton.accessibilityHint = "Filter the displayed data by date range"
	}

	// MARK: - Helper Classes

	private class Event {
		var date: Date
		var sample: Sample
		var delegate: TimelineTableViewCellDelegate {
			fatalError("forgot to override delegate")
		}

		var descriptions: [String]

		init(at date: Date, for sample: Sample, descriptions: [String]) {
			self.date = date
			self.sample = sample
			self.descriptions = descriptions
		}
	}

	/// Just so we can order everything such that any two events with the same timestamp show the stopping of the first before the starting of the next.
	private class StartEvent: Event {}

	/// Just so we can order everything such that any two events with the same timestamp show the stopping of the first before the starting of the next.
	private class StopEvent: Event {}

	// MARK: Activity Events

	private final class StartActivityEvent: StartEvent {
		override var delegate: TimelineTableViewCellDelegate {
			ActivityTimelineTableViewCellDelegate()
		}

		init(for activity: Activity) {
			var descriptions = [
				"⏱ Started " + activity.definition.name,
			]
			if let note = activity.note {
				descriptions.append("- Note: " + note)
			}
			super.init(at: activity.start, for: activity, descriptions: descriptions)
		}
	}

	private final class StopActivityEvent: StopEvent {
		override var delegate: TimelineTableViewCellDelegate {
			ActivityTimelineTableViewCellDelegate()
		}

		init?(for activity: Activity) {
			guard let end = activity.end else { return nil }
			let descriptions = [
				"⏱ Stopped " + activity.definition.name,
				"- Total Duration: " + activity.duration.description,
			]
			super.init(at: end, for: activity, descriptions: descriptions)
		}
	}

	// MARK: BloodPressure Events

	private final class BloodPressureEvent: Event {
		override var delegate: TimelineTableViewCellDelegate {
			BloodPressureTimelineTableViewCellDelegate()
		}

		init(for bloodPressure: BloodPressure) {
			let descriptions = [
				"🩸 Blood Pressure: " + formatValue(bloodPressure.systolic) + " / " +
					formatValue(bloodPressure.diastolic),
			]
			super.init(at: bloodPressure.timestamp, for: bloodPressure, descriptions: descriptions)
		}
	}

	// MARK: BodyMassIndex Events

	private final class BodyMassIndexEvent: Event {
		override var delegate: TimelineTableViewCellDelegate {
			BodyMassIndexTimelineTableViewCellDelegate()
		}

		init(for bodyMassIndex: BodyMassIndex) {
			let descriptions = [
				"⚖️ Body Mass Index: " + bodyMassIndex.description,
			]
			super.init(at: bodyMassIndex.timestamp, for: bodyMassIndex, descriptions: descriptions)
		}
	}

	// MARK: Dietary Sugar Events

	private final class DietarySugarEvent: Event {
		override var delegate: TimelineTableViewCellDelegate {
			DietarySugarTimelineTableViewCellDelegate()
		}

		init(for dietarySugar: DietarySugar) {
			let descriptions = [
				"🍬 Dietary Sugar: " + String(dietarySugar.dietarySugar),
			]
			super.init(at: dietarySugar.timestamp, for: dietarySugar, descriptions: descriptions)
		}
	}

	// MARK: Fatigue Events

	private final class FatigueEvent: Event {
		override var delegate: TimelineTableViewCellDelegate {
			FatigueTimelineTableViewCellDelegate()
		}

		init(for fatigue: Fatigue) {
			let min = injected(FatigueUiUtil.self).valueToString(fatigue.minRating)
			let max = injected(FatigueUiUtil.self).valueToString(fatigue.maxRating)
			let scaleText = min + " - " + max
			var descriptions = [
				"🥱 Fatigue: " + injected(MoodUiUtil.self).valueToString(fatigue.rating) + " (scale of \(scaleText))",
			]
			if let note = fatigue.note, !note.isEmpty {
				descriptions.append("- Note: " + note)
			}
			super.init(at: fatigue.date, for: fatigue, descriptions: descriptions)
		}
	}

	// MARK: HeartRate Events

	private final class HeartRateEvent: Event {
		override var delegate: TimelineTableViewCellDelegate {
			HeartRateTimelineTableViewCellDelegate()
		}

		init(for heartRate: HeartRate) {
			let descriptions = [
				"❤️ Heart Rate: " + formatValue(heartRate.heartRate),
			]
			super.init(at: heartRate.timestamp, for: heartRate, descriptions: descriptions)
		}
	}

	// MARK: LeanBodyMass Events

	private final class LeanBodyMassEvent: Event {
		override var delegate: TimelineTableViewCellDelegate {
			LeanBodyMassTimelineTableViewCellDelegate()
		}

		init(for leanBodyMass: LeanBodyMass) {
			let descriptions = [
				"⚖️ Lean Body Mass: " + formatValue(leanBodyMass.leanBodyMass),
			]
			super.init(at: leanBodyMass.timestamp, for: leanBodyMass, descriptions: descriptions)
		}
	}

	// MARK: Mood Events

	private final class MoodEvent: Event {
		override var delegate: TimelineTableViewCellDelegate {
			MoodTimelineTableViewCellDelegate()
		}

		init(for mood: Mood) {
			let min = injected(MoodUiUtil.self).valueToString(mood.minRating)
			let max = injected(MoodUiUtil.self).valueToString(mood.maxRating)
			let scaleText = min + " - " + max
			var descriptions = [
				"🧠 Mood: " + injected(MoodUiUtil.self).valueToString(mood.rating) + " (scale of \(scaleText))",
			]
			if let note = mood.note, !note.isEmpty {
				descriptions.append("- Note: " + note)
			}
			super.init(at: mood.date, for: mood, descriptions: descriptions)
		}
	}

	// MARK: MedicationDose Events

	private final class TookMedicationEvent: Event {
		override var delegate: TimelineTableViewCellDelegate {
			MedicationDoseTimelineTableViewCellDelegate()
		}

		init(for dose: MedicationDose) {
			var descriptions = [
				"℞ Took " + dose.medication.name,
			]
			if let dosage = dose.dosage {
				descriptions.append("- Dosage: " + dosage.description)
			}
			super.init(at: dose.date, for: dose, descriptions: descriptions)
		}
	}

	// MARK: Pain Events

	private final class PainEvent: Event {
		override var delegate: TimelineTableViewCellDelegate {
			PainTimelineTableViewCellDelegate()
		}

		init(for pain: Pain) {
			let min = injected(PainUiUtil.self).valueToString(pain.minRating)
			let max = injected(PainUiUtil.self).valueToString(pain.maxRating)
			let scaleText = min + " - " + max
			var descriptions = [
				"🤕 Pain: " + injected(PainUiUtil.self).valueToString(pain.rating) + " (scale of \(scaleText))",
			]
			if let location = pain.location, !location.isEmpty {
				descriptions.append("- Location: " + (pain.location ?? ""))
			}
			if let note = pain.note, !note.isEmpty {
				descriptions.append("- Note: " + note)
			}
			super.init(at: pain.date, for: pain, descriptions: descriptions)
		}
	}

	// MARK: RestingHeartRate Events

	private final class RestingHeartRateEvent: Event {
		override var delegate: TimelineTableViewCellDelegate {
			RestingHeartRateTimelineTableViewCellDelegate()
		}

		init(for restingHeartRate: RestingHeartRate) {
			let descriptions = [
				"❤️ Resting Heart Rate: " + formatValue(restingHeartRate.restingHeartRate),
			]
			super.init(at: restingHeartRate.timestamp, for: restingHeartRate, descriptions: descriptions)
		}
	}

	// MARK: SexualActivity Events

	private final class SexualActivityEvent: Event {
		override var delegate: TimelineTableViewCellDelegate {
			SexualActivityTimelineTableViewCellDelegate()
		}

		init(for sexualActivity: SexualActivity) {
			let descriptions = [
				"🍆 Sexual Activity: " + sexualActivity.protectionUsed.description,
			]
			super.init(at: sexualActivity.timestamp, for: sexualActivity, descriptions: descriptions)
		}
	}

	// MARK: Sleep Events

	private final class WentToBedEvent: StartEvent {
		override var delegate: TimelineTableViewCellDelegate {
			SleepTimelineTableViewCellDelegate()
		}

		init?(for sleep: Sleep) {
			guard sleep.state == .inBed else {
				return nil
			}
			let descriptions = [
				"🛌 Went to bed",
			]
			super.init(at: sleep.startDate, for: sleep, descriptions: descriptions)
		}
	}

	private final class FellAsleepEvent: StartEvent {
		override var delegate: TimelineTableViewCellDelegate {
			SleepTimelineTableViewCellDelegate()
		}

		init?(for sleep: Sleep) {
			guard sleep.state == .asleep else {
				return nil
			}
			let descriptions = [
				"💤 Fell asleep",
			]
			super.init(at: sleep.startDate, for: sleep, descriptions: descriptions)
		}
	}

	private final class WokeUpEvent: StopEvent {
		override var delegate: TimelineTableViewCellDelegate {
			SleepTimelineTableViewCellDelegate()
		}

		init?(for sleep: Sleep) {
			guard sleep.state == .asleep else {
				return nil
			}
			let descriptions = [
				"🥱 Woke up",
				"- Slept for " + sleep.duration.description,
			]
			super.init(at: sleep.endDate, for: sleep, descriptions: descriptions)
		}
	}

	private final class GotOutOfBedEvent: StopEvent {
		override var delegate: TimelineTableViewCellDelegate {
			SleepTimelineTableViewCellDelegate()
		}

		init?(for sleep: Sleep) {
			guard sleep.state == .inBed else {
				return nil
			}
			let descriptions = [
				"🛏 Got out of bed",
				"- In bed for " + sleep.duration.description,
			]
			super.init(at: sleep.endDate, for: sleep, descriptions: descriptions)
		}
	}

	// MARK: Step Events

	private final class StartedWalkingEvent: StartEvent {
		override var delegate: TimelineTableViewCellDelegate {
			StepsTimelineTableViewCellDelegate()
		}

		init(for steps: Steps) {
			let descriptions = [
				"👣 Started walking (" + formatValue(steps.steps) + " steps)",
			]
			super.init(at: steps.start, for: steps, descriptions: descriptions)
		}
	}

	private final class StoppedWalkingEvent: StopEvent {
		override var delegate: TimelineTableViewCellDelegate {
			StepsTimelineTableViewCellDelegate()
		}

		init(for steps: Steps) {
			let descriptions = [
				"👣 Stopped walking (" + formatValue(steps.steps) + " steps)",
			]
			super.init(at: steps.end, for: steps, descriptions: descriptions)
		}
	}

	// MARK: Weight Events

	private final class WeightEvent: Event {
		override var delegate: TimelineTableViewCellDelegate {
			WeightTimelineTableViewCellDelegate()
		}

		init(for weight: Weight) {
			let descriptions = [
				"⚖️ Weight: " + formatValue(weight.weight),
			]
			super.init(at: weight.timestamp, for: weight, descriptions: descriptions)
		}
	}
}
