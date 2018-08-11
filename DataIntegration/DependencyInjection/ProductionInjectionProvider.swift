//
//  ProductionInjectionProvider.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class ProductionInjectionProvider: InjectionProvider {

	fileprivate typealias Me = ProductionInjectionProvider

	fileprivate static let realQueryFactory = QueryFactory()
	fileprivate static let realQuerierFactory = QuerierFactory()
	fileprivate static let realQuestionFactory = QuestionFactory()
	fileprivate static let realDataTypesFactory = DataTypesFactory()
	fileprivate static let realUtilFactory = UtilFactory()
	fileprivate static let realRestrictionParserFactory = RestrictionParserFactory()
	fileprivate static let realSubQueryMatcherFactory = SubQueryMatcherFactory()
	fileprivate static let realTimeConstraintFactory = TimeConstraintFactory()
	fileprivate static let realExtraInformationFactory = ExtraInformationFactory()
	fileprivate static let realSampleGrouperFactory = SampleGrouperFactory()
	fileprivate static let realSampleGroupCombinerFactory = SampleGroupCombinerFactory()

	var queryFactory: QueryFactory { get { return Me.realQueryFactory } }
	var querierFactory: QuerierFactory { get { return Me.realQuerierFactory } }
	var questionFactory: QuestionFactory { get { return Me.realQuestionFactory } }
	var dataTypesFactory: DataTypesFactory { get { return Me.realDataTypesFactory } }
	var utilFactory: UtilFactory { get { return Me.realUtilFactory } }
	var restrictionParserFactory: RestrictionParserFactory { get { return Me.realRestrictionParserFactory } }
	var subQueryMatcherFactory: SubQueryMatcherFactory { get { return Me.realSubQueryMatcherFactory } }
	var timeConstraintFactory: TimeConstraintFactory { get { return Me.realTimeConstraintFactory } }
	var extraInformationFactory: ExtraInformationFactory { get { return Me.realExtraInformationFactory } }
	var sampleGrouperFactory: SampleGrouperFactory { get { return Me.realSampleGrouperFactory } }
	var sampleGroupCombinerFactory: SampleGroupCombinerFactory { get { return Me.realSampleGroupCombinerFactory } }
}
