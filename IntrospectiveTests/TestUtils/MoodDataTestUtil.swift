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

	public static func createMood(note: String? = nil, rating: Double = 0.0, timestamp: Date = Date()) -> MoodImpl {
		let mood = DependencyInjector.sample.mood() as! MoodImpl
		mood.rating = rating
		mood.timestamp = timestamp
		mood.note = note
		return mood
	}
}
