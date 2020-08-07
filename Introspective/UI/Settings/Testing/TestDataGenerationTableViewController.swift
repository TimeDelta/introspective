//
//  TestDataGenerationTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import NotificationBannerSwift
import SwiftDate
import UIKit

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

final class TestDataGenerationTableViewController: UITableViewController {
	// MARK: - Static Variables

	private typealias Me = TestDataGenerationTableViewController

	// MARK: Notification Names

	public static let numberOfDaysChanged = Notification.Name("numberOfDaysChanged")
	public static let samplesPerHourChanged = Notification.Name("samplesPerHourChanged")
	public static let shouldGenerateSampleTypeChanged = Notification.Name("shouldGenerateSampleTypeChanged")

	// MARK: Value Ranges

	private static let activityDurationHoursRange: (min: Int, max: Int) = (min: 1, max: 10)
	private static let activityDurationMinutesRange: (min: Int, max: Int) = (min: 0, max: 60)
	private static let bloodPressureRange: (
		systolic: (min: Double, max: Double),
		diastolic: (min: Double, max: Double)
	) = (systolic: (min: 100, max: 140), diastolic: (min: 50, max: 100))
	private static let bmiRange: (min: Double, max: Double) = (min: 15, max: 50)
	private static let heartRateRange: (min: Double, max: Double) = (min: 45, max: 200)
	private static let leanBodyMassRange: (min: Double, max: Double) = (min: 120, max: 150)
	private static let medicationDoseAmountRange: (min: Double, max: Double) = (min: 10, max: 100)
	private static let moodRatingRange: (min: Double, max: Double) = (
		min: 0,
		max: injected(Settings.self).maxMood
	)
	private static let sleepHoursRange: (min: Int, max: Int) = (min: 5, max: 10)
	private static let weightRange: (min: Double, max: Double) = (min: 100, max: 200)

	// MARK: Fake Data Strings

	private static let names = [
		"1a",
		"2b",
		"3c",
		"4d",
		"abcd",
	]
	private static let moodNotes = [
		"Not feeling too great", nil,
		"Today was a great day", nil,
		"I'm a little teapot", nil,
		"This\nhas\nmultiple\nlines", nil,
		"This is a note", nil,
	]

	// MARK: - Structs / Enums / Classes

	public struct Options {
		public var shouldGenerate: Bool = false
		public var numberOfDays: Int = 5
		public var samplesPerHour: Int = 5
		public init() {}
	}

	// MARK: - Instance Variables

	private final var sampleTypeOptions = [String: Options]()
	private final var generateTestDataButton: UIBarButtonItem!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		generateTestDataButton = UIBarButtonItem(
			title: "Generate",
			style: .done,
			target: self,
			action: #selector(generateTestData)
		)
		navigationItem.setRightBarButton(generateTestDataButton, animated: false)

		observe(selector: #selector(samplesPerHourChanged), name: Me.samplesPerHourChanged)
		observe(selector: #selector(numberOfDaysChanged), name: Me.numberOfDaysChanged)
		observe(selector: #selector(shouldGenerateSampleTypeChanged), name: Me.shouldGenerateSampleTypeChanged)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table View Data Source

	public final override func numberOfSections(in _: UITableView) -> Int {
		1
	}

	public final override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
		injected(SampleFactory.self).allTypes().count
	}

	public final override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "sampleType",
			for: indexPath
		) as! TestDataCreationSampleTypeTableViewCell
		cell.sampleType = injected(SampleFactory.self).allTypes()[indexPath.row]
		cell.options = getOptions(for: cell.sampleType)
		return cell
	}

