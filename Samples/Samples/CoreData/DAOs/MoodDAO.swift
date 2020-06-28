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

//sourcery: AutoMockable
public protocol MoodDAO {

	func createMood(timestamp: Date, rating: Double, note: String?) throws -> Mood
}

extension MoodDAO {

	public func createMood(timestamp: Date = Date(), rating: Double, note: String? = nil) throws -> Mood {
		return try createMood(timestamp: timestamp, rating: rating, note: note)
	}
}

public final class MoodDAOImpl: MoodDAO {

	@discardableResult
	public final func createMood(timestamp: Date, rating: Double, note: String?) throws -> Mood {
		let transaction = DependencyInjector.get(Database.self).transaction()
		let mood = try DependencyInjector.get(SampleFactory.self).mood(using: transaction)
		mood.date = Date()
		mood.rating = rating
		mood.note = note
		mood.minRating = DependencyInjector.get(Settings.self).minMood
		mood.maxRating = DependencyInjector.get(Settings.self).maxMood
		mood.setSource(.introspective)
		try transaction.commit()
		return mood
	}
}