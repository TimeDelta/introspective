//
//  RecordIntegerMoodIntentHandler.swift
//  SiriIntents
//
//  Created by Bryan Nova on 6/26/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import Intents

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

public final class RecordIntegerMoodIntentHandler: NSObject, RecordIntegerMoodIntentHandling {
	private let log = Log()

	public func resolveRating(
		for intent: RecordIntegerMoodIntent,
		with completion: @escaping (RecordIntegerMoodRatingResolutionResult) -> Void
	) {
		guard let rating = intent.rating as? Int else {
			completion(RecordIntegerMoodRatingResolutionResult.needsValue())
			return
		}
		guard rating <= Int(injected(Settings.self).maxMood) else {
			completion(RecordIntegerMoodRatingResolutionResult.unsupported(forReason: .greaterThanMaximumValue))
			return
		}
		guard rating >= Int(injected(Settings.self).minMood) else {
			completion(RecordIntegerMoodRatingResolutionResult.unsupported(forReason: .lessThanMinimumValue))
			return
		}
		completion(RecordIntegerMoodRatingResolutionResult.success(with: rating))
	}

	public func resolveRating(
		for intent: RecordIntegerMoodIntent,
		with completion: @escaping (INIntegerResolutionResult) -> Void
	) {
		guard let rating = intent.rating as? Int else {
			completion(INIntegerResolutionResult.needsValue())
			return
		}
		guard rating <= Int(injected(Settings.self).maxMood) else {
			completion(INIntegerResolutionResult.unsupported())
			return
		}
		guard rating >= Int(injected(Settings.self).minMood) else {
			completion(INIntegerResolutionResult.unsupported())
			return
		}
		completion(INIntegerResolutionResult.success(with: rating))
	}

	public func provideRatingOptions(
		for _: RecordIntegerMoodIntent,
		with completion: @escaping ([Int]?, Error?) -> Void
	) {
		let minValue = Int(injected(Settings.self).minMood)
		let maxValue = Int(injected(Settings.self).maxMood)
		completion(Array(minValue ... maxValue), nil)
	}

	public func handle(
		intent: RecordIntegerMoodIntent,
		completion: @escaping (RecordIntegerMoodIntentResponse) -> Void
	) {
		guard let rating = intent.rating as? Int else {
			completion(RecordIntegerMoodIntentResponse(code: .failure, userActivity: nil))
			return
		}
		do {
			let mood = try injected(MoodDAO.self).createMood(rating: Double(rating))
			let message = injected(MoodUiUtil.self).feedbackMessage(
				for: mood.rating,
				min: mood.minRating,
				max: mood.maxRating
			)
			injected(Database.self).setModifiedExternally(true)
			completion(RecordIntegerMoodIntentResponse.success(message: message))
		} catch {
			if let displayableError = error as? DisplayableError {
				let errorMessage = displayableError.displayableDescription ?? displayableError.displayableTitle
				completion(RecordIntegerMoodIntentResponse.failure(message: errorMessage))
			} else {
				completion(
					RecordIntegerMoodIntentResponse
						.failure(
							message: "Something went wrong while trying to mark your mood. Sorry for the invonvenience."
						)
				)
			}
		}
	}
}
