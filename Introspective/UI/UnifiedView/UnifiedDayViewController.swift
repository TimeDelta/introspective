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
import SwiftDate
import os

public final class UnifiedDayViewController: DayViewController {

	private final var stopQueryFunctions = [()->()]()

	// MARK: - DayViewController Overrides

	public override func eventsForDate(_ date: Date) -> [EventDescriptor] {
		var descriptors = [EventDescriptor]()
		descriptors.append(contentsOf: getSleepEventDescriptorsForDate(date))
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

		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

		present(actionSheet, animated: true, completion: nil)
	}

	// MARK: - Helper Functions

	private final func calculateAndDisplay(_ operation: HKStatisticsOptions, for type: HealthKitQuantitySample.Type, during eventView: EventView) {
		let (startDate, endDate) = self.getStartAndEndDatesFrom(eventView)
		HealthManager.calculate(operation, type, from: startDate, to: endDate) { value, error in
			let operationName: String = self.getOperationName(for: operation)
			self.display("\(operationName) \(type.name.localizedLowercase)", value, error, startDate, endDate)
		}
	}

	private final func display(_ description: String, _ value: Double?, _ error: Error?, _ startDate: Date, _ endDate: Date) {
		guard error == nil && value != nil else {
			if let error = error {
				os_log("Failed to calculate %@: %@", type: .error, description, error.localizedDescription)
			} else {
				os_log("Failed to calculate %@ but no error was returned", type: .error, description)
			}
			self.showError(title: "Could not calculate \(description)", message: "Sorry for the inconvenience")
			return
		}
		let startDateText = DependencyInjector.util.calendar.string(for: startDate, dateStyle: .none, timeStyle: .short)
		let endDateText = DependencyInjector.util.calendar.string(for: endDate, dateStyle: .none, timeStyle: .short)
		let message = "Your \(description) from \(startDateText) to \(endDateText) was \(value!)"
		let alert = UIAlertController(title: "\(description.localizedCapitalized)", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
		self.present(alert, animated: false, completion: nil)
	}

	private final func getSleepEventDescriptorsForDate(_ date: Date) -> [EventDescriptor] {
		let sleepSamples = getSleepSamplesForDate(date)
		var descriptors = [EventDescriptor]()
		for sleep in sleepSamples {
			let event = Event()
			event.startDate = sleep.startDate
			event.endDate = sleep.endDate
			let timeText = getTimeTextFor(event)
			event.text = "Sleeping\n\(timeText)"
			descriptors.append(event)
		}
		return descriptors
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
			if error != nil {
				errorMessage = "Could not retrieve sleep data."
				os_log("Failed to retrieve sleep samples: %@", type: .error, error!.localizedDescription)
				group.leave()
				return
			}
			if let samples = samples {
				typeSamples.append(contentsOf: samples.map{ initSample($0 as! HKType) })
			} else {
				errorMessage = "Could not retrieve sleep data."
				os_log("Both samples and error variables are nil", type: .error)
			}
			group.leave()
		}
		if toDate == nil {
			group.enter()
			stopQueryFunctions.append(HealthManager.getSamples(for: Type.self, startDate: fromDate, callback: callback))
			group.enter()
			stopQueryFunctions.append(HealthManager.getSamples(for: Type.self, endDate: fromDate, callback: callback))
		} else {
			group.enter()
			stopQueryFunctions.append(HealthManager.getSamples(for: Type.self, startDate: fromDate, endDate: toDate, callback: callback))
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
		return startText + " - " + endText
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
				os_log("Unsupported operation type passed", type: .error)
				return ""
		}
	}
}
