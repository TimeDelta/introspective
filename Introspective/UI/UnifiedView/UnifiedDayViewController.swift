//
//  UnifiedDayViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 11/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CalendarKit
import CoreData
import HealthKit
import SwiftDate
import UIKit

import Common
import DependencyInjection
import Persistence
import SampleGroupInformation
import Samples

public final class UnifiedDayViewController: DayViewController {
	private typealias Me = UnifiedDayViewController

	private static let log = Log()

	private final var stopQueryFunctions = [() -> Void]()

	private final let healthKitUtil = DependencyInjector.get(HealthKitUtil.self)

	// MARK: - DayViewController Overrides

	public override func eventsForDate(_ date: Date) -> [EventDescriptor] {
		var descriptors = [EventDescriptor]()
		descriptors.append(contentsOf: getSleepEventDescriptorsForDate(date))
		descriptors.append(contentsOf: getActivityEventDescriptorsForDate(date))
		return descriptors
	}

	public override func dayViewDidSelectEventView(_ eventView: EventView) {
		let actionSheet = UIAlertController(
			title: "What would you like to know?",
			message: nil,
			preferredStyle: .actionSheet
		)
		actionSheet
			.addAction(UIAlertAction(title: "What was my average heart rate during this time?", style: .default) { _ in
				self.calculateAndDisplay(.discreteAverage, for: HeartRate.self, during: eventView)
			})
		actionSheet
			.addAction(UIAlertAction(title: "What was my maximum heart rate during this time?", style: .default) { _ in
				self.calculateAndDisplay(.discreteMax, for: HeartRate.self, during: eventView)
			})
		actionSheet
			.addAction(UIAlertAction(title: "What was my minimum heart rate during this time?", style: .default) { _ in
				self.calculateAndDisplay(.discreteMin, for: HeartRate.self, during: eventView)
			})

		actionSheet.addAction(UIAlertAction(title: "What was my average mood during this time?", style: .default) { _ in
			self.calculateAndDisplayForMood(AverageInformation(MoodImpl.rating), during: eventView)
		})
		actionSheet.addAction(UIAlertAction(title: "What was my maximum mood during this time?", style: .default) { _ in
			self.calculateAndDisplayForMood(MaximumInformation<Double>(MoodImpl.rating), during: eventView)
		})
		actionSheet.addAction(UIAlertAction(title: "What was my minimum mood during this time?", style: .default) { _ in
			self.calculateAndDisplayForMood(MinimumInformation<Double>(MoodImpl.rating), during: eventView)
		})

		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

		present(actionSheet, animated: false, completion: nil)
	}

	// MARK: - Helper Functions

