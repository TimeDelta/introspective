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

	fileprivate static let realCalendarUtil = CalendarUtilImpl()
	fileprivate static let realHKQuantitySampleUtil = NumericSampleUtilImpl()
	fileprivate static let realTextNormalizationUtil = TextNormalizationUtilImpl()
	fileprivate static let realSampleUtil = SampleUtilImpl()
	fileprivate static let realTimeConstraintUtil = AttributeRestrictionUtilImpl()
	fileprivate static let realSearchUtil = SearchUtilImpl()
	fileprivate static let realStringUtil = StringUtilImpl()

	public var calendarUtil: CalendarUtil = Me.realCalendarUtil
	public var numericSampleUtil: NumericSampleUtil = Me.realHKQuantitySampleUtil
	public var textNormalizationUtil: TextNormalizationUtil = Me.realTextNormalizationUtil
	public var sampleUtil: SampleUtil = Me.realSampleUtil
	public var attributeRestrictionUtil: AttributeRestrictionUtil = Me.realTimeConstraintUtil
	public var searchUtil: SearchUtil = Me.realSearchUtil
	public var stringUtil: StringUtil = Me.realStringUtil
}
