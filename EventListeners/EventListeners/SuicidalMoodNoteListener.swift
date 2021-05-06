//
//  SuicidalMoodNoteListener.swift
//  EventListeners
//
//  Created by Bryan Nova on 5/6/21.
//

import Foundation
import NaturalLanguage
import SwiftDate
import UserNotifications

import Common
import DependencyInjection
import Notifications
import Samples

/// Current implementation is simplistic, only looking at mood rating and sentence embedding differences from some target sentences.
final class SuicidalMoodNoteListener: EventListener {
	private typealias Me = SuicidalMoodNoteListener
	private static let log = Log()
	private static let maximumSentenceEmbeddingDistance = 0.1
	private static let targetSentences = [
		"Feeling suicidal",
		"Thinking of killing myself",
		"I just want to die",
		"I can't take this life anymore",
		"Please let me die",
		"I want to jump off the roof",
		"Thinking about shooting myself",
	]

	func observe() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(checkMoodNote),
			name: NotificationName.moodCreated.toName(),
			object: nil
		)
	}

	@objc final func checkMoodNote(notification: Notification) {
		guard let mood: Mood = value(for: .mood, from: notification) else {
			Me.log.error("No mood provided with create mood notification")
			return
		}
		guard let note = mood.note else { return }
		// in case user imports a lot of moods
		guard (Date() - 30.minutes).isBeforeDate(mood.date, granularity: .minute) else {
			return
		}

		if mood.rating == mood.minRating && containsSomethingLikeATargetSentence(noteText: note) {
			let content = UNMutableNotificationContent()
			content.title = NSString.localizedUserNotificationString(forKey: "Feeling suicidal?", arguments: nil)
			content.body = NSString.localizedUserNotificationString(
				forKey: "I promise you, as a two-time suicide survivor, that life is still worth living. There are people that can help.",
				arguments: nil
			)
			content.sound = UNNotificationSound.default
			content.categoryIdentifier = UserNotificationDelegate.feelingSuicidal.identifier
			injected(UiUtil.self).sendUserNotification(withContent: content, id: "SuicidalMoodNoteDetected")
		}
	}

	private func containsSomethingLikeATargetSentence(noteText: String) -> Bool {
		guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else {
			Me.log.error("Unable to get English embeddings")
			return false
		}
		let tokenizer = NLTokenizer(unit: .sentence)
		tokenizer.string = noteText

		var result = false
		tokenizer.enumerateTokens(in: noteText.startIndex ..< noteText.endIndex) { tokenRange, attributes in
			let sentence = String(noteText[tokenRange])
			for targetSentence in Me.targetSentences {
				let distance = embedding.distance(between: sentence, and: targetSentence, distanceType: .cosine)
				if distance <= Me.maximumSentenceEmbeddingDistance {
					result = true
					return false
				}
			}
			return true
		}
		return result
	}

	/// Retrieve the value for the specified `UserInfoKey` from the given notification.
	/// - Parameter keyIsOptional: If true, no error will be logged if the specified key does not exist in the user info.
	/// - Note: Automatically logs when key is missing, wrong type or the notification does not have any user info.
	private func value<Type>(
		for key: UserInfoKey,
		from notification: Notification,
		keyIsOptional: Bool = false
	) -> Type? {
		injected(UiUtil.self).value(for: key, from: notification, keyIsOptional: keyIsOptional)
	}
}
