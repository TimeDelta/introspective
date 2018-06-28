//
//  HeartRate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class HeartRate: NSObject {

	var value: Double
	var timestamp: Date

	init(value: Double) {
		self.value = value
		self.timestamp = Date()
	}

	init(value: Double, timestamp: Date) {
		self.value = value
		self.timestamp = timestamp
	}
}
