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
@testable import AttributeRestrictions
@testable import Attributes
@testable import BooleanAlgebra
@testable import Common
@testable import DataExport
@testable import DataImport
@testable import DependencyInjection
@testable import Notifications
@testable import Persistence
@testable import Queries
@testable import Samples
@testable import SampleGroupers
@testable import SampleGroupInformation
@testable import Settings
@testable import UIExtensions

class UnitTest: Test {

	var mockDatabase: DatabaseMock!

	var mockSettings: SettingsMock!

	var mockAsyncUtil: AsyncUtilMock!
	var mockCalendarUtil: CalendarUtilMock!
	var mockExporterUtil: ExporterUtilMock!
	var mockMoodUiUtil: MoodUiUtilMock!
	var mockNotificationUtil: NotificationUtilMock!
	var mockNumericSampleUtil: NumericSampleUtilMock!
	var mockSampleUtil: SampleUtilMock!
	var mockSearchUtil: SearchUtilMock!
	var mockStringUtil: StringUtilMock!
	var mockTextNormalizationUtil: TextNormalizationUtilMock!
	var mockUiUtil: UiUtilMock!
	var mockUserDefaultsUtil: UserDefaultsUtilMock!

	var mockSampleFactory: SampleFactoryMock!
	var mockQueryFactory: QueryFactoryMock!
	var mockImporterFactory: ImporterFactoryMock!
	var mockCoachMarkFactory: CoachMarkFactoryMock!
	var mockSampleGrouperFactory: SampleGrouperFactoryMock!
	var mockAttributeRestrictionFactory: AttributeRestrictionFactoryMock!
	var mockExtraInformationFactory: ExtraInformationFactoryMock!

	override func setUp() {
		super.setUp()
		setMocks()
	}

	override func tearDown() {
		AppDelegate.registerDependencies()
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

	private func setMocks() {
		mockDatabase = DatabaseMock()
		Given(injectionProvider, .get(.value(Database.self), willReturn: mockDatabase))

		mockSettings = SettingsMock()
		Given(injectionProvider, .get(.value(Settings.self), willReturn: mockSettings))

		mockSampleFactory = SampleFactoryMock()
		Given(injectionProvider, .get(.value(SampleFactory.self), willReturn: mockSampleFactory))

		mockQueryFactory = QueryFactoryMock()
		Given(injectionProvider, .get(.value(QueryFactory.self), willReturn: mockQueryFactory))

		mockImporterFactory = ImporterFactoryMock()
		Given(injectionProvider, .get(.value(ImporterFactory.self), willReturn: mockImporterFactory))

		mockCoachMarkFactory = CoachMarkFactoryMock()
		Given(injectionProvider, .get(.value(CoachMarkFactory.self), willReturn: mockCoachMarkFactory))

		mockSampleGrouperFactory = SampleGrouperFactoryMock()
		Given(injectionProvider, .get(.value(SampleGrouperFactory.self), willReturn: mockSampleGrouperFactory))

		mockAttributeRestrictionFactory = AttributeRestrictionFactoryMock()
		Given(injectionProvider, .get(.value(AttributeRestrictionFactory.self), willReturn: mockAttributeRestrictionFactory))

		mockExtraInformationFactory = ExtraInformationFactoryMock()
		Given(injectionProvider, .get(.value(ExtraInformationFactory.self), willReturn: mockExtraInformationFactory))

		setUpUtilMocks()
	}

	// MARK: - Helper Functions

	private final func setUpUtilMocks() {
		mockAsyncUtil = AsyncUtilMock()
		Given(injectionProvider, .get(.value(AsyncUtil.self), willReturn: mockAsyncUtil))

		mockCalendarUtil = CalendarUtilMock()
		Given(injectionProvider, .get(.value(CalendarUtil.self), willReturn: mockCalendarUtil))

		mockExporterUtil = ExporterUtilMock()
		Given(injectionProvider, .get(.value(ExporterUtil.self), willReturn: mockExporterUtil))

		mockMoodUiUtil = MoodUiUtilMock()
		Given(injectionProvider, .get(.value(MoodUiUtil.self), willReturn: mockMoodUiUtil))

		mockNotificationUtil = NotificationUtilMock()
		Given(injectionProvider, .get(.value(NotificationUtil.self), willReturn: mockNotificationUtil))

		mockNumericSampleUtil = NumericSampleUtilMock()
		Given(injectionProvider, .get(.value(NumericSampleUtil.self), willReturn: mockNumericSampleUtil))

		mockSampleUtil = SampleUtilMock()
		Given(injectionProvider, .get(.value(SampleUtil.self), willReturn: mockSampleUtil))

		mockSearchUtil = SearchUtilMock()
		Given(injectionProvider, .get(.value(SearchUtil.self), willReturn: mockSearchUtil))

		mockStringUtil = StringUtilMock()
		Given(injectionProvider, .get(.value(StringUtil.self), willReturn: mockStringUtil))

		mockTextNormalizationUtil = TextNormalizationUtilMock()
		Given(injectionProvider, .get(.value(TextNormalizationUtil.self), willReturn: mockTextNormalizationUtil))

		mockUiUtil = UiUtilMock()
		Given(injectionProvider, .get(.value(UiUtil.self), willReturn: mockUiUtil))

		mockUserDefaultsUtil = UserDefaultsUtilMock()
		Given(injectionProvider, .get(.value(UserDefaultsUtil.self), willReturn: mockUserDefaultsUtil))
	}
}
