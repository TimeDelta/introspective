//
//  ProductionInjectionProvider.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class ProductionInjectionProvider: InjectionProvider {

	fileprivate let realQueryFactory = QueryFactory()
	fileprivate let realQuerierFactory = QuerierFactory()
	fileprivate let realQuestionFactory = QuestionFactory()
	fileprivate let realDataTypesFactory = DataTypesFactory()
	fileprivate let realUtilFactory = UtilFactory()
	fileprivate let realRestrictionParserFactory = RestrictionParserFactory()

	var queryFactory: QueryFactory { get { return realQueryFactory } }
	var querierFactory: QuerierFactory { get { return realQuerierFactory } }
	var questionFactory: QuestionFactory { get { return realQuestionFactory } }
	var dataTypesFactory: DataTypesFactory { get { return realDataTypesFactory } }
	var utilFactory: UtilFactory { get { return realUtilFactory } }
	var restrictionParserFactory: RestrictionParserFactory { get { return realRestrictionParserFactory } }
}
