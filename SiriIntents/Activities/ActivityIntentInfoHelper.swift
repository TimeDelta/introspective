//
//  ActivityIntentInfoExtensions.swift
//  SiriIntents
//
//  Created by Bryan Nova on 7/2/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftDate

import Samples

extension ActivityIntentInfo {

	public convenience init(_ activity: Activity) {
		self.init(identifier: activity.definition.name, display: activity.definition.name)

		startDate = activity.start.dateComponents
		endDate = activity.end?.dateComponents

		startTimeZone = activity.startDateTimeZone
		endTimeZone = activity.endDateTimeZone

		duration = NSNumber(value: (activity.start - (activity.end ?? Date())).timeInterval)
		note = activity.note
		extraTags = activity.tagsArray().map{ t in t.name }
	}
}
