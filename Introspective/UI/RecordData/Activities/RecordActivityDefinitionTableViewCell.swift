//
//  RecordActivityDefinitionTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 11/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import os
import SwiftDate
import UIKit

import Common
import DependencyInjection
import Persistence
import Samples

public final class RecordActivityDefinitionTableViewCell: UITableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var nameLabel: UILabel!
	@IBOutlet final var mostRecentTimeLabel: UILabel!
	@IBOutlet final var totalDurationTodayLabel: UILabel!
	@IBOutlet final var currentInstanceDurationLabel: UILabel!
	@IBOutlet final var progressIndicator: UIActivityIndicatorView!

	// MARK: - Instance Variables

	public final var activityDefinition: ActivityDefinition! {
		didSet {
			timer?.invalidate()
			updateUiElements()
			timer = Timer.scheduledTimer(
				timeInterval: 1,
				target: self,
				selector: #selector(updateDurationLabels),
				userInfo: nil,
				repeats: true
			)
		}
	}

	public final var running: Bool {
		hasUnfinishedActivity()
	}

	private final var timer: Timer!

	private final let signpost =
		Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "ActivityDefinition Table Cell"))
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
				startText = DependencyInjector.get(CalendarUtil.self)
					.string(for: startDate, dateStyle: .short, timeStyle: .short)
			}
			mostRecentTimeLabel.text = startText + " -"
			if let endDate = mostRecentlyCompletedActivity.end {
				if startDate.isToday() {
					mostRecentTimeLabel.text! += " " + TimeOfDay(endDate).toString(.medium)
				} else if endDate.isToday() {
					mostRecentTimeLabel.text! += " Today, " + TimeOfDay(endDate).toString(.medium)
				} else {
					mostRecentTimeLabel.text! += " " + DependencyInjector.get(CalendarUtil.self)
						.string(for: endDate, dateStyle: .short, timeStyle: .short)
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
		var totalDuration: TimeDuration = TimeDuration(0.hours.timeInterval)
		for activity in getAllActivitiesForToday() {
			var duration = activity.duration
			if !activity.start.isToday() {
				if let endDate = activity.end {
					duration = TimeDuration(start: Date().start(of: .day), end: endDate)
				} else {
					duration = TimeDuration(start: Date().start(of: .day), end: Date())
				}
			}
			totalDuration += duration
		}
		if totalDuration > TimeDuration(0) {
			totalDurationTodayLabel.text = totalDuration.description
		} else {
			totalDurationTodayLabel.text = ""
		}
		totalDurationTodayLabel.accessibilityValue = totalDurationTodayLabel.text ?? ""
	}

	private final func getMostRecentlyStartedActivity() -> Activity? {
		do {
			return try DependencyInjector.get(ActivityDAO.self).getMostRecentlyStartedActivity(for: activityDefinition)
		} catch {
			signpost.end(name: "getMostRecentlyStartedActivity", idObject: activityDefinition)
			log.error("Failed to fetch activities: %@", errorInfo(error))
		}

		return nil
	}

	private final func getAllActivitiesForToday() -> [Activity] {
		do {
			return try DependencyInjector.get(ActivityDAO.self).getAllActivitiesForToday(activityDefinition)
		} catch {
			log.error("Failed to fetch activities: %@", errorInfo(error))
			return []
		}
	}

	private final func hasUnfinishedActivity() -> Bool {
		do {
			return try DependencyInjector.get(ActivityDAO.self).hasUnfinishedActivity(activityDefinition)
		} catch {
			log.error("Failed to query for unfinished activities: %@", errorInfo(error))
		}
		return false
	}
}
