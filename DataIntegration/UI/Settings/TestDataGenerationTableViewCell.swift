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
	private static let minHeartRate: UInt32 = 45
	private static let maxHeartRate: UInt32 = 200
	private static let minWeight: UInt32 = 100
	private static let maxWeight: UInt32 = 200
	private static let minBMI: UInt32 = 15
	private static let maxBMI: UInt32 = 50
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

		HealthManager.getAuthorization(for: .heartRate) { error in
			if error != nil {
				fatalError("HealthKit authorization failed: " + error!.localizedDescription)
			}
			DispatchQueue.global(qos: .userInitiated).async {
				var heartRates = [HeartRate]()
				var weights = [Weight]()
				var bmis = [BodyMassIndex]()

				for daysAgo in 1 ... 60 {
					for hoursAgo in 0 ... 23 {
						for sampleNum in 0 ... Me.samplesPerHour {
							let minutesAgo: Int = 60 * sampleNum / Me.samplesPerHour
							let date = Date() - daysAgo.days - hoursAgo.hours - minutesAgo.minutes

							let heartRate = HeartRate(Double(arc4random_uniform(Me.maxHeartRate - Me.minHeartRate) + Me.minHeartRate), date)
							heartRates.append(heartRate)

							let mood = DependencyInjector.dataType.mood()
							mood.timestamp = date
							mood.maxRating = DependencyInjector.settings.maximumMood
							mood.rating = Double(arc4random_uniform(UInt32(mood.maxRating)))
							mood.note = Me.moodNotes[Int(arc4random_uniform(UInt32(Me.moodNotes.count - 1)))]

							let weight = Weight(Double(arc4random_uniform(Me.maxWeight - Me.minWeight) + Me.minWeight), date)
							weights.append(weight)

							let bmi = BodyMassIndex(Double(arc4random_uniform(Me.maxBMI - Me.minBMI) + Me.minBMI), date)
							bmis.append(bmi)
						}
					}
				}

				DependencyInjector.db.save()
				HealthKitDataTestUtil.save(type: .heartRate, heartRates)
				HealthKitDataTestUtil.save(type: .weight, weights)
				HealthKitDataTestUtil.save(type: .bmi, bmis)

				DispatchQueue.main.async {
					self.dataGenerationActivityIndicator.isHidden = true
					self.generateTestDataButton.isHidden = false
					self.generateTestDataButton.isEnabled = true
					self.generateTestDataButton.isUserInteractionEnabled = true
				}
			}
		}
	}
}
