//
//  MoodInfo.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 6/27/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

@testable import Samples

public final class MoodInfo: Info {

	var timestamp: Date
	var timeZone: TimeZone?
	var note: String?
	var rating: Double
	var minRating: Double
	var maxRating: Double
	var source: Sources.MoodSourceNum

	public init(
		timestamp: Date,
		timeZone: TimeZone? = nil,
		rating: Double,
		minRating: Double,
		maxRating: Double,
		note: String? = nil,
		source: Sources.MoodSourceNum
	) {
		self.timestamp = timestamp
		self.timeZone = timeZone
		self.rating = rating
		self.minRating = minRating
		self.maxRating = maxRating
		self.note = note
		self.source = source
	}

	public func getPredicates() -> [String : NSPredicate] {
		var predicates = [String : NSPredicate]()
		predicates["timestamp"] = datePredicateFor(fieldName: "timestamp", withinOneSecondOf: timestamp)
		predicates["rating"] = NSPredicate(format: "rating == %f", rating)
		predicates["minRating"] = NSPredicate(format: "minRating == %f", minRating)
		predicates["maxRating"] = NSPredicate(format: "maxRating == %f", maxRating)
		predicates["timestampTimeZoneId"] = timeZonePredicate(for: timeZone, field: "timestampTimeZoneId")
		predicates["note"] = optionalStringPredicate(for: note, fieldName: "note")
		predicates["source"] = NSPredicate(format: "source == %i", source.rawValue)
		return predicates
	}
}
