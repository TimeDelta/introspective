//
//  TestDataGenerationTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import SwiftDate

final class TestDataGenerationTableViewCell: UITableViewCell {

	private typealias Me = TestDataGenerationTableViewCell

	private static let samplesPerHour = 12

	private static let bloodPressureRange: (systolic: (min: UInt32, max: UInt32), diastolic: (min: UInt32, max: UInt32)) = (systolic: (min: 100, max: 140), diastolic: (min: 50, max: 100))
	private static let bmiRange: (min: UInt32, max: UInt32) = (min: 15, max: 50)
	private static let heartRateRange: (min: UInt32, max: UInt32) = (min: 45, max: 200)
	private static let leanBodyMassRange: (min: UInt32, max: UInt32) = (min: 120, max: 150)
	private static let weightRange: (min: UInt32, max: UInt32) = (min: 100, max: 200)

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
				var weights = [Weight]()

				for daysAgo in 1 ... 60 {
					for hoursAgo in 0 ... 23 {
						for sampleNum in 0 ... Me.samplesPerHour {
							let minutesAgo: Int = 60 * sampleNum / Me.samplesPerHour
							let date = Date() - daysAgo.days - hoursAgo.hours - minutesAgo.minutes

							let bloodPressure = BloodPressure(
								systolic: self.randomDouble(Me.bloodPressureRange.systolic),
								diastolic: self.randomDouble(Me.bloodPressureRange.diastolic),
								date)
							bloodPressures.append(bloodPressure)

							let bmi = BodyMassIndex(self.randomDouble(Me.bmiRange), date)
							bmis.append(bmi)

							let heartRate = HeartRate(self.randomDouble(Me.heartRateRange), date)
							heartRates.append(heartRate)

							let leanBodyMass = LeanBodyMass(self.randomDouble(Me.leanBodyMassRange), date)
							leanBodyMasses.append(leanBodyMass)

							let mood = DependencyInjector.sample.mood()
							mood.timestamp = date
							mood.maxRating = DependencyInjector.settings.maximumMood
							mood.rating = Double(arc4random_uniform(UInt32(mood.maxRating)))
							mood.note = Me.moodNotes[Int(arc4random_uniform(UInt32(Me.moodNotes.count - 1)))]

							let weight = Weight(self.randomDouble(Me.weightRange), date)
							weights.append(weight)
						}
					}
				}

				DependencyInjector.db.save()
				HealthKitDataTestUtil.save(bloodPressures)
				HealthKitDataTestUtil.save(bmis)
				HealthKitDataTestUtil.save(heartRates)
				HealthKitDataTestUtil.save(leanBodyMasses)
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

	private final func randomDouble(_ range: (min: UInt32, max: UInt32)) -> Double {
		return Double(arc4random_uniform(range.max - range.min) + range.min)
	}
}
