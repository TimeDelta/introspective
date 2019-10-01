//
//  FunctionalTest.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import CoreData
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import BooleanAlgebra
@testable import Common
@testable import DataExport
@testable import DataImport
@testable import DependencyInjection
@testable import Globals
@testable import Notifications
@testable import Persistence
@testable import Queries
@testable import Samples
@testable import SampleGroupers
@testable import SampleGroupInformation
@testable import Settings
@testable import UIExtensions

class FunctionalTest: Test {

	final var database: FunctionalTestDatabase!
	final var settings: SettingsImpl!

	final var attributeRestrictionFactory: AttributeRestrictionFactoryImpl!
	final var extraInformationFactory: ExtraInformationFactoryImpl!
	final var importerFactory: ImporterFactoryImpl!
	final var queryFactory: QueryFactoryImpl!
	final var sampleFactory: SampleFactoryImpl!
	final var sampleGrouperFactory: SampleGrouperFactoryImpl!
	final var subQueryMatcherFactory: SubQueryMatcherFactoryImpl!

	final var ioUtil: IOUtilMock!
	final var uiUtil: UiUtilMock!
	final var exporterUtil: ExporterUtilMock!

	override func setUp() {
		super.setUp()
		Globals.testing = true

		database = FunctionalTestDatabase(ObjectModelContainer.objectModel)
		Given(injectionProvider, .get(.value(Database.self), willReturn: database))

		let transaction = DependencyInjector.get(Database.self).transaction()
		settings = try! transaction.new(SettingsImpl.self)
		try! transaction.commit()
		// must pull from main database context or context will go out of scope and get deleted,
		// causing CoreData to be unable to fulfill a fault
		settings = try! DependencyInjector.get(Database.self).pull(savedObject: settings)
		Given(injectionProvider, .get(.value(Settings.self), willReturn: settings))

		attributeRestrictionFactory = AttributeRestrictionFactoryImpl()
		queryFactory = QueryFactoryImpl()
		sampleFactory = SampleFactoryImpl()
		subQueryMatcherFactory = SubQueryMatcherFactoryImpl()
		extraInformationFactory = ExtraInformationFactoryImpl()
		sampleGrouperFactory = SampleGrouperFactoryImpl()
		importerFactory = ImporterFactoryImpl()

		Given(injectionProvider, .get(.value(AttributeRestrictionFactory.self), willReturn: attributeRestrictionFactory))
		Given(injectionProvider, .get(.value(ExtraInformationFactory.self), willReturn: extraInformationFactory))
		Given(injectionProvider, .get(.value(ImporterFactory.self), willReturn: importerFactory))
		Given(injectionProvider, .get(.value(QueryFactory.self), willReturn: queryFactory))
		Given(injectionProvider, .get(.value(SampleFactory.self), willReturn: sampleFactory))
		Given(injectionProvider, .get(.value(SampleGrouperFactory.self), willReturn: sampleGrouperFactory))
		Given(injectionProvider, .get(.value(SubQueryMatcherFactory.self), willReturn: subQueryMatcherFactory))

		ioUtil = IOUtilMock()
		Given(injectionProvider, .get(.value(IOUtil.self), willReturn: ioUtil))

		uiUtil = UiUtilMock()
		Given(injectionProvider, .get(.value(UiUtil.self), willReturn: uiUtil))

		exporterUtil = ExporterUtilMock()
		Given(injectionProvider, .get(.value(ExporterUtil.self), willReturn: exporterUtil))

		Given(injectionProvider, .get(.value(AsyncUtil.self), willReturn: AsyncUtilImpl()))
		Given(injectionProvider, .get(.value(CalendarUtil.self), willReturn: CalendarUtilImpl()))
		Given(injectionProvider, .get(.value(CoreDataSampleUtil.self), willReturn: CoreDataSampleUtilImpl()))
		Given(injectionProvider, .get(.value(HealthKitUtil.self), willReturn: HealthKitUtilImpl()))
		Given(injectionProvider, .get(.value(MoodUiUtil.self), willReturn: MoodUiUtilImpl()))
		Given(injectionProvider, .get(.value(MoodUtil.self), willReturn: MoodUtilImpl()))
		Given(injectionProvider, .get(.value(NotificationUtil.self), willReturn: NotificationUtilImpl()))
		Given(injectionProvider, .get(.value(NumericSampleUtil.self), willReturn: NumericSampleUtilImpl()))
		Given(injectionProvider, .get(.value(SampleUtil.self), willReturn: SampleUtilImpl()))
		Given(injectionProvider, .get(.value(SearchUtil.self), willReturn: SearchUtilImpl()))
		Given(injectionProvider, .get(.value(StringUtil.self), willReturn: StringUtilImpl()))
		Given(injectionProvider, .get(.value(TextNormalizationUtil.self), willReturn: TextNormalizationUtilImpl()))
		Given(injectionProvider, .get(.value(UserDefaultsUtil.self), willReturn: UserDefaultsUtilImpl()))

		Given(injectionProvider, .get(.value(ActivityDao.self), willReturn: ActivityDaoImpl()))

		HamcrestReportFunction = {message, file, line in XCTFail(message, file: file, line: line)}
	}

	override func tearDown() {
		AppDelegate.registerDependencies()
		Globals.testing = false
		super.tearDown()
	}
}
