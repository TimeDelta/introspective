//
//  UnitTest.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import HealthKit
import SwiftyMocky
@testable import Introspective

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
	var mockUiUtil: UiUtilMock!

	var mockSampleFactory: SampleFactoryMock!
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

		mockSampleFactory = SampleFactoryMock()
		Given(injectionProvider, .sampleFactory(willReturn: mockSampleFactory))

		mockQueryFactory = QueryFactoryMock()
		Given(injectionProvider, .queryFactory(willReturn: mockQueryFactory))

		utilFactory = UtilFactory()
		Given(injectionProvider, .utilFactory(willReturn: utilFactory))

		mockAttributeRestrictionUtil = AttributeRestrictionUtilMock()
		utilFactory.attributeRestriction = mockAttributeRestrictionUtil
		mockCalendarUtil = CalendarUtilMock()
		utilFactory.calendar = mockCalendarUtil
		mockNumericSampleUtil = NumericSampleUtilMock()
		utilFactory.numericSample = mockNumericSampleUtil
		mockSampleUtil = SampleUtilMock()
		utilFactory.sample = mockSampleUtil
		mockSearchUtil = SearchUtilMock()
		utilFactory.search = mockSearchUtil
		mockStringUtil = StringUtilMock()
		utilFactory.string = mockStringUtil
		mockTextNormalizationUtil = TextNormalizationUtilMock()
		utilFactory.textNormalization = mockTextNormalizationUtil
		mockUiUtil = UiUtilMock()
		utilFactory.ui = mockUiUtil
	}
}
