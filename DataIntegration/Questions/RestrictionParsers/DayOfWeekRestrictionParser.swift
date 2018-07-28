//
//  DayOfWeekRestrictionParser.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public class DayOfWeekRestrictionParser {

	public enum ErrorTypes: Error {
		case MultipleDaysOfWeekNotSupported
		case UnparsableQuantity
	}

	public func resolveDayOfWeekRestrictions(_ questionPart: Labels) throws -> (date: Date?, dayOfWeek: DayOfWeek?) {
		let dayOfWeekLabels = questionPart.byTag[Tags.dayOfWeek]
		if dayOfWeekLabels != nil {
			if dayOfWeekLabels!.count != 1 {
				throw ErrorTypes.MultipleDaysOfWeekNotSupported
			}
			let dayOfWeekLabel = dayOfWeekLabels![0]
			let nearbyWhichTagResolution = try resolveRestrictionWithNearbyWhichTag(for: dayOfWeekLabel, in: questionPart)
			if nearbyWhichTagResolution.date != nil || nearbyWhichTagResolution.dayOfWeek != nil {
				return nearbyWhichTagResolution
			}

			return (nil, try DayOfWeek.fromString(dayOfWeekLabel.token))
		}
		return (nil, nil)
	}

	fileprivate func resolveRestrictionWithNearbyWhichTag(for dayOfWeekLabel: Labels.Label, in questionPart: Labels) throws -> (date: Date?, dayOfWeek: DayOfWeek?) {
		let distanceToNearestWhichTag = questionPart.shortestDistance(from: dayOfWeekLabel, toLabelWith: Tags.which)!
		if distanceToNearestWhichTag > 0 && distanceToNearestWhichTag <= 2 {
			let dayOfWeekLabelIndex = questionPart.indexOf(label: dayOfWeekLabel)
			let nearestWhichLabel = try getNearestWhichLabel(to: dayOfWeekLabelIndex, in: questionPart)

			if distanceToNearestWhichTag == 1 {
				let dayOfWeek = try DayOfWeek.fromString(dayOfWeekLabel.token)
				if whichTokenRepresentsMostRecent(nearestWhichLabel.token) {
					// "last sunday", "the most recent saturday", "this friday", "this past tuesday"
					return (Date().previous(dayOfWeek), nil)
				} else {
					// "2 sundays ago"
					let shortestDistanceToPreceedingQuantity = questionPart.shortestDistance(from: dayOfWeekLabel, toPreceedingLabelWith: Tags.quantity)
					if shortestDistanceToPreceedingQuantity == 1 {
						let nearestPreceedingQuantityToken = questionPart.byIndex[dayOfWeekLabelIndex - 1].token
						let quantity = Int(nearestPreceedingQuantityToken)
						if quantity == nil {
							os_log("Could not parse QUANTITY token into an Int: '$@'", type: .error, nearestPreceedingQuantityToken)
							throw ErrorTypes.UnparsableQuantity
						}

						return (date(for: quantity!, daysOfWeekAgo: dayOfWeek), nil)
					}
				}
			} else if distanceToNearestWhichTag == 2 {
				// TODO - "over the past 3 sundays"
			} else if distanceToNearestWhichTag == 4 {
				// TODO - "saturday from 2 weeks ago"
			}
		}
		return (nil, nil)
	}

	fileprivate func getNearestWhichLabel(to index: Int, in questionPart: Labels) throws -> Labels.Label {
		let nearestWhichLabels = try questionPart.findNearestLabelWith(tag: Tags.which, to: index)!
		let nearestWhichLabel = nearestWhichLabels[0]

		if nearestWhichLabels.count > 1 {
			os_log(
				"Found multiple WHICH tags equidistant from day of week token in '$@': '$@' and '$@'. Using '$@'.",
				type: .info,
				String(describing: questionPart),
				nearestWhichLabels[0].token,
				nearestWhichLabels[1].token,
				nearestWhichLabel.token)
		}

		return nearestWhichLabel
	}

	fileprivate func date(for quantity: Int, daysOfWeekAgo dayOfWeek: DayOfWeek) -> Date {
		var date = Date()
		for _ in 0 ..< quantity {
			date = date.previous(dayOfWeek)
		}
		return date
	}

	fileprivate func whichTokenRepresentsMostRecent(_ token: String) -> Bool {
		return token == "most recent" || token == "last" || token.contains("this")
	}
}
