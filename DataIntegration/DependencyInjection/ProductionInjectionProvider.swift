//
//  ProductionInjectionProvider.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class ProductionInjectionProvider: InjectionProvider {

	fileprivate typealias Me = ProductionInjectionProvider

	fileprivate static let realDatabase = DatabaseImpl()
	fileprivate static let realQueryFactory = QueryFactoryImpl()
	fileprivate static let realQuerierFactory = QuerierFactoryImpl()
	fileprivate static let realDataTypeFactory = DataTypeFactoryImpl()
	fileprivate static let realUtilFactory = UtilFactory()
	fileprivate static let realSubQueryMatcherFactory = SubQueryMatcherFactoryImpl()
	fileprivate static let realExtraInformationFactory = ExtraInformationFactoryImpl()
	fileprivate static let realSampleGrouperFactory = SampleGrouperFactoryImpl()
	fileprivate static let realSampleGroupCombinerFactory = SampleGroupCombinerFactoryImpl()

	public func database() -> Database { return Me.realDatabase }
	public func queryFactory() -> QueryFactory { return Me.realQueryFactory }
	public func querierFactory() -> QuerierFactory { return Me.realQuerierFactory }
	public func dataTypeFactory() -> DataTypeFactory { return Me.realDataTypeFactory }
	public func utilFactory() -> UtilFactory { return Me.realUtilFactory }
	public func subQueryMatcherFactory() -> SubQueryMatcherFactory { return Me.realSubQueryMatcherFactory }
	public func extraInformationFactory() -> ExtraInformationFactory { return Me.realExtraInformationFactory }
	public func sampleGrouperFactory() -> SampleGrouperFactory { return Me.realSampleGrouperFactory }
	public func sampleGroupCombinerFactory() -> SampleGroupCombinerFactory { return Me.realSampleGroupCombinerFactory }
}
