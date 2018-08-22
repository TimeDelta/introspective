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
	var querierFactory: QuerierFactoryImpl!
	var questionFactory: QuestionFactory!
	var dataTypeFactory: DataTypeFactoryImpl!
	var utilFactory: UtilFactory!
	var restrictionParserFactory: RestrictionParserFactory!
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
		querierFactory = QuerierFactoryImpl()
		questionFactory = QuestionFactory()
		dataTypeFactory = DataTypeFactoryImpl()
		utilFactory = UtilFactory()
		restrictionParserFactory = RestrictionParserFactory()
		subQueryMatcherFactory = SubQueryMatcherFactoryImpl()
		extraInformationFactory = ExtraInformationFactoryImpl()
		sampleGrouperFactory = SampleGrouperFactoryImpl()
		sampleGroupCombinerFactory = SampleGroupCombinerFactoryImpl()

		Given(injectionProvider, .queryFactory(willReturn: queryFactory))
		Given(injectionProvider, .querierFactory(willReturn: querierFactory))
		Given(injectionProvider, .questionFactory(willReturn: questionFactory))
		Given(injectionProvider, .dataTypeFactory(willReturn: dataTypeFactory))
		Given(injectionProvider, .utilFactory(willReturn: utilFactory))
		Given(injectionProvider, .restrictionParserFactory(willReturn: restrictionParserFactory))
		Given(injectionProvider, .subQueryMatcherFactory(willReturn: subQueryMatcherFactory))
		Given(injectionProvider, .extraInformationFactory(willReturn: extraInformationFactory))
		Given(injectionProvider, .sampleGrouperFactory(willReturn: sampleGrouperFactory))
		Given(injectionProvider, .sampleGroupCombinerFactory(willReturn: sampleGroupCombinerFactory))
	}

	override func tearDown() {
//		database.flushData(MoodImpl.self)
		DependencyInjector.injectionProvider = ProductionInjectionProvider()
		super.tearDown()
	}
}
