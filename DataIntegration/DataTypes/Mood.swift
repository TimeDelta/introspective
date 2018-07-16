//
//  Mood.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class Mood: NSObject {

	let NOT_RATED: Double = Double.nan

	var timestamp: Date
	var rating: Double

	override init() {
		self.timestamp = Date()
		self.rating = NOT_RATED
	}

	init(rating: Double) {
		self.timestamp = Date()
		self.rating = rating
	}

	init(timestamp: Date) {
		self.timestamp = timestamp
		self.rating = NOT_RATED
	}
}
