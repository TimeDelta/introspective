//
//  UnitTestInjectionProvider.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

// TODO
class UnitTestInjectionProvider: InjectionProvider {

	typealias Me = UnitTestInjectionProvider

	public static let mockQueryFactory = QueryFactory()
	public static let mockQuerierFactory = QuerierFactory()
	public static let mockQuestionFactory = QuestionFactory()
	public static let mockDataTypesFactory = DataTypesFactory()
	public static let mockUtilFactory = UtilFactory()
	public static let mockRestrictionParserFactory = RestrictionParserFactory()
	public static let mockSubQueryMatcherFactory = SubQueryMatcherFactory()
	public static let mockTimeConstraintFactory = TimeConstraintFactory()
	public static let mockExtraInformationFactory = ExtraInformationFactory()

	public static func resetMocks() {} // TODO

	public var queryFactory: QueryFactory { get { return Me.mockQueryFactory } }
	public var querierFactory: QuerierFactory { get { return Me.mockQuerierFactory } }
	public var questionFactory: QuestionFactory { get { return Me.mockQuestionFactory } }
	public var dataTypesFactory: DataTypesFactory { get { return Me.mockDataTypesFactory } }
	public var utilFactory: UtilFactory { get { return Me.mockUtilFactory } }
	public var restrictionParserFactory: RestrictionParserFactory { get { return Me.mockRestrictionParserFactory } }
	public var subQueryMatcherFactory: SubQueryMatcherFactory { get { return Me.mockSubQueryMatcherFactory } }
	public var timeConstraintFactory: TimeConstraintFactory { get { return Me.mockTimeConstraintFactory } }
	public var extraInformationFactory: ExtraInformationFactory { get { return Me.mockExtraInformationFactory } }
}
