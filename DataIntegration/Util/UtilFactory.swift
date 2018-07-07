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

	public var calendarUtil: CalendarUtil { get { return Me.realCalendarUtil } }
	public var hkQuantitySampleUtil: HKQuantitySampleUtil { get { return Me.realHKQuantitySampleUtil } }
	public var hkSampleUtil: HKSampleUtil { get { return Me.realHKSampleUtil } }
	public var textNormalizationUtil: TextNormalizationUtil { get { return Me.realTextNormalizationUtil } }
}
