//
//  UnitTestInjectionProvider.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class UnitTestInjectionProvider: InjectionProvider {

	fileprivate let mockQueryFactory = MockQueryFactory()
	fileprivate let mockQuerierFactory = MockQuerierFactory()
	fileprivate let mockQuestionFactory = MockQuestionFactory()
	fileprivate let mockDataTypesFactory = MockDataTypesFactory()

	var queryFactory: QueryFactory { get { return mockQueryFactory } }
	var querierFactory: QuerierFactory { get { return mockQuerierFactory } }
	var questionFactory: QuestionFactory { get { return mockQuestionFactory } }
	var dataTypesFactory: DataTypesFactory { get { return mockDataTypesFactory } }
}
