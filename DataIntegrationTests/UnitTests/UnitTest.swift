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

	var injectionProvider: InjectionProviderMock!

	var mockDatabase: DatabaseMock!

	var mockSettings: SettingsMock!

	var utilFactory: UtilFactory!
	var mockAttributeRestrictionUtil: AttributeRestrictionUtilMock!
	var mockCalendarUtil: CalendarUtilMock!
	var mockNumericSampleUtil: NumericSampleUtilMock!
	var mockSampleUtil: SampleUtilMock!
	var mockSearchUtil: SearchUtilMock!
	var mockStringUtil: StringUtilMock!
	var mockTextNormalizationUtil: TextNormalizationUtilMock!

	var mockDataTypeFactory: DataTypeFactoryMock!
	var mockQueryFactory: QueryFactoryMock!

	override func setUp() {
		super.setUp()
		resetMocks()
		registerMatchers()
	}

	override func tearDown() {
		DependencyInjector.injectionProvider = ProductionInjectionProvider()
		super.tearDown()
	}

	func oldDate() -> Date {
		var dateComponents: DateComponents = DateComponents()
		dateComponents.year = 1998
		dateComponents.month = 1
		dateComponents.day = 1

		return Calendar.autoupdatingCurrent.date(from: dateComponents)!
	}

	fileprivate func registerMatchers() {
		Matcher.default.register(AnySample.self) { lhs,rhs in return lhs.equalTo(rhs) }
		Matcher.default.register(Attribute.self) { lhs,rhs in return lhs.equalTo(rhs) }
		Matcher.default.register(AttributeRestriction.self) { lhs,rhs in return lhs.equalTo(rhs) }
		Matcher.default.register(DayOfWeek.self)
		Matcher.default.register(HeartRate.Type.self) { _,_ in return true }
		Matcher.default.register(Sample.self) { lhs,rhs in return lhs.equalTo(rhs) }
	}

	fileprivate func resetMocks() {
		injectionProvider = InjectionProviderMock()
		DependencyInjector.injectionProvider = injectionProvider

		mockDatabase = DatabaseMock()
		Given(injectionProvider, .database(willReturn: mockDatabase))

		mockSettings = SettingsMock()
		Given(injectionProvider, .settings(willReturn: mockSettings))

		mockDataTypeFactory = DataTypeFactoryMock()
		Given(injectionProvider, .dataTypeFactory(willReturn: mockDataTypeFactory))

		mockQueryFactory = QueryFactoryMock()
		Given(injectionProvider, .queryFactory(willReturn: mockQueryFactory))

		utilFactory = UtilFactory()
		Given(injectionProvider, .utilFactory(willReturn: utilFactory))

		mockAttributeRestrictionUtil = AttributeRestrictionUtilMock()
		utilFactory.attributeRestrictionUtil = mockAttributeRestrictionUtil
		mockCalendarUtil = CalendarUtilMock()
		utilFactory.calendarUtil = mockCalendarUtil
		mockNumericSampleUtil = NumericSampleUtilMock()
		utilFactory.numericSampleUtil = mockNumericSampleUtil
		mockSampleUtil = SampleUtilMock()
		utilFactory.sampleUtil = mockSampleUtil
		mockSearchUtil = SearchUtilMock()
		utilFactory.searchUtil = mockSearchUtil
		mockStringUtil = StringUtilMock()
		utilFactory.stringUtil = mockStringUtil
		mockTextNormalizationUtil = TextNormalizationUtilMock()
		utilFactory.textNormalizationUtil = mockTextNormalizationUtil
	}
}
