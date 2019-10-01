//
//  MoodUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 12/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection
import Persistence
import Settings

//sourcery: AutoMockable
public protocol MoodUtil {

	func scaleMoods() throws
	func scaleMood(_ mood: Mood)
}

public final class MoodUtilImpl: MoodUtil {

	private final let log = Log()

	public final func scaleMoods() throws {
		do {
			let transaction = DependencyInjector.get(Database.self).transaction()
			let moods = try transaction.query(MoodImpl.fetchRequest())
			for mood in moods {
				scaleMood(mood)
			}
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		} catch {
			log.error("Failed to scale old moods: %@", errorInfo(error))
			throw error
		}
	}

	/// - Note: This method will not save the database.
	public final func scaleMood(_ mood: Mood) {
		let oldMin = mood.minRating
		let oldMax = mood.maxRating
		let oldRating = mood.rating
		let newMin = DependencyInjector.get(Settings.self).minMood
		let newMax = DependencyInjector.get(Settings.self).maxMood
		mood.minRating = newMin
		mood.maxRating = newMax
		// (r1 - min1) / (max1 - min1) = (r2 - min2) / (max2 - min2)
		// r2 = (max2 - min2) * (r1 - min1) / (max1 - min1) + min2
		mood.rating = ((newMax - newMin) * (oldRating - oldMin) / (oldMax - oldMin)) + newMin
	}
}
