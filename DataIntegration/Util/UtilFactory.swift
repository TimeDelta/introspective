//
//  UtilFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class UtilFactory {

	fileprivate static let realCalendarUtil = CalendarUtil()
	fileprivate static let realHKQuantitySampleUtil = HKQuantitySampleUtil()
	fileprivate static let realHKSampleUtil = HKSampleUtil()

	public var calendarUtil: CalendarUtil { return UtilFactory.realCalendarUtil }
	public var hkQuantitySampleUtil: HKQuantitySampleUtil { return UtilFactory.realHKQuantitySampleUtil }
	public var hkSampleUtil: HKSampleUtil { return UtilFactory.realHKSampleUtil }
}
