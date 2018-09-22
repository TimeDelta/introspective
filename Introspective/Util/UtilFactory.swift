//
//  UtilFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class UtilFactory {

	private typealias Me = UtilFactory

	private static let realCalendarUtil = CalendarUtilImpl()
	private static let realHKQuantitySampleUtil = NumericSampleUtilImpl()
	private static let realTextNormalizationUtil = TextNormalizationUtilImpl()
	private static let realSampleUtil = SampleUtilImpl()
	private static let realTimeConstraintUtil = AttributeRestrictionUtilImpl()
	private static let realSearchUtil = SearchUtilImpl()
	private static let realStringUtil = StringUtilImpl()

	public final var calendarUtil: CalendarUtil = Me.realCalendarUtil
	public final var numericSampleUtil: NumericSampleUtil = Me.realHKQuantitySampleUtil
	public final var textNormalizationUtil: TextNormalizationUtil = Me.realTextNormalizationUtil
	public final var sampleUtil: SampleUtil = Me.realSampleUtil
	public final var attributeRestrictionUtil: AttributeRestrictionUtil = Me.realTimeConstraintUtil
	public final var searchUtil: SearchUtil = Me.realSearchUtil
	public final var stringUtil: StringUtil = Me.realStringUtil
}
