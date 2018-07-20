//
//  UnitTestInjectionProvider.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import Cuckoo

class UnitTestInjectionProvider: InjectionProvider {

	typealias Me = UnitTestInjectionProvider

	public static let mockQueryFactory = QueryFactory()
	public static let mockQuerierFactory = MockQuerierFactory()
	public static let mockQuestionFactory = MockQuestionFactory()
	public static let mockDataTypesFactory = MockDataTypesFactory()
	public static let mockUtilFactory = MockUtilFactory()
	public static let mockRestrictionParserFactory = MockRestrictionParserFactory()
	public static let mockSubQueryMatcherFactory = SubQueryMatcherFactory()

	public static func resetMocks() {
		reset(
//			mockQueryFactory,
			mockQuerierFactory,
			mockQuestionFactory,
			mockDataTypesFactory,
			mockUtilFactory,
			mockRestrictionParserFactory
//			mockSubQueryMatcherFactory,
		)
	}

	public var queryFactory: QueryFactory { get { return Me.mockQueryFactory } }
	public var querierFactory: QuerierFactory { get { return Me.mockQuerierFactory } }
	public var questionFactory: QuestionFactory { get { return Me.mockQuestionFactory } }
	public var dataTypesFactory: DataTypesFactory { get { return Me.mockDataTypesFactory } }
	public var utilFactory: UtilFactory { get { return Me.mockUtilFactory } }
	public var restrictionParserFactory: RestrictionParserFactory { get { return Me.mockRestrictionParserFactory } }
	public var subQueryMatcherFactory: SubQueryMatcherFactory { get { return Me.mockSubQueryMatcherFactory } }
}
