//
//  FunctionalTestInjectionProvider.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class FunctionalTestInjectionProvider: InjectionProvider {

	fileprivate let productionInjectionProvider = ProductionInjectionProvider()
	fileprivate let mockInjectionProvider = UnitTestInjectionProvider()

	var queryFactory: QueryFactory { get { return productionInjectionProvider.queryFactory } }
	var querierFactory: QuerierFactory { get { return productionInjectionProvider.querierFactory } }
	var questionFactory: QuestionFactory { get { return productionInjectionProvider.questionFactory } }
	var dataTypesFactory: DataTypesFactory { get { return productionInjectionProvider.dataTypesFactory } }
	var utilFactory: UtilFactory { get { return productionInjectionProvider.utilFactory } }
	var restrictionParserFactory: RestrictionParserFactory { get { return productionInjectionProvider.restrictionParserFactory } }
}
