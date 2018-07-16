//
//  ActivityInstance.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class ActivityInstance: NSObject {

	var activity: Activity
	var startTimestamp: Date
	var endTimestamp: Date

	init(activity: Activity) {
		self.activity = activity
		startTimestamp = Date()
		endTimestamp = Date()
	}
}
