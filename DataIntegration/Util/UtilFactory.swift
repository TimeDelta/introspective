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
	fileprivate static let realHKQuantitySampleUtil = NumericSampleUtil()
	fileprivate static let realTextNormalizationUtil = TextNormalizationUtil()
	fileprivate static let realSampleUtil = SampleUtil()
	fileprivate static let realTimeConstraintUtil = TimeConstraintUtil()
	fileprivate static let realSearchUtil = SearchUtil()

	public var calendarUtil: CalendarUtil { get { return Me.realCalendarUtil } }
	public var numericSampleUtil: NumericSampleUtil { get { return Me.realHKQuantitySampleUtil } }
	public var textNormalizationUtil: TextNormalizationUtil { get { return Me.realTextNormalizationUtil } }
	public var sampleUtil: SampleUtil { get { return Me.realSampleUtil } }
	public var timeConstraintUtil: TimeConstraintUtil { get { return Me.realTimeConstraintUtil } }
	public var searchUtil: SearchUtil { get { return Me.realSearchUtil } }
}
