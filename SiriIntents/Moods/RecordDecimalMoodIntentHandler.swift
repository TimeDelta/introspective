//
//  RecordDecimalMoodIntentHandler.swift
//  Introspective
//
//  Created by Bryan Nova on 6/27/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import Intents

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

public final class RecordDecimalMoodIntentHandler: NSObject, RecordDecimalMoodIntentHandling {

	@available(iOS 13.0, *)
	@available(iOSApplicationExtension 13.0, *)
	public func resolveRating(for intent: RecordDecimalMoodIntent, with completion: @escaping (RecordDecimalMoodRatingResolutionResult) -> Void) {
		guard let rating = intent.rating as? Double else {
			completion(RecordDecimalMoodRatingResolutionResult.needsValue())
			return
		}
		completion(RecordDecimalMoodRatingResolutionResult.success(with: rating))
	}


	public func resolveRating(for intent: RecordDecimalMoodIntent, with completion: @escaping (INDoubleResolutionResult) -> Void) {
		guard let rating = intent.rating as? Double else {
			completion(INDoubleResolutionResult.needsValue())
			return
		}
		completion(INDoubleResolutionResult.success(with: rating))
	}

	public func handle(intent: RecordDecimalMoodIntent, completion: @escaping (RecordDecimalMoodIntentResponse) -> Void) {
		guard let ratingPercent = intent.rating as? Double else {
			completion(RecordDecimalMoodIntentResponse(code: .failure, userActivity: nil))
			return
		}
		do {
			let minRating = DependencyInjector.get(Settings.self).minMood
			let maxRating = DependencyInjector.get(Settings.self).maxMood
			let rating = minRating + (maxRating - minRating) * ratingPercent

			let mood = try DependencyInjector.get(MoodDAO.self).createMood(rating: rating)
			let message = DependencyInjector.get(MoodUiUtil.self).feedbackMessage(
				for: mood.rating,
				min: mood.minRating,
				max: mood.maxRating)
			completion(RecordDecimalMoodIntentResponse.success(message: message))
		} catch {
			if let displayableError = error as? DisplayableError {
				let errorMessage = displayableError.displayableDescription ?? displayableError.displayableTitle
				completion(RecordDecimalMoodIntentResponse.failure(message: errorMessage))
			} else {
				completion(RecordDecimalMoodIntentResponse.failure(message: "Something went wrong while trying to mark your mood. Sorry for the invonvenience."))
			}
		}
	}
}

