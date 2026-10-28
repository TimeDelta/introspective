//
//  MoodUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 12/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Common
import DependencyInjection
import Persistence
import Settings

// sourcery: AutoMockable
public protocol MoodUtil {
	func scaleMoods() throws
	func scaleMood(_ mood: inout Mood)
}

public final class MoodUtilImpl: MoodUtil {
	private typealias Me = MoodUtilImpl

	private static let log = Log()

	public final func scaleMoods() throws {
		do {
			let transaction = injected(Database.self).transaction()
			let moods = try transaction.query(MoodImpl.fetchRequest())
			for var mood: Mood in moods {
				scaleMood(&mood)
			}
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		} catch {
			Me.log.error("Failed to scale old moods: %@", errorInfo(error))
			throw error
		}
	}

	/// - Note: This method will not save the database.
	public final func scaleMood(_ mood: inout Mood) {
		let oldMin = mood.minRating
		let oldMax = mood.maxRating
		let oldRating = mood.rating
		let newMin = injected(Settings.self).minMood
		let newMax = injected(Settings.self).maxMood
		mood.minRating = newMin
		mood.maxRating = newMax
		// (r1 - min1) / (max1 - min1) = (r2 - min2) / (max2 - min2)
		// r2 = (max2 - min2) * (r1 - min1) / (max1 - min1) + min2
		mood.rating = ((newMax - newMin) * (oldRating - oldMin) / (oldMax - oldMin)) + newMin
	}
}

/// Manual, additive exchange. Existing records and deletions are not synchronized.
@available(iOS 18.0, *)
public final class MoodHealthExchange {
	public enum ExchangeError: LocalizedError {
		case unavailable, authorizationFailed, writeDenied, invalidRating, saveFailed
		public var errorDescription: String? {
			switch self {
			case .unavailable: return "Health data is not available on this device."
			case .authorizationFailed: return "Health authorization could not be completed."
			case .writeDenied: return "Allow Introspective to write State of Mind in Health Settings, then try again."
			case .invalidRating: return "A mood has an invalid rating or rating range. No moods were exported."
			case .saveFailed: return "Health could not save the mood. Please try again."
			}
		}
	}

	internal static let exportMarker = "com.bnova.Introspective.moodExport"
	private let store = HKHealthStore()
	private let type = HKObjectType.stateOfMindType()

	public init() {}

	/// Both scales are continuous; a zero-width range has no meaningful valence.
	public static func valence(rating: Double, min: Double, max: Double) throws -> Double {
		guard rating.isFinite, min.isFinite, max.isFinite, max > min,
			rating >= min, rating <= max else { throw ExchangeError.invalidRating }
		let value = 2 * ((rating - min) / (max - min)) - 1
		guard value.isFinite else { throw ExchangeError.invalidRating }
		return Swift.max(-1, Swift.min(1, value))
	}

	private func authorize(write: Bool, completion: @escaping (Error?) -> Void) {
		guard HKHealthStore.isHealthDataAvailable() else {
			completion(ExchangeError.unavailable)
			return
		}
		store.requestAuthorization(toShare: write ? [type] : [], read: write ? [] : [type]) { success, error in
			DispatchQueue.main.async {
				if let error = error { completion(error); return }
				guard success else { completion(ExchangeError.authorizationFailed); return }
				if write && self.store.authorizationStatus(for: self.type) != .sharingAuthorized {
					completion(ExchangeError.writeDenied)
					return
				}
				completion(nil)
			}
		}
	}

	public func importMoods(completion: @escaping (Result<Int, Error>) -> Void) {
		authorize(write: false) { error in
			if let error = error { completion(.failure(error)); return }
			let query = HKSampleQuery(sampleType: self.type, predicate: nil,
				limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
				DispatchQueue.main.async {
					if let error = error { completion(.failure(error)); return }
					do { completion(.success(try self.importSamples(samples as? [HKStateOfMind] ?? []))) }
					catch { completion(.failure(error)) }
				}
			}
			self.store.execute(query)
		}
	}

	/// Called on the main queue so Core Data objects stay on their context's queue.
	internal func importSamples(_ samples: [HKStateOfMind]) throws -> Int {
		let transaction = injected(Database.self).transaction()
		let existing = try transaction.query(MoodImpl.fetchRequest())
		var knownIDs = Set(existing.compactMap { $0.healthKitUUID })
		let scale = injected(Settings.self).scaleMoodsOnImport
		let minimum = scale ? injected(Settings.self).minMood : -1
		let maximum = scale ? injected(Settings.self).maxMood : 1
		guard minimum.isFinite, maximum.isFinite, maximum > minimum else { throw ExchangeError.invalidRating }
		var count = 0
		for sample in samples {
			// Never import our exports, including after a partial save or retry.
			guard sample.metadata?[Self.exportMarker] as? Bool != true,
				knownIDs.insert(sample.uuid.uuidString).inserted else { continue }
			let mood = try transaction.new(MoodImpl.self)
			mood.setSource(.health)
			mood.date = sample.startDate
			mood.timeZone = (sample.metadata?[HKMetadataKeyTimeZone] as? String).flatMap(TimeZone.init(identifier:))
			mood.rating = minimum + (sample.valence + 1) / 2 * (maximum - minimum)
			mood.minRating = minimum
			mood.maxRating = maximum
			mood.healthKitUUID = sample.uuid.uuidString
			count += 1
		}
		try transaction.commit()
		return count
	}

	public func exportMoods(completion: @escaping (Result<Int, Error>) -> Void) {
		authorize(write: true) { error in
			if let error = error { completion(.failure(error)); return }
			do {
				let transaction = injected(Database.self).transaction()
				let moods = try transaction.query(MoodImpl.fetchRequest()).filter {
					$0.healthKitUUID == nil && $0.getSource() != .health
				}
				// Validate the entire batch before making any Health writes.
				let valences = try moods.map { try Self.valence(rating: $0.rating, min: $0.minRating, max: $0.maxRating) }
				let samples = zip(moods, valences).map { mood, valence in
					HKStateOfMind(date: mood.originalTimestamp, kind: .momentaryEmotion, valence: valence,
						labels: [], associations: [], metadata: [
							HKMetadataKeySyncIdentifier: mood.objectID.uriRepresentation().absoluteString,
							HKMetadataKeySyncVersion: 1,
							Self.exportMarker: true,
							HKMetadataKeyTimeZone: (mood.timeZone ?? .current).identifier,
						])
				}
				guard !samples.isEmpty else { completion(.success(0)); return }
				self.store.save(samples) { success, error in
					DispatchQueue.main.async {
						if let error = error { completion(.failure(error)); return }
						guard success else { completion(.failure(ExchangeError.saveFailed)); return }
						do {
							for (mood, sample) in zip(moods, samples) { mood.healthKitUUID = sample.uuid.uuidString }
							try transaction.commit()
							completion(.success(samples.count))
						} catch { completion(.failure(error)) }
					}
				}
			} catch { completion(.failure(error)) }
		}
	}
}
