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

	public var queryFactory: QueryFactory { get { return productionInjectionProvider.queryFactory } }
	public var querierFactory: QuerierFactory { get { return productionInjectionProvider.querierFactory } }
	public var questionFactory: QuestionFactory { get { return productionInjectionProvider.questionFactory } }
	public var dataTypesFactory: DataTypesFactory { get { return productionInjectionProvider.dataTypesFactory } }
	public var utilFactory: UtilFactory { get { return productionInjectionProvider.utilFactory } }
	public var restrictionParserFactory: RestrictionParserFactory { get { return productionInjectionProvider.restrictionParserFactory } }
	public var subQueryMatcherFactory: SubQueryMatcherFactory { get { return productionInjectionProvider.subQueryMatcherFactory } }
	public var timeConstraintFactory: TimeConstraintFactory { get { return productionInjectionProvider.timeConstraintFactory } }
}
