//
//  ActivityIntentInfo.swift
//  SiriIntents
//
//  Created by Bryan Nova on 7/2/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import Samples

public final class ActivityIntentInfo {
	public final let identifier: String
	public final let displayString: String
	public final let startDate: DateComponents
	public final let startTimeZone: String
	public final let endDate: DateComponents
	public final let endTimeZone: String
	public final let note: String
	public final let extraTags: [String]

	public init(_ activity: Activity) {
		identifier = activity.definition.name
		displayString = identifier
		startDate = activity.startDate
		startTimeZone = activity.startTimeZone ?? ""
		endDate = activity.endDate ?? Date()
		endTimeZone = activity.endTimeZone ?? ""
		note = activity.note ?? ""
		extraTags = []
	}
}
