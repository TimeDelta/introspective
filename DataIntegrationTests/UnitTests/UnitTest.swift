//
//  UnitTest.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import HealthKit
import SwiftyMocky
@testable import DataIntegration

class UnitTest: XCTestCase {

	let injectionProvider = InjectionProviderMock()

	let utilFactory = UtilFactory()
	let mockAttributeRestrictionUtil = AttributeRestrictionUtilMock()
	let mockCalendarUtil = CalendarUtilMock()
	let mockNumericSampleUtil = NumericSampleUtilMock()
	let mockSampleUtil = SampleUtilMock()
	let mockSearchUtil = SearchUtilMock()
	let mockStringUtil = StringUtilMock()
	let mockTextNormalizationUtil = TextNormalizationUtilMock()

	override func setUp() {
		super.setUp()
		DependencyInjector.injectionProvider = injectionProvider
		Given(injectionProvider, .utilFactory(willReturn: utilFactory))
		utilFactory.attributeRestrictionUtil = mockAttributeRestrictionUtil
		utilFactory.calendarUtil = mockCalendarUtil
		utilFactory.numericSampleUtil = mockNumericSampleUtil
		utilFactory.sampleUtil = mockSampleUtil
		utilFactory.searchUtil = mockSearchUtil
		utilFactory.stringUtil = mockStringUtil
		utilFactory.textNormalizationUtil = mockTextNormalizationUtil

		Matcher.default.register(Sample.self) { lhs,rhs in return lhs.equalTo(rhs) }
		Matcher.default.register(Attribute.self) { lhs,rhs in return lhs.equalTo(rhs) }
	}

	override func tearDown() {
		DependencyInjector.injectionProvider = ProductionInjectionProvider()
		super.tearDown()
	}

	func createSample(_ value: Double) -> Sample {
		return HeartRate(value)
	}

	func createSample(_ value: Double, _ date: Date) -> Sample {
		return HeartRate(value, .start, date)
	}

	func createSample(start: Date, end: Date, value: Double) -> Sample {
		return HeartRate(value, [.start : start, .end: end])
	}

	func createSamples(withValues values: [Double]) -> [Sample] {
		var samples = [Sample]()
		for value in values {
			samples.append(createSample(value))
		}
		return samples
	}

	func createSamples(withValues values: [(date: Date, value: Double)]) -> [Sample] {
		var samples = [Sample]()
		for (date, value) in values {
			samples.append(createSample(value, date))
		}
		return samples
	}

	func createSamples(withValues values: [(start: Date, end: Date, value: Double)]) -> [Sample] {
		var samples = [Sample]()
		for (start, end, value) in values {
			samples.append(createSample(start: start, end: end, value: value))
		}
		return samples
	}

	func oldDate() -> Date {
		var dateComponents: DateComponents = DateComponents()
		dateComponents.year = 1998
		dateComponents.month = 1
		dateComponents.day = 1

		return Calendar.autoupdatingCurrent.date(from: dateComponents)!
	}
}
