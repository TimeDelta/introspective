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

class UnitTest: Test {

	var injectionProvider: InjectionProviderMock!

	var mockDatabase: DatabaseMock!

	var mockSettings: SettingsMock!

	var utilFactory: UtilFactory!
	var mockCalendarUtil: CalendarUtilMock!
	var mockNumericSampleUtil: NumericSampleUtilMock!
	var mockSampleUtil: SampleUtilMock!
	var mockSearchUtil: SearchUtilMock!
	var mockStringUtil: StringUtilMock!
	var mockTextNormalizationUtil: TextNormalizationUtilMock!
	var mockUiUtil: UiUtilMock!
	var mockUserDefaultsUtil: UserDefaultsUtilMock!
	var mockNotificationUtil: NotificationUtilMock!
	var mockAsyncUtil: AsyncUtilMock!

	var mockSampleFactory: SampleFactoryMock!
	var mockQueryFactory: QueryFactoryMock!
	var mockImporterFactory: ImporterFactoryMock!
	var mockExporterFactory: ExporterFactoryMock!
	var mockCoachMarkFactory: CoachMarkFactoryMock!
	var mockSampleGrouperFactory: SampleGrouperFactoryMock!
	var mockBooleanAlgebraFactory: BooleanAlgebraFactoryMock!
	var mockAttributeRestrictionFactory: AttributeRestrictionFactoryMock!
	var mockExtraInformationFactory: ExtraInformationFactoryMock!
	var mockDaoFactory: DaoFactoryMock!

	override func setUp() {
		super.setUp()
		resetMocks()
	}

	override func tearDown() {
		DependencyInjector.injectionProvider = ProductionInjectionProvider()
		resetButtonDescriber()
		super.tearDown()
	}

	func oldDate() -> Date {
		var dateComponents: DateComponents = DateComponents()
		dateComponents.year = 1998
		dateComponents.month = 1
		dateComponents.day = 1

		return Calendar.autoupdatingCurrent.date(from: dateComponents)!
	}

	private func resetMocks() {
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

		mockImporterFactory = ImporterFactoryMock()
		Given(injectionProvider, .importerFactory(willReturn: mockImporterFactory))

		mockExporterFactory = ExporterFactoryMock()
		Given(injectionProvider, .exporterFactory(willReturn: mockExporterFactory))

		mockCoachMarkFactory = CoachMarkFactoryMock()
		Given(injectionProvider, .coachMarkFactory(willReturn: mockCoachMarkFactory))

		mockSampleGrouperFactory = SampleGrouperFactoryMock()
		Given(injectionProvider, .sampleGrouperFactory(willReturn: mockSampleGrouperFactory))

		mockBooleanAlgebraFactory = BooleanAlgebraFactoryMock()
		Given(injectionProvider, .booleanAlgebraFactory(willReturn: mockBooleanAlgebraFactory))

		mockAttributeRestrictionFactory = AttributeRestrictionFactoryMock()
		Given(injectionProvider, .attributeRestrictionFactory(willReturn: mockAttributeRestrictionFactory))

		mockExtraInformationFactory = ExtraInformationFactoryMock()
		Given(injectionProvider, .extraInformationFactory(willReturn: mockExtraInformationFactory))

		mockDaoFactory = DaoFactoryMock()
		Given(injectionProvider, .daoFactory(willReturn: mockDaoFactory))

		utilFactory = UtilFactory()
		Given(injectionProvider, .utilFactory(willReturn: utilFactory))

		setUpUtilMocks()
	}

	// MARK: - Helper Functions

	private final func setUpUtilMocks() {
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

		mockUserDefaultsUtil = UserDefaultsUtilMock()
		utilFactory.userDefaults = mockUserDefaultsUtil

		mockNotificationUtil = NotificationUtilMock()
		utilFactory.notification = mockNotificationUtil

		mockAsyncUtil = AsyncUtilMock()
		utilFactory.async = mockAsyncUtil
	}
}
