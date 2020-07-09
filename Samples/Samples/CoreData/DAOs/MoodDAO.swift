//
//  MoodDAO.swift
//  Samples
//
//  Created by Bryan Nova on 6/27/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection
import Persistence
import Settings

// sourcery: AutoMockable
public protocol MoodDAO {
	func createMood(timestamp: Date, rating: Double, min: Double?, max: Double?, note: String?) throws -> Mood
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

public final class MoodDAOImpl: MoodDAO {
	@discardableResult
	public final func createMood(
		timestamp _: Date,
		rating: Double,
		min: Double?,
		max: Double?,
		note: String?
	) throws -> Mood {
		let transaction = DependencyInjector.get(Database.self).transaction()
		let mood = try transaction.new(MoodImpl.self)
		mood.date = Date()
		mood.rating = rating
		mood.note = note
		mood.minRating = min ?? DependencyInjector.get(Settings.self).minMood
		mood.maxRating = max ?? DependencyInjector.get(Settings.self).maxMood
		mood.setSource(.introspective)
		try transaction.commit()
		return try DependencyInjector.get(Database.self).pull(savedObject: mood)
	}
}
