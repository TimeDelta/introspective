//
//  RecordActivityDefinitionTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 11/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import SwiftDate
import CoreData
import os

import Common
import DependencyInjection
import Persistence
import Samples

public final class RecordActivityDefinitionTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var nameLabel: UILabel!
	@IBOutlet weak final var mostRecentTimeLabel: UILabel!
	@IBOutlet weak final var totalDurationTodayLabel: UILabel!
	@IBOutlet weak final var currentInstanceDurationLabel: UILabel!
	@IBOutlet weak final var progressIndicator: UIActivityIndicatorView!

	// MARK: - Instance Variables

	public final var activityDefinition: ActivityDefinition! {
		didSet {
			timer?.invalidate()
			updateUiElements()
			timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateDurationLabels), userInfo: nil, repeats: true)
		}
	}
	public final var running: Bool {
		return hasUnfinishedActivity()
	}
	private final var timer: Timer!

	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "ActivityDefinition Table Cell"))
	private final let log = Log()

	deinit { timer?.invalidate() }

	// MARK: - Helper Functions

	public final func updateUiElements() {
		nameLabel.text = activityDefinition.name
		updateMostRecentTimeLabel()
		updateDurationLabels()

		progressIndicator.isHidden = !hasUnfinishedActivity()
		if !progressIndicator.isHidden {
			progressIndicator.startAnimating()
		}
	}

	@objc private final func updateDurationLabels() {
		updateTotalDurationTodayLabel()
		updateCurrentInstanceDurationLabel()
	}

	private final func updateCurrentInstanceDurationLabel() {
		if let mostRecentlyStartedActivity = getMostRecentlyStartedActivity() {
			currentInstanceDurationLabel.text = mostRecentlyStartedActivity.duration.description
		} else {
			currentInstanceDurationLabel.text = ""
		}
		currentInstanceDurationLabel.accessibilityValue = currentInstanceDurationLabel.text ?? ""
	}

	private final func updateMostRecentTimeLabel() {
		if let mostRecentlyCompletedActivity = getMostRecentlyStartedActivity() {
			let startDate = mostRecentlyCompletedActivity.start
			let startText: String
			if startDate.isToday() {
				startText = TimeOfDay(startDate).toString(.medium)
			} else {
				startText = DependencyInjector.get(CalendarUtil.self).string(for: startDate, dateStyle: .short, timeStyle: .short)
			}
			mostRecentTimeLabel.text = startText + " -"
			if let endDate = mostRecentlyCompletedActivity.end {
				if startDate.isToday() {
					mostRecentTimeLabel.text! += " " + TimeOfDay(endDate).toString(.medium)
				} else if endDate.isToday() {
					mostRecentTimeLabel.text! += " Today, " + TimeOfDay(endDate).toString(.medium)
				} else {
					mostRecentTimeLabel.text! += " " + DependencyInjector.get(CalendarUtil.self).string(for: endDate, dateStyle: .short, timeStyle: .short)
				}
			}
			mostRecentTimeLabel.accessibilityLabel = "last start / end time"
		} else if let activityDescription = activityDefinition.activityDescription {
			mostRecentTimeLabel.text = activityDescription
			mostRecentTimeLabel.accessibilityLabel = "activity description"
		} else {
			mostRecentTimeLabel.text = ""
			mostRecentTimeLabel.accessibilityLabel = "last start / end time"
		}
		mostRecentTimeLabel.accessibilityValue = mostRecentTimeLabel.text ?? ""
	}

	private final func updateTotalDurationTodayLabel() {
		var totalDuration: Duration = Duration(0.hours.timeInterval)
		for activity in getAllActivitiesForToday() {
			var duration = activity.duration
			if !activity.start.isToday() {
				if let endDate = activity.end {
					duration = Duration(start: Date().start(of: .day), end: endDate)
				} else {
					duration = Duration(start: Date().start(of: .day), end: Date())
				}
			}
			totalDuration += duration
		}
		if totalDuration > Duration(0) {
			totalDurationTodayLabel.text = totalDuration.description
		} else {
			totalDurationTodayLabel.text = ""
		}
		totalDurationTodayLabel.accessibilityValue = totalDurationTodayLabel.text ?? ""
	}

	private final func getMostRecentlyStartedActivity() -> Activity? {
		signpost.begin(
			name: "getMostRecentlyStartedActivity",
			idObject: activityDefinition,
			"# activities: %d", activityDefinition.activities.count)
		let keyName = CommonSampleAttributes.startDate.variableName!
		let fetchRequest: NSFetchRequest<Activity> = basicFetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: keyName, ascending: false)]
		do {
			let activities = try DependencyInjector.get(Database.self).query(fetchRequest)
			signpost.end(name: "getMostRecentlyStartedActivity", idObject: activityDefinition)
			if activities.count > 0 {
				return activities[0]
			}
		} catch {
			log.error("Failed to fetch activities: %@", errorInfo(error))
		}

		return nil
	}

	private final func getAllActivitiesForToday() -> [Activity] {
		do {
			signpost.begin(
				name: "getAllActivitiesForToday",
				idObject: activityDefinition,
				"# activities: %d", activityDefinition.activities.count)
			let startOfDay = DependencyInjector.get(CalendarUtil.self).start(of: .day, in: Date()) as NSDate
			let endOfDay = DependencyInjector.get(CalendarUtil.self).end(of: .day, in: Date()) as NSDate
			let fetchRequest = basicFetchRequest()
			fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
				fetchRequest.predicate!,
				NSPredicate(
					format: "(endDate == nil AND startDate > %@ AND startDate < %@) OR (endDate > %@ AND endDate < %@)",
					startOfDay, endOfDay, startOfDay, endOfDay),
			])
			let activities = try DependencyInjector.get(Database.self).query(fetchRequest)
			signpost.end(name: "getAllActivitiesForToday", idObject: activityDefinition)
			return activities
		} catch {
			log.error("Failed to fetch activities: %@", errorInfo(error))
			signpost.end(name: "getAllActivitiesForToday", idObject: activityDefinition)
			return []
		}
	}

	private final func hasUnfinishedActivity() -> Bool {
		signpost.begin(name: "hasUnfinishedActivity", idObject: activityDefinition)
		let fetchRequest = basicFetchRequest()
		fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
			fetchRequest.predicate!,
			NSPredicate(format: "endDate == nil"),
		])
		do {
			let unfinishedActivities = try DependencyInjector.get(Database.self).query(fetchRequest)
			signpost.end(name: "hasUnfinishedActivity", idObject: activityDefinition)
			return unfinishedActivities.count > 0
		} catch {
			log.error("Failed to query for unfinished activities: %@", errorInfo(error))
		}
		signpost.end(name: "hasUnfinishedActivity", idObject: activityDefinition)
		return false
	}

	private final func basicFetchRequest() -> NSFetchRequest<Activity> {
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "definition.name == %@", activityDefinition.name)
		return fetchRequest
	}
}
