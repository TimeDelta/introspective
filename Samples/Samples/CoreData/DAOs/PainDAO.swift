//
//  PainDAO.swift
//  Samples
//
//  Created by Bryan Nova on 6/16/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation
import os

import Common
import DependencyInjection
import Persistence
import Settings

// sourcery: AutoMockable
public protocol PainDAO {
	func getPainRecords(from minDate: Date?, to maxDate: Date?) throws -> [Pain]
	func createPain(
		timestamp: Date,
		rating: Double,
		min: Double?,
		max: Double?,
		location: String?,
		note: String?
	) throws -> Pain
	/// - Returns: The most recently recorded pain or nil if no pain records are present.
	func getMostRecentPain() throws -> Pain?
}

extension PainDAO {
	public func createPain(
		timestamp: Date = Date(),
		rating: Double,
		min: Double? = nil,
		max: Double? = nil,
		location: String? = nil,
		note: String? = nil
	) throws -> Pain {
		try createPain(timestamp: timestamp, rating: rating, min: min, max: max, location: location, note: note)
	}
}

public final class PainDAOImpl: SingleDateSampleDAO<PainImpl>, PainDAO {
	private typealias Me = PainDAOImpl

	private static let signpost =
		Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "PainDAO"))

	internal init() {
		super.init(dateAttribute: CommonSampleAttributes.timestamp)
	}

	public func getPainRecords(from minDate: Date?, to maxDate: Date?) throws -> [Pain] {
		let signpostName: StaticString = "getPainsFromTo"
		Me.signpost.begin(name: signpostName)

		let fetchRequest: NSFetchRequest<PainImpl> = PainImpl.fetchRequest()
		fetchRequest.predicate = dateSpanPredicate(from: minDate as NSDate?, to: maxDate as NSDate?)

		let pains = try injected(Database.self).query(fetchRequest)
		Me.signpost.end(name: signpostName, "# pains fetched: %d", pains.count)
		return pains
	}

	@discardableResult
	public final func createPain(
		timestamp _: Date,
		rating: Double,
		min: Double?,
		max: Double?,
		location: String?,
		note: String?
	) throws -> Pain {
		let transaction = injected(Database.self).transaction()
		let pain = try transaction.new(PainImpl.self)
		pain.date = Date()
		pain.rating = rating
		pain.note = note
		pain.location = location
		pain.minRating = min ?? injected(Settings.self).minPain
		pain.maxRating = max ?? injected(Settings.self).maxPain
		try transaction.commit()
		return try injected(Database.self).pull(savedObject: pain)
	}

	public final func getMostRecentPain() throws -> Pain? {
		let fetchRequest: NSFetchRequest<PainImpl> = PainImpl.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
		let pains = try injected(Database.self).query(fetchRequest)
		guard pains.count > 0 else { return nil }
		return pains[0]
	}
}
