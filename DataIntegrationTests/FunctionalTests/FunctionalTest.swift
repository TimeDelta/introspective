//
//  FunctionalTest.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import DataIntegration

class FunctionalTest: XCTestCase {

	var injectionProvider: InjectionProviderMock!

	var database: FunctionalTestDatabase!

	var queryFactory: QueryFactoryImpl!
	var dataTypeFactory: DataTypeFactoryImpl!
	var utilFactory: UtilFactory!
	var subQueryMatcherFactory: SubQueryMatcherFactoryImpl!
	var extraInformationFactory: ExtraInformationFactoryImpl!
	var sampleGrouperFactory: SampleGrouperFactoryImpl!
	var sampleGroupCombinerFactory: SampleGroupCombinerFactoryImpl!

	override func setUp() {
		super.setUp()
		injectionProvider = InjectionProviderMock()
		DependencyInjector.injectionProvider = injectionProvider

		database = FunctionalTestDatabase()
		Given(injectionProvider, .database(willReturn: database))

		queryFactory = QueryFactoryImpl()
		dataTypeFactory = DataTypeFactoryImpl()
		utilFactory = UtilFactory()
		subQueryMatcherFactory = SubQueryMatcherFactoryImpl()
		extraInformationFactory = ExtraInformationFactoryImpl()
		sampleGrouperFactory = SampleGrouperFactoryImpl()
		sampleGroupCombinerFactory = SampleGroupCombinerFactoryImpl()

		Given(injectionProvider, .queryFactory(willReturn: queryFactory))
		Given(injectionProvider, .dataTypeFactory(willReturn: dataTypeFactory))
		Given(injectionProvider, .utilFactory(willReturn: utilFactory))
		Given(injectionProvider, .subQueryMatcherFactory(willReturn: subQueryMatcherFactory))
		Given(injectionProvider, .extraInformationFactory(willReturn: extraInformationFactory))
		Given(injectionProvider, .sampleGrouperFactory(willReturn: sampleGrouperFactory))
		Given(injectionProvider, .sampleGroupCombinerFactory(willReturn: sampleGroupCombinerFactory))
	}

	override func tearDown() {
		DependencyInjector.injectionProvider = ProductionInjectionProvider()
		super.tearDown()
	}
}
