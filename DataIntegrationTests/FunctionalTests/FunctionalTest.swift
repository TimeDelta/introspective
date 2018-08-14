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

	let injectionProvider = InjectionProviderMock()

	let queryFactory = QueryFactoryImpl()
	let querierFactory = QuerierFactoryImpl()
	let questionFactory = QuestionFactory()
	let dataTypeFactory = DataTypeFactoryImpl()
	let utilFactory = UtilFactory()
	let restrictionParserFactory = RestrictionParserFactory()
	let subQueryMatcherFactory = SubQueryMatcherFactoryImpl()
	let extraInformationFactory = ExtraInformationFactoryImpl()
	let sampleGrouperFactory = SampleGrouperFactoryImpl()
	let sampleGroupCombinerFactory = SampleGroupCombinerFactoryImpl()

	override func setUp() {
		super.setUp()
		DependencyInjector.injectionProvider = injectionProvider
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
		DependencyInjector.injectionProvider = ProductionInjectionProvider()
		super.tearDown()
	}
}
