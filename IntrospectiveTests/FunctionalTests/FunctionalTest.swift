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

	var injectionProvider: InjectionProviderMock!

	var database: FunctionalTestDatabase!

	var queryFactory: QueryFactoryImpl!
	var sampleFactory: SampleFactoryImpl!
	var utilFactory: UtilFactory!
	var subQueryMatcherFactory: SubQueryMatcherFactoryImpl!
	var extraInformationFactory: ExtraInformationFactoryImpl!
	var sampleGrouperFactory: SampleGrouperFactoryImpl!

	override func setUp() {
		super.setUp()
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
	}

	override func tearDown() {
		DependencyInjector.injectionProvider = ProductionInjectionProvider()
		super.tearDown()
	}
}
