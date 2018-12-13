//
//  FunctionalTest.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

class FunctionalTest: XCTestCase {

	final var injectionProvider: InjectionProviderMock!

	final var database: FunctionalTestDatabase!

	final var queryFactory: QueryFactoryImpl!
	final var sampleFactory: SampleFactoryImpl!
	final var utilFactory: UtilFactory!
	final var subQueryMatcherFactory: SubQueryMatcherFactoryImpl!
	final var extraInformationFactory: ExtraInformationFactoryImpl!
	final var sampleGrouperFactory: SampleGrouperFactoryImpl!

	final var ioUtil: IOUtilMock!

	override func setUp() {
		super.setUp()
		testing = true

		injectionProvider = InjectionProviderMock()
		DependencyInjector.injectionProvider = injectionProvider

		database = FunctionalTestDatabase()
		Given(injectionProvider, .database(willReturn: database))

		queryFactory = QueryFactoryImpl()
		sampleFactory = SampleFactoryImpl()
		utilFactory = UtilFactory()
		subQueryMatcherFactory = SubQueryMatcherFactoryImpl()
		extraInformationFactory = ExtraInformationFactoryImpl()
		sampleGrouperFactory = SampleGrouperFactoryImpl()

		Given(injectionProvider, .queryFactory(willReturn: queryFactory))
		Given(injectionProvider, .sampleFactory(willReturn: sampleFactory))
		Given(injectionProvider, .utilFactory(willReturn: utilFactory))
		Given(injectionProvider, .subQueryMatcherFactory(willReturn: subQueryMatcherFactory))
		Given(injectionProvider, .extraInformationFactory(willReturn: extraInformationFactory))
		Given(injectionProvider, .sampleGrouperFactory(willReturn: sampleGrouperFactory))

		ioUtil = IOUtilMock()
		utilFactory.io = ioUtil
	}

	override func tearDown() {
		DependencyInjector.injectionProvider = ProductionInjectionProvider()
		testing = false
		super.tearDown()
	}
}
