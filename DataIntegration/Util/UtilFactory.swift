//
//  UtilFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class UtilFactory {

	fileprivate typealias Me = UtilFactory

	fileprivate static let realCalendarUtil = CalendarUtil()
	fileprivate static let realHKQuantitySampleUtil = HKQuantitySampleUtil()
	fileprivate static let realHKSampleUtil = HKSampleUtil()
	fileprivate static let realTextNormalizationUtil = TextNormalizationUtil()

	public var calendarUtil: CalendarUtil { return Me.realCalendarUtil }
	public var hkQuantitySampleUtil: HKQuantitySampleUtil { return Me.realHKQuantitySampleUtil }
	public var hkSampleUtil: HKSampleUtil { return Me.realHKSampleUtil }
	public var textNormalizationUtil: TextNormalizationUtil { return Me.realTextNormalizationUtil }
}
