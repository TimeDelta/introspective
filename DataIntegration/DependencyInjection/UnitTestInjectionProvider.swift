//
//  UnitTestInjectionProvider.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class UnitTestInjectionProvider: InjectionProvider {

	typealias Me = UnitTestInjectionProvider

	public static let mockQueryFactory = MockQueryFactory()
	public static let mockQuerierFactory = MockQuerierFactory()
	public static let mockQuestionFactory = MockQuestionFactory()
	public static let mockDataTypesFactory = MockDataTypesFactory()
	public static let mockUtilFactory = MockUtilFactory()

	var queryFactory: QueryFactory { get { return Me.mockQueryFactory } }
	var querierFactory: QuerierFactory { get { return Me.mockQuerierFactory } }
	var questionFactory: QuestionFactory { get { return Me.mockQuestionFactory } }
	var dataTypesFactory: DataTypesFactory { get { return Me.mockDataTypesFactory } }
	var utilFactory: UtilFactory { get { return Me.mockUtilFactory } }
}
