//
//  MoodDataTestUtil.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
@testable import Introspective

public class MoodDataTestUtil {

	@discardableResult
	public static func createMood(
		note: String? = nil,
		rating: Double = 0.0,
		timestamp: Date = Date(),
		min: Double = 1,
		max: Double = 7)
	-> MoodImpl {
		let transaction = DependencyInjector.db.transaction()
		let mood = try! transaction.new(MoodImpl.self)
		mood.rating = rating
		mood.timestamp = timestamp
		mood.note = note
		mood.minRating = min
		mood.maxRating = max
		try! transaction.commit()
		return try! DependencyInjector.db.pull(savedObject: mood)
	}
}