	private final func calculateAndDisplayForMood(_ operation: SampleGroupInformation, during eventView: EventView) {
		let valueDescription = "\(operation.name.localizedLowercase) mood"
		let (startDate, endDate) = getStartAndEndDatesFrom(eventView)
		let fetchRequest: NSFetchRequest<MoodImpl> = MoodImpl.fetchRequest()
		fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
			NSPredicate(format: "timestamp > %@", startDate as NSDate),
			NSPredicate(format: "timestamp < %@", endDate as NSDate),
		])
		do {
			let moods = try DependencyInjector.get(Database.self).query(fetchRequest)
			if moods.isEmpty {
				showError(title: "You have no mood ratings during this time period")
				return
			}
			let value = try operation.compute(forSamples: moods)
			display(valueDescription, value, nil, startDate, endDate)
		} catch {
			Me.log.error("Failed to calculate %@ for mood: %@", operation.description, errorInfo(error))
			showError(title: "Could not calculate \(valueDescription)", error: error)
		}
	}

	private final func calculateAndDisplay(
		_ operation: HKStatisticsOptions,
		for type: HealthKitQuantitySample.Type,
		during eventView: EventView
	) {
		let (startDate, endDate) = getStartAndEndDatesFrom(eventView)
		healthKitUtil.calculate(operation, type, from: startDate, to: endDate) { value, error in
			let operationName: String = self.getOperationName(for: operation)
			let stringValue: String? = value == nil ? nil : String(value!)
			self.display("\(operationName) \(type.name.localizedLowercase)", stringValue, error, startDate, endDate)
		}
	}

	private final func display(
		_ description: String,
		_ value: String?,
		_ error: Error?,
		_ startDate: Date,
		_ endDate: Date
	) {
		guard error == nil && value != nil else {
			if let error = error {
				Me.log.error("Failed to calculate %@: %@", description, errorInfo(error))
			} else {
				Me.log.error("Failed to calculate %@ but no error was returned", description)
			}
			showError(title: "Could not calculate \(description)")
			return
		}
		let startDateText = DependencyInjector.get(CalendarUtil.self)
			.string(for: startDate, dateStyle: .none, timeStyle: .short)
		let endDateText = DependencyInjector.get(CalendarUtil.self)
			.string(for: endDate, dateStyle: .none, timeStyle: .short)
		let message = "Your \(description) from \(startDateText) to \(endDateText) was \(value!)"
		let alert = UIAlertController(
			title: "\(description.localizedCapitalized)",
			message: message,
			preferredStyle: .alert
		)
		alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
		present(alert, animated: false, completion: nil)
	}

	private final func getActivityEventDescriptorsForDate(_ date: Date) -> [EventDescriptor] {
		getActivitiesForDate(date).map { activity in
			let event = Event()
			event.startDate = activity.start
			event.endDate = activity.end ?? Date()
			let timeText = getTimeTextFor(event)
			event.text = "Activity\n\(timeText)"
			return event
		}
	}

	private final func getActivitiesForDate(_ date: Date) -> [Activity] {
		let startDateKey = CommonSampleAttributes.startDate.variableName!
		let endDateKey = CommonSampleAttributes.endDate.variableName!
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		let startOfDate = DependencyInjector.get(CalendarUtil.self).start(of: .day, in: date)
		let endOfDate = DependencyInjector.get(CalendarUtil.self).end(of: .day, in: date)
		fetchRequest.predicate = NSPredicate(
			format: "(%K >= %@ AND %K <= %@) OR (%K >= %@ AND %K <= %@)",
			startDateKey, startOfDate as NSDate,
			startDateKey, endOfDate as NSDate,
			endDateKey, startOfDate as NSDate,
			endDateKey, endOfDate as NSDate
		)
		do {
			return try DependencyInjector.get(Database.self).query(fetchRequest)
		} catch {
			Me.log.error("Failed to query for activities on %@: %@", String(describing: date), errorInfo(error))
			showError(title: "Something went wrong while loading your activity data", error: error)
			return []
		}
	}

	private final func getSleepEventDescriptorsForDate(_ date: Date) -> [EventDescriptor] {
		getSleepSamplesForDate(date).map { sleep in
			let event = Event()
			event.startDate = sleep.startDate
			event.endDate = sleep.endDate
			let timeText = getTimeTextFor(event)
			event.text = "Sleeping\n\(timeText)"
			return event
		}
	}

	private final func getSleepSamplesForDate(_ date: Date) -> [Sleep] {
		getHealthKitSamplesFor(date, initSample: { (s: HKCategorySample) in Sleep(s) }).filter { $0.state == .asleep }
	}

	private final func getHeartRateSamples(from fromDate: Date, to toDate: Date) -> [HeartRate] {
		getHealthKitSamplesFor(fromDate, to: toDate, initSample: { (s: HKQuantitySample) in HeartRate(s) })
	}

	private final func getHealthKitSamplesFor<Type: HealthKitSample, HKType: HKSample>(
		_ fromDate: Date,
		to toDate: Date? = nil,
		initSample: @escaping (HKType) -> Type
	) -> [Type] {
		var typeSamples = [Type]()
		var errorMessage: String?
		let group = DispatchGroup()
		let callback = { (samples: [HKSample]?, error: Error?) in
			if let error = error {
				errorMessage = "Could not retrieve sleep data."
				Me.log.error("Failed to retrieve sleep samples: %@", errorInfo(error))
				group.leave()
				return
			}
			if let samples = samples {
				typeSamples.append(contentsOf: samples.map { initSample($0 as! HKType) })
			} else {
				errorMessage = "Could not retrieve sleep data."
				Me.log.error("Both samples and error variables are nil")
			}
			group.leave()
		}
		if toDate == nil {
			group.enter()
			stopQueryFunctions.append(healthKitUtil.getSamples(for: Type.self, from: fromDate, callback: callback))
			group.enter()
			stopQueryFunctions.append(healthKitUtil.getSamples(for: Type.self, to: fromDate, callback: callback))
		} else {
			group.enter()
			stopQueryFunctions
				.append(healthKitUtil.getSamples(for: Type.self, from: fromDate, to: toDate, callback: callback))
		}
		group.wait()
		if let errorMessage = errorMessage {
			showError(title: errorMessage)
			return []
		}
		return typeSamples
	}

	private final func getTimeTextFor(_ event: Event) -> String {
		let startText = DependencyInjector.get(CalendarUtil.self)
			.string(for: event.startDate, dateStyle: .none, timeStyle: .short)
		let endText = DependencyInjector.get(CalendarUtil.self)
			.string(for: event.endDate, dateStyle: .none, timeStyle: .short)
		let duration = TimeDuration(start: event.startDate, end: event.endDate)
		return startText + " - " + endText + " (\(duration.description)))"
	}

	private final func getStartAndEndDatesFrom(_ eventView: EventView) -> (Date, Date) {
		return (eventView.descriptor!.startDate, eventView.descriptor!.endDate)
	}

	private final func getOperationName(for operation: HKStatisticsOptions) -> String {
		switch operation {
		case .cumulativeSum: return "sum"
		case .discreteAverage: return "average"
		case .discreteMax: return "maximum"
		case .discreteMin: return "minimum"
		default:
			Me.log.error("Unsupported operation type passed")
			return ""
		}
	}
}