	// MARK: - Table View Delegate

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let sampleType = injected(SampleFactory.self).allTypes()[indexPath.row]
		setShouldGenerate(for: sampleType, to: !shouldGenerate(sampleType))
		tableView.deselectRow(at: indexPath, animated: false)
		tableView.reloadData()
	}

	public final override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let sampleType = injected(SampleFactory.self).allTypes()[indexPath.row]
		if shouldGenerate(sampleType) {
			return 139
		}
		return 49
	}

	// MARK: - Received Notifications

	@objc private final func shouldGenerateSampleTypeChanged(notification: Notification) {
		if
			let sampleType: Sample.Type? = value(for: .sampleType, from: notification),
			let generate: Bool = value(for: .shouldGenerate, from: notification) {
			setShouldGenerate(for: sampleType!, to: generate)
			tableView.reloadData()
		}
	}

	@objc private final func numberOfDaysChanged(notification: Notification) {
		if
			let sampleType: Sample.Type? = value(for: .sampleType, from: notification),
			let days: Int = value(for: .number, from: notification) {
			setNumberOfDays(for: sampleType!, to: days)
		}
	}

	@objc private final func samplesPerHourChanged(notification: Notification) {
		if
			let sampleType: Sample.Type? = value(for: .sampleType, from: notification),
			let samplesPerHour: Int = value(for: .number, from: notification) {
			setSamplesPerHour(for: sampleType!, to: samplesPerHour)
		}
	}

	// MARK: - Button Actions

	@objc private final func generateTestData(_: Any) {
		generateTestDataButton.isEnabled = false
		post(SettingsTableViewController.disableGenerateTestData)

		injected(HealthKitUtil.self).getAuthorization { error in
			if error != nil {
				fatalError("HealthKit authorization failed: " + error!.localizedDescription)
			}
			DispatchQueue.global(qos: .userInitiated).async {
				var activityDefinitions = [ActivityDefinition]()
				if self.shouldGenerate(Activity.self) {
					let transaction = injected(Database.self).transaction()
					activityDefinitions = self.createRandomActivityDefinitions(using: transaction)
					try! transaction.commit()
				}
				var medications = [Medication]()
				if self.shouldGenerate(MedicationDose.self) {
					let transaction = injected(Database.self).transaction()
					medications = self.createRandomMedications(using: transaction)
					try! transaction.commit()
				}

				self.createSamples(Activity.self) { date, transaction in
					let hoursAgo = try! abs(
						injected(CalendarUtil.self)
							.distance(from: date, to: Date(), in: .hour)
					)
					self.createRandomActivity(Date() - hoursAgo.hours, activityDefinitions, using: transaction)
				}
				self.createSamples(BloodPressure.self) { bloodPressures, date in
					bloodPressures.append(self.randomBloodPressure(date))
				}
				self.createSamples(BodyMassIndex.self) { bmis, date in
					bmis.append(BodyMassIndex(self.randomDouble(Me.bmiRange), date))
				}
				self.createSamples(HeartRate.self) { heartRates, date in
					heartRates.append(HeartRate(self.randomDouble(Me.heartRateRange), date))
				}
				self.createSamples(LeanBodyMass.self) { leanBodyMasses, date in
					leanBodyMasses.append(LeanBodyMass(self.randomDouble(Me.leanBodyMassRange), date))
				}
				self.createSamples(MedicationDose.self) { date, transaction in
					self.createRandomMedicationDose(date, medications, using: transaction)
				}
				self.createSamples(MoodImpl.self) { date, transaction in
					self.createRandomMood(date, using: transaction)
				}
				self.createSamples(RestingHeartRate.self) { restingHeartRates, date in
					restingHeartRates.append(RestingHeartRate(self.randomDouble(Me.heartRateRange), date))
				}
				self.createSamples(SexualActivity.self) { sexualActivities, date in
					sexualActivities.append(self.randomSexualActivity(date))
				}
				self.createSamples(Sleep.self) { sleepRecords, date in
					let daysAgo = try! abs(
						injected(CalendarUtil.self)
							.distance(from: date, to: Date(), in: .day)
					)
					sleepRecords.append(self.randomSleepSample(daysAgo))
				}
				self.createSamples(Weight.self) { weights, date in
					weights.append(Weight(self.randomDouble(Me.weightRange), date))
				}

				DispatchQueue.main.async {
					NotificationBanner(title: "Finished generating test data", style: .success).show()
					self.post(SettingsTableViewController.enableGenerateTestData)
				}
			}
			DispatchQueue.main.async {
				self.navigationController?.popViewController(animated: false)
			}
		}
	}

	// MARK: - Data Generation Helper Functions

	private final func createSamples<SampleType: CoreDataSample>(
		_ sampleType: SampleType.Type,
		_ createSample: (Date, Transaction) -> Void
	) {
		let transaction = injected(Database.self).transaction()

		for daysAgo in 0 ... numberOfDays(for: sampleType) {
			for hoursAgo in 0 ... 23 {
				for sampleNum in 0 ... samplesPerHour(for: sampleType) {
					if shouldGenerate(sampleType) {
						let minutesAgo: Int = 60 * sampleNum / samplesPerHour(for: sampleType)
						let date = Date() - daysAgo.days - hoursAgo.hours - minutesAgo.minutes
						createSample(date, transaction)
					}
				}
			}
		}

		try! transaction.commit()
	}

	private final func createSamples<SampleType: HealthKitSample>(
		_ sampleType: SampleType.Type,
		_ createSample: (inout [SampleType], Date) -> Void
	) {
		guard shouldGenerate(sampleType) else { return }

		var samples = [SampleType]()

		for daysAgo in 0 ... numberOfDays(for: sampleType) {
			for hoursAgo in 0 ... 23 {
				for sampleNum in 0 ... samplesPerHour(for: sampleType) {
					let minutesAgo: Int = 60 * sampleNum / samplesPerHour(for: sampleType)
					let date = Date() - daysAgo.days - hoursAgo.hours - minutesAgo.minutes
					createSample(&samples, date)
				}
			}
		}

		HealthKitDataTestUtil.save(samples)
	}

	private final func createRandomActivity(
		_ date: Date,
		_ activityDefinitions: [ActivityDefinition],
		using transaction: Transaction
	) {
		let activity = try! transaction.new(Activity.self)
		activity.definition = try! transaction.pull(savedObject: randomEntry(activityDefinitions))
		activity.start = date
		if randomInt((min: 0, max: 1)) == 0 {
			activity.end = date + randomInt(Me.activityDurationHoursRange)
				.hours + randomInt(Me.activityDurationMinutesRange).minutes
		}
	}

	private final func createRandomActivityDefinitions(using transaction: Transaction) -> [ActivityDefinition] {
		var activityDefinitions = try! injected(Database.self).query(ActivityDefinition.fetchRequest())
		let numberOfDefinitionsToCreate = max(0, Me.names.count - activityDefinitions.count)
		for i in 0 ..< numberOfDefinitionsToCreate {
			let definition = try! transaction.new(ActivityDefinition.self)
			definition.name = Me.names[i]
			definition.recordScreenIndex = Int16(activityDefinitions.count)
			activityDefinitions.append(definition)
		}
		return activityDefinitions
	}

	private final func randomBloodPressure(_ date: Date) -> BloodPressure {
		BloodPressure(
			systolic: randomDouble(Me.bloodPressureRange.systolic),
			diastolic: randomDouble(Me.bloodPressureRange.diastolic),
			date
		)
	}

	private final func createRandomMedications(using transaction: Transaction) -> [Medication] {
		var medications = try! transaction.query(Medication.fetchRequest())
		let numberOfMedicationsToCreate = Me.names.count - medications.count
		for i in 0 ..< numberOfMedicationsToCreate {
			let medication = try! transaction.new(Medication.self)
			medication.name = Me.names[i]
			medication.recordScreenIndex = Int16(medications.count)
			medications.append(medication)
		}
		return medications
	}

	private final func createRandomMedicationDose(
		_ date: Date,
		_ medications: [Medication],
		using transaction: Transaction
	) {
		let medicationDose = try! transaction.new(MedicationDose.self)
		medicationDose.date = date
		medicationDose.dosage = Dosage(randomDouble(Me.medicationDoseAmountRange), "mg")
		medicationDose.medication = try! transaction.pull(savedObject: randomEntry(medications))
		medicationDose.medication.addToDoses(medicationDose)
	}

	private final func createRandomMood(_ date: Date, using transaction: Transaction) {
		let mood = try! transaction.new(MoodImpl.self)
		mood.date = date
		mood.maxRating = injected(Settings.self).maxMood
		mood.rating = randomDouble(Me.moodRatingRange)
		mood.note = randomEntry(Me.moodNotes)
	}

	private final func randomSexualActivity(_ date: Date) -> SexualActivity {
		let sexualActivity = SexualActivity(date)
		sexualActivity.protectionUsed = randomEntry(SexualActivity.Protection.allValues)
		return sexualActivity
	}

	private final func randomSleepSample(_ daysAgo: Int) -> Sleep {
		let sleepStartDate = injected(CalendarUtil.self).start(of: .day, in: Date() - daysAgo.days) -
			randomInt((min: 0, max: 2)).hours -
			randomInt((min: 0, max: 59)).minutes
		let sleep = Sleep(startDate: sleepStartDate, endDate: sleepStartDate + randomInt(Me.sleepHoursRange).hours)
		sleep.state = randomEntry(Sleep.State.allValues)
		return sleep
	}

	private final func randomEntry<EntryType>(_ array: [EntryType]) -> EntryType {
		array[randomInt((min: 0, max: array.count - 1))]
	}

	private final func randomInt(_ range: (min: Int, max: Int)) -> Int {
		Int.random(in: range.min ... range.max)
	}

	private final func randomDouble(_ range: (min: Double, max: Double)) -> Double {
		Double.random(in: range.min ... range.max)
	}

	// MARK: - Helper Functions

	private final func getOptions(for sampleType: Sample.Type) -> Options {
		sampleTypeOptions[sampleType.name] ?? Options()
	}

	private final func shouldGenerate(_ sampleType: Sample.Type) -> Bool {
		getOptions(for: sampleType).shouldGenerate
	}

	private final func numberOfDays(for sampleType: Sample.Type) -> Int {
		getOptions(for: sampleType).numberOfDays
	}

	private final func samplesPerHour(for sampleType: Sample.Type) -> Int {
		getOptions(for: sampleType).samplesPerHour
	}

	private final func setShouldGenerate(for sampleType: Sample.Type, to value: Bool) {
		setOption(sampleType) { options in options.shouldGenerate = value }
	}

	private final func setNumberOfDays(for sampleType: Sample.Type, to value: Int) {
		setOption(sampleType) { options in options.numberOfDays = value }
	}

	private final func setSamplesPerHour(for sampleType: Sample.Type, to value: Int) {
		setOption(sampleType) { options in options.samplesPerHour = value }
	}

	private final func setOption(_ sampleType: Sample.Type, _ setter: @escaping (inout Options) -> Void) {
		var options: Options = getOptions(for: sampleType)
		setter(&options)
		sampleTypeOptions[sampleType.name] = options
	}
}
