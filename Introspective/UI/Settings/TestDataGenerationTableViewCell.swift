//
//  TestDataGenerationTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 8/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import SwiftDate

final class TestDataGenerationTableViewCell: UITableViewCell {

	private typealias Me = TestDataGenerationTableViewCell

	private static let samplesPerHour = 12

	private static let bloodPressureRange: (systolic: (min: Double, max: Double), diastolic: (min: Double, max: Double)) = (systolic: (min: 100, max: 140), diastolic: (min: 50, max: 100))
	private static let bmiRange: (min: Double, max: Double) = (min: 15, max: 50)
	private static let heartRateRange: (min: Double, max: Double) = (min: 45, max: 200)
	private static let leanBodyMassRange: (min: Double, max: Double) = (min: 120, max: 150)
	private static let medicationDoseAmountRange: (min: Double, max: Double) = (min: 10, max: 100)
	private static let moodRatingRange: (min: Double, max: Double) = (min: 0, max: DependencyInjector.settings.maximumMood)
	private static let sleepHoursRange: (min: Int, max: Int) = (min: 5, max: 10)
	private static let weightRange: (min: Double, max: Double) = (min: 100, max: 200)

	private static let medicationNames = [
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
		"Hello world", nil,
		"This is a note", nil,
	]

	@IBOutlet weak final var dataGenerationActivityIndicator: UIActivityIndicatorView!
	@IBOutlet weak final var generateTestDataButton: UIButton!

	@IBAction func generateTestData(_ sender: Any) {
		dataGenerationActivityIndicator.isHidden = false
		generateTestDataButton.isHidden = true
		generateTestDataButton.isEnabled = false
		generateTestDataButton.isUserInteractionEnabled = false

		HealthManager.getAuthorization() { error in
			if error != nil {
				fatalError("HealthKit authorization failed: " + error!.localizedDescription)
			}
			DispatchQueue.global(qos: .userInitiated).async {
				var bloodPressures = [BloodPressure]()
				var bmis = [BodyMassIndex]()
				var heartRates = [HeartRate]()
				var leanBodyMasses = [LeanBodyMass]()
				var restingHeartRates = [RestingHeartRate]()
				var sexualActivities = [SexualActivity]()
				var sleepRecords = [Sleep]()
				var weights = [Weight]()

				let medications = self.createRandomMedications(5)
				DependencyInjector.db.save()

				for daysAgo in 0 ... 60 {
					sleepRecords.append(self.randomSleepSample(daysAgo))
					for hoursAgo in 0 ... 23 {
						for sampleNum in 0 ... Me.samplesPerHour {
							let minutesAgo: Int = 60 * sampleNum / Me.samplesPerHour
							let date = Date() - daysAgo.days - hoursAgo.hours - minutesAgo.minutes

							bloodPressures.append(self.randomBloodPressure(date))
							bmis.append(BodyMassIndex(self.randomDouble(Me.bmiRange), date))
							heartRates.append(HeartRate(self.randomDouble(Me.heartRateRange), date))
							leanBodyMasses.append(LeanBodyMass(self.randomDouble(Me.leanBodyMassRange), date))
							self.createRandomMedicationDose(date, medications)
							self.createRandomMood(date)
							restingHeartRates.append(RestingHeartRate(self.randomDouble(Me.heartRateRange), date))
							sexualActivities.append(self.randomSexualActivity(date))
							weights.append(Weight(self.randomDouble(Me.weightRange), date))
						}
					}
				}

				DependencyInjector.db.save()
				HealthKitDataTestUtil.save(bloodPressures)
				HealthKitDataTestUtil.save(bmis)
				HealthKitDataTestUtil.save(heartRates)
				HealthKitDataTestUtil.save(leanBodyMasses)
				HealthKitDataTestUtil.save(restingHeartRates)
				HealthKitDataTestUtil.save(sexualActivities)
				HealthKitDataTestUtil.save(sleepRecords)
				HealthKitDataTestUtil.save(weights)

				DispatchQueue.main.async {
					self.dataGenerationActivityIndicator.isHidden = true
					self.generateTestDataButton.isHidden = false
					self.generateTestDataButton.isEnabled = true
					self.generateTestDataButton.isUserInteractionEnabled = true
				}
			}
		}
	}

	private final func randomBloodPressure(_ date: Date) -> BloodPressure {
		return BloodPressure(
			systolic: randomDouble(Me.bloodPressureRange.systolic),
			diastolic: randomDouble(Me.bloodPressureRange.diastolic),
			date)
	}

	private final func createRandomMedications(_ numberToCreate: Int) -> [Medication] {
		var medications = try! DependencyInjector.db.query(Medication.fetchRequest())
		for i in 0 ..< numberToCreate {
			let medication = try! DependencyInjector.db.new(Medication.self)
			medication.name = Me.medicationNames[i]
			medication.recordScreenIndex = Int16(medications.count)
			medications.append(medication)
		}
		return medications
	}

	private final func createRandomMedicationDose(_ date: Date, _ medications: [Medication]) {
		let medicationDose = DependencyInjector.sample.medicationDose()
		medicationDose.timestamp = date
		medicationDose.dosage = Dosage(randomDouble(Me.medicationDoseAmountRange), "mg")
		medicationDose.medication = try! DependencyInjector.db.pull(savedObject: randomEntry(medications), fromSameContextAs: medicationDose)
		medicationDose.medication.addToDoses(medicationDose)
	}

	private final func createRandomMood(_ date: Date) {
		let mood = DependencyInjector.sample.mood()
		mood.timestamp = date
		mood.maxRating = DependencyInjector.settings.maximumMood
		mood.rating = randomDouble(Me.moodRatingRange)
		mood.note = randomEntry(Me.moodNotes)
	}

	private final func randomSexualActivity(_ date: Date) -> SexualActivity {
		let sexualActivity = SexualActivity(date)
		sexualActivity.protectionUsed = self.randomEntry(SexualActivity.Protection.allValues)
		return sexualActivity
	}

	private final func randomSleepSample(_ daysAgo: Int) -> Sleep {
		let sleepStartDate = DependencyInjector.util.calendar.start(of: .day, in: Date() - daysAgo.days) -
			randomInt((min: 0, max: 2)).hours -
			randomInt((min: 0, max: 59)).minutes
		let sleep = Sleep(startDate: sleepStartDate, endDate: sleepStartDate + randomInt(Me.sleepHoursRange).hours)
		sleep.state = randomEntry(Sleep.State.allValues)
		return sleep
	}

	private final func randomEntry<EntryType>(_ array: [EntryType]) -> EntryType {
		return array[randomInt((min: 0, max: array.count - 1))]
	}

	private final func randomInt(_ range: (min: Int, max: Int)) -> Int {
		return Int.random(in: range.min ... range.max)
	}

	private final func randomDouble(_ range: (min: Double, max: Double)) -> Double {
		return Double.random(in: range.min ... range.max)
	}
}
