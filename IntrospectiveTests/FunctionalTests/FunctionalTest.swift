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

class FunctionalTest: Test {

	final var injectionProvider: InjectionProviderMock!

	final var database: FunctionalTestDatabase!
	final var settings: SettingsImpl!

	final var queryFactory: QueryFactoryImpl!
	final var sampleFactory: SampleFactoryImpl!
	final var utilFactory: UtilFactory!
	final var subQueryMatcherFactory: SubQueryMatcherFactoryImpl!
	final var extraInformationFactory: ExtraInformationFactoryImpl!
	final var sampleGrouperFactory: SampleGrouperFactoryImpl!
	final var importerFactory: ImporterFactoryImpl!
	final var exporterFactory: ExporterFactoryImpl!

	final var ioUtil: IOUtilMock!
	final var uiUtil: UiUtilMock!

	override func setUp() {
		super.setUp()
		testing = true

		injectionProvider = InjectionProviderMock()
		DependencyInjector.injectionProvider = injectionProvider

		database = FunctionalTestDatabase()
		Given(injectionProvider, .database(willReturn: database))

		let transaction = DependencyInjector.db.transaction()
		settings = try! transaction.new(SettingsImpl.self)
		try! transaction.commit()
		// must pull from main database context or context will go out of scope and get deleted,
		// causing CoreData to be unable to fulfill a fault
		settings = try! DependencyInjector.db.pull(savedObject: settings)
		Given(injectionProvider, .settings(willReturn: settings))

		queryFactory = QueryFactoryImpl()
		sampleFactory = SampleFactoryImpl()
		utilFactory = UtilFactory()
		subQueryMatcherFactory = SubQueryMatcherFactoryImpl()
		extraInformationFactory = ExtraInformationFactoryImpl()
		sampleGrouperFactory = SampleGrouperFactoryImpl()
		importerFactory = ImporterFactoryImpl()
		exporterFactory = ExporterFactoryImpl()

		Given(injectionProvider, .queryFactory(willReturn: queryFactory))
		Given(injectionProvider, .sampleFactory(willReturn: sampleFactory))
		Given(injectionProvider, .utilFactory(willReturn: utilFactory))
		Given(injectionProvider, .subQueryMatcherFactory(willReturn: subQueryMatcherFactory))
		Given(injectionProvider, .extraInformationFactory(willReturn: extraInformationFactory))
		Given(injectionProvider, .sampleGrouperFactory(willReturn: sampleGrouperFactory))
		Given(injectionProvider, .importerFactory(willReturn: importerFactory))
		Given(injectionProvider, .exporterFactory(willReturn: exporterFactory))

		ioUtil = IOUtilMock()
		utilFactory.io = ioUtil

		uiUtil = UiUtilMock()
		utilFactory.ui = uiUtil

		Matcher.default.register(Exportable.Type.self) { $0 == $1 }

		HamcrestReportFunction = {message, file, line in XCTFail(message, file: file, line: line)}
	}

	override func tearDown() {
		DependencyInjector.injectionProvider = ProductionInjectionProvider()
		testing = false
		super.tearDown()
	}
}
