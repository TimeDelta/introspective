//
//  UnifiedDayViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 11/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import CalendarKit
import HealthKit
import CoreData
import SwiftDate

public final class UnifiedDayViewController: DayViewController {

	private final var stopQueryFunctions = [()->()]()

	private final let log = Log()
	private final let healthKitUtil = DependencyInjector.util.healthKit

	// MARK: - DayViewController Overrides

	public override func eventsForDate(_ date: Date) -> [EventDescriptor] {
		var descriptors = [EventDescriptor]()
		descriptors.append(contentsOf: getSleepEventDescriptorsForDate(date))
		descriptors.append(contentsOf: getActivityEventDescriptorsForDate(date))
		return descriptors
	}

	public override func dayViewDidSelectEventView(_ eventView: EventView) {
		let actionSheet = UIAlertController(title: "What would you like to know?", message: nil, preferredStyle: .actionSheet)
		actionSheet.addAction(UIAlertAction(title: "What was my average heart rate during this time?", style: .default) { _ in
			self.calculateAndDisplay(.discreteAverage, for: HeartRate.self, during: eventView)
		})
		actionSheet.addAction(UIAlertAction(title: "What was my maximum heart rate during this time?", style: .default) { _ in
			self.calculateAndDisplay(.discreteMax, for: HeartRate.self, during: eventView)
		})
		actionSheet.addAction(UIAlertAction(title: "What was my minimum heart rate during this time?", style: .default) { _ in
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

	private final func calculateAndDisplayForMood(_ operation: ExtraInformation, during eventView: EventView) {
		let valueDescription = "\(operation.name.localizedLowercase) mood"
		let (startDate, endDate) = getStartAndEndDatesFrom(eventView)
		let fetchRequest: NSFetchRequest<MoodImpl> = MoodImpl.fetchRequest()
		fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
			NSPredicate(format: "timestamp > %@", startDate as NSDate),
			NSPredicate(format: "timestamp < %@", endDate as NSDate)])
		do {
			let moods = try DependencyInjector.db.query(fetchRequest)
			if moods.count == 0 {
				showError(title: "You have no mood ratings during this time period")
				return
			}
			let value = try operation.compute(forSamples: moods)
			display(valueDescription, value, nil, startDate, endDate)
		} catch {
			log.error("Failed to calculate %@ for mood: %@", operation.description, errorInfo(error))
			showError(title: "Could not calculate \(valueDescription)", error: error)
		}
	}

	private final func calculateAndDisplay(_ operation: HKStatisticsOptions, for type: HealthKitQuantitySample.Type, during eventView: EventView) {
		let (startDate, endDate) = getStartAndEndDatesFrom(eventView)
		DependencyInjector.util.healthKit.calculate(operation, type, from: startDate, to: endDate) { value, error in
			let operationName: String = self.getOperationName(for: operation)
			let stringValue: String? = value == nil ? nil : String(value!)
			self.display("\(operationName) \(type.name.localizedLowercase)", stringValue, error, startDate, endDate)
		}
	}

	private final func display(_ description: String, _ value: String?, _ error: Error?, _ startDate: Date, _ endDate: Date) {
		guard error == nil && value != nil else {
			if let error = error {
				log.error("Failed to calculate %@: %@", description, errorInfo(error))
			} else {
				log.error("Failed to calculate %@ but no error was returned", description)
			}
			self.showError(title: "Could not calculate \(description)")
			return
		}
		let startDateText = DependencyInjector.util.calendar.string(for: startDate, dateStyle: .none, timeStyle: .short)
		let endDateText = DependencyInjector.util.calendar.string(for: endDate, dateStyle: .none, timeStyle: .short)
		let message = "Your \(description) from \(startDateText) to \(endDateText) was \(value!)"
		let alert = UIAlertController(title: "\(description.localizedCapitalized)", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
		self.present(alert, animated: false, completion: nil)
	}

	private final func getActivityEventDescriptorsForDate(_ date: Date) -> [EventDescriptor] {
		return getActivitiesForDate(date).map { activity in
			let event = Event()
			event.startDate = activity.startDate
			event.endDate = activity.endDate ?? Date()
			let timeText = getTimeTextFor(event)
			event.text = "Activity\n\(timeText)"
			return event
		}
	}

	private final func getActivitiesForDate(_ date: Date) -> [Activity] {
		let startDateKey = CommonSampleAttributes.startDate.variableName!
		let endDateKey = CommonSampleAttributes.endDate.variableName!
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		let startOfDate = DependencyInjector.util.calendar.start(of: .day, in: date)
		let endOfDate = DependencyInjector.util.calendar.end(of: .day, in: date)
		fetchRequest.predicate = NSPredicate(
			format: "(%K >= %@ AND %K <= %@) OR (%K >= %@ AND %K <= %@)",
			startDateKey, startOfDate as NSDate,
			startDateKey, endOfDate as NSDate,
			endDateKey, startOfDate as NSDate,
			endDateKey, endOfDate as NSDate)
		do {
			return try DependencyInjector.db.query(fetchRequest)
		} catch {
			log.error("Failed to query for activities on %@: %@", String(describing: date), errorInfo(error))
			showError(title: "Something went wrong while loading your activity data", error: error)
			return []
		}
	}

	private final func getSleepEventDescriptorsForDate(_ date: Date) -> [EventDescriptor] {
		return getSleepSamplesForDate(date).map { sleep in
			let event = Event()
			event.startDate = sleep.startDate
			event.endDate = sleep.endDate
			let timeText = getTimeTextFor(event)
			event.text = "Sleeping\n\(timeText)"
			return event
		}
	}

	private final func getSleepSamplesForDate(_ date: Date) -> [Sleep] {
		return getHealthKitSamplesFor(date, initSample: { (s: HKCategorySample) in return Sleep(s) }).filter{ $0.state == .asleep }
	}

	private final func getHeartRateSamples(from fromDate: Date, to toDate: Date) -> [HeartRate] {
		return getHealthKitSamplesFor(fromDate, to: toDate, initSample: { (s: HKQuantitySample) in return HeartRate(s) })
	}

	private final func getHealthKitSamplesFor<Type: HealthKitSample, HKType: HKSample>(_ fromDate: Date, to toDate: Date? = nil, initSample: @escaping (HKType) -> Type) -> [Type] {
		var typeSamples = [Type]()
		var errorMessage: String? = nil
		let group = DispatchGroup()
		let callback = { (samples: Array<HKSample>?, error: Error?) in
			if let error = error {
				errorMessage = "Could not retrieve sleep data."
				self.log.error("Failed to retrieve sleep samples: %@", errorInfo(error))
				group.leave()
				return
			}
			if let samples = samples {
				typeSamples.append(contentsOf: samples.map{ initSample($0 as! HKType) })
			} else {
				errorMessage = "Could not retrieve sleep data."
				self.log.error("Both samples and error variables are nil")
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
			stopQueryFunctions.append(healthKitUtil.getSamples(for: Type.self, from: fromDate, to: toDate, callback: callback))
		}
		group.wait()
		if let errorMessage = errorMessage {
			showError(title: errorMessage)
			return []
		}
		return typeSamples
	}

	private final func getTimeTextFor(_ event: Event) -> String {
		let startText = DependencyInjector.util.calendar.string(for: event.startDate, dateStyle: .none, timeStyle: .short)
		let endText = DependencyInjector.util.calendar.string(for: event.endDate, dateStyle: .none, timeStyle: .short)
		let duration = Duration(start: event.startDate, end: event.endDate)
		return startText + " - " + endText + " (\(duration.description)))"
	}

	private final func getStartAndEndDatesFrom(_ eventView: EventView) -> (Date, Date) {
		return (eventView.descriptor!.startDate, eventView.descriptor!.endDate)
	}

	private final func getOperationName(for operation: HKStatisticsOptions) -> String {
		switch (operation) {
			case .cumulativeSum: return "sum"
			case .discreteAverage: return "average"
			case .discreteMax: return "maximum"
			case .discreteMin: return "minimum"
			default:
				log.error("Unsupported operation type passed")
				return ""
		}
	}
}
