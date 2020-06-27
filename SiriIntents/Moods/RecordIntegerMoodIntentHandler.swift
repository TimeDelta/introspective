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

	@available(iOS 13.0, *)
	@available(iOSApplicationExtension 13.0, *)
	public func resolveRating(for intent: RecordIntegerMoodIntent, with completion: @escaping (RecordIntegerMoodRatingResolutionResult) -> Void) {
		guard let rating = intent.rating as? Int else {
			completion(RecordIntegerMoodRatingResolutionResult.needsValue())
			return
		}
		completion(RecordIntegerMoodRatingResolutionResult.success(with: rating))
	}


	public func resolveRating(for intent: RecordIntegerMoodIntent, with completion: @escaping (INIntegerResolutionResult) -> Void) {
		guard let rating = intent.rating as? Int else {
			completion(INIntegerResolutionResult.needsValue())
			return
		}
		completion(INIntegerResolutionResult.success(with: rating))
	}

	public func provideRatingOptions(for intent: RecordIntegerMoodIntent, with completion: @escaping ([Int]?, Error?) -> Void) {
		let minValue = Int(DependencyInjector.get(Settings.self).minMood)
		let maxValue = Int(DependencyInjector.get(Settings.self).maxMood)
		completion(Array(minValue ... maxValue), nil)
	}

	public func handle(intent: RecordIntegerMoodIntent, completion: @escaping (RecordIntegerMoodIntentResponse) -> Void) {
		guard let rating = intent.rating as? Int else {
			completion(RecordIntegerMoodIntentResponse(code: .failure, userActivity: nil))
			return
		}
		do {
			let mood = try DependencyInjector.get(MoodDAO.self).createMood(rating: Double(rating))
			let message = DependencyInjector.get(MoodUiUtil.self).feedbackMessage(
				for: mood.rating,
				min: mood.minRating,
				max: mood.maxRating)
			completion(RecordIntegerMoodIntentResponse.success(message: message))
		} catch {
			if let displayableError = error as? DisplayableError {
				let errorMessage = displayableError.displayableDescription ?? displayableError.displayableTitle
				completion(RecordIntegerMoodIntentResponse.failure(message: errorMessage))
			} else {
				completion(RecordIntegerMoodIntentResponse.failure(message: "Something went wrong while trying to mark your mood. Sorry for the invonvenience."))
			}
		}
	}
}
