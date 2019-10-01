//
//  MoodDataTestUtil.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
@testable import Introspective
@testable import DependencyInjection
@testable import Persistence
@testable import Samples

public class MoodDataTestUtil {

	@discardableResult
	public static func createMood(
		note: String? = nil,
		rating: Double = 0.0,
		timestamp: Date = Date(),
		min: Double = 1,
		max: Double = 7,
		source: Sources.MoodSourceNum = .introspective)
	-> MoodImpl {
		let transaction = DependencyInjector.get(Database.self).transaction()
		let mood = try! transaction.new(MoodImpl.self)
		mood.rating = rating
		mood.date = timestamp
		mood.note = note
		mood.minRating = min
		mood.maxRating = max
		mood.setSource(source)
		try! transaction.commit()
		return try! DependencyInjector.get(Database.self).pull(savedObject: mood)
	}
}
