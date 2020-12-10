//
//  FatigueDAO.swift
//  Samples
//
//  Created by Bryan Nova on 12/8/20.
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
public protocol FatigueDAO {
	func getFatigueRecords(from minDate: Date?, to maxDate: Date?) throws -> [Fatigue]
	func createFatigue(timestamp: Date, rating: Double, min: Double?, max: Double?, note: String?) throws -> Fatigue
	/// - Returns: The most recently recorded fatigue or nil if no fatigue records are present.
	func getMostRecentFatigue() throws -> Fatigue?
}

extension FatigueDAO {
	public func createFatigue(
		timestamp: Date = Date(),
		rating: Double,
		min: Double? = nil,
		max: Double? = nil,
		note: String? = nil
	) throws -> Fatigue {
		try createFatigue(timestamp: timestamp, rating: rating, min: min, max: max, note: note)
	}
}

public final class FatigueDAOImpl: SingleDateSampleDAO<FatigueImpl>, FatigueDAO {
	private typealias Me = FatigueDAOImpl

	private static let signpost =
		Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "FatigueDAO"))

	internal init() {
		super.init(dateAttribute: CommonSampleAttributes.timestamp)
	}

	public func getFatigueRecords(from minDate: Date?, to maxDate: Date?) throws -> [Fatigue] {
		let signpostName: StaticString = "getFatiguesFromTo"
		Me.signpost.begin(name: signpostName)

		let fetchRequest: NSFetchRequest<FatigueImpl> = FatigueImpl.fetchRequest()
		fetchRequest.predicate = dateSpanPredicate(from: minDate as NSDate?, to: maxDate as NSDate?)

		let fatigues = try injected(Database.self).query(fetchRequest)
		Me.signpost.end(name: signpostName, "# fatigues fetched: %d", fatigues.count)
		return fatigues
	}

	@discardableResult
	public final func createFatigue(
		timestamp _: Date,
		rating: Double,
		min: Double?,
		max: Double?,
		note: String?
	) throws -> Fatigue {
		let transaction = injected(Database.self).transaction()
		let fatigue = try transaction.new(FatigueImpl.self)
		fatigue.date = Date()
		fatigue.rating = rating
		fatigue.note = note
		fatigue.minRating = min ?? injected(Settings.self).minFatigue
		fatigue.maxRating = max ?? injected(Settings.self).maxFatigue
		try transaction.commit()
		return try injected(Database.self).pull(savedObject: fatigue)
	}

	public final func getMostRecentFatigue() throws -> Fatigue? {
		let fetchRequest: NSFetchRequest<FatigueImpl> = FatigueImpl.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
		let fatigues = try injected(Database.self).query(fetchRequest)
		guard fatigues.count > 0 else { return nil }
		return fatigues[0]
	}
}
