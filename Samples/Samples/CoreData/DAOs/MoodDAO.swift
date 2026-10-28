//
//  MoodDAO.swift
//  Samples
//
//  Created by Bryan Nova on 6/27/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation
import os

import Common
import DependencyInjection
import Persistence
import Settings

// sourcery: AutoMockable
public protocol MoodDAO {
	func getMoods(from minDate: Date?, to maxDate: Date?) throws -> [Mood]
	func createMood(timestamp: Date, rating: Double, min: Double?, max: Double?, note: String?) throws -> Mood
	/// - Returns: The most recently recorded mood or nil if no mood records are present.
	func getMostRecentMood() throws -> Mood?
}

extension MoodDAO {
	public func createMood(
		timestamp: Date = Date(),
		rating: Double,
		min: Double? = nil,
		max: Double? = nil,
		note: String? = nil
	) throws -> Mood {
		try createMood(timestamp: timestamp, rating: rating, min: min, max: max, note: note)
	}
}

public final class MoodDAOImpl: SingleDateSampleDAO<MoodImpl>, MoodDAO {
	private typealias Me = MoodDAOImpl

	private static let signpost =
		Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "MoodDAO"))

	internal init() {
		super.init(dateAttribute: CommonSampleAttributes.timestamp)
	}

	public func getMoods(from minDate: Date?, to maxDate: Date?) throws -> [Mood] {
		let signpostName: StaticString = "getMoodsFromTo"
		Me.signpost.begin(name: signpostName)

		let fetchRequest: NSFetchRequest<MoodImpl> = MoodImpl.fetchRequest()
		fetchRequest.predicate = dateSpanPredicate(from: minDate as NSDate?, to: maxDate as NSDate?)

		let moods = try injected(Database.self).query(fetchRequest)
		Me.signpost.end(name: signpostName, "# moods fetched: %d", moods.count)
		return moods
	}

	@discardableResult
	public final func createMood(
		timestamp: Date,
		rating: Double,
		min: Double?,
		max: Double?,
		note: String?
	) throws -> Mood {
		let transaction = injected(Database.self).transaction()
		let mood = try transaction.new(MoodImpl.self)
		mood.date = timestamp
		mood.rating = rating
		mood.note = note
		mood.minRating = min ?? injected(Settings.self).minMood
		mood.maxRating = max ?? injected(Settings.self).maxMood
		mood.setSource(.introspective)
		try transaction.commit()
		return try injected(Database.self).pull(savedObject: mood)
	}

	public final func getMostRecentMood() throws -> Mood? {
		let fetchRequest: NSFetchRequest<MoodImpl> = MoodImpl.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
		let moods = try injected(Database.self).query(fetchRequest)
		guard moods.count > 0 else { return nil }
		return moods[0]
	}
}

/// Descriptive statistics for a set of check-ins, respecting each record's original rating scale.
public struct MoodReviewSummary {
	public let checkInCount: Int
	public let recordedDayCount: Int
	public let ratedCheckInCount: Int
	/// Average position on the original scales: zero is the minimum, one is the maximum.
	public let averagePosition: Double?

	public init(moods: [Mood], calendar: Calendar = .current) {
		checkInCount = moods.count
		recordedDayCount = Set(moods.map { calendar.startOfDay(for: $0.date) }).count
		let positions: [Double] = moods.compactMap { mood in
			let span = mood.maxRating - mood.minRating
			guard mood.rating.isFinite, mood.minRating.isFinite, mood.maxRating.isFinite,
				span.isFinite, span > 0, mood.rating >= mood.minRating, mood.rating <= mood.maxRating else { return nil }
			return (mood.rating - mood.minRating) / span
		}
		ratedCheckInCount = positions.count
		averagePosition = positions.isEmpty ? nil : positions.reduce(0, +) / Double(positions.count)
	}

	/// Calendar days including today; avoids treating daylight-saving days as 24-hour periods.
	public static func dateInterval(forLastDays days: Int, endingOn date: Date = Date(),
		calendar: Calendar = .current) -> DateInterval {
		let today = calendar.startOfDay(for: date)
		let start = calendar.date(byAdding: .day, value: 1 - max(1, days), to: today)!
		let end = calendar.date(byAdding: .day, value: 1, to: today)!
		return DateInterval(start: start, end: end)
	}
}
