//
//  DependencyInjector.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class DependencyInjector {

	public static var injectionProvider: InjectionProvider = ProductionInjectionProvider()

	public static var db: Database { get { return injectionProvider.database() } }
	public static var query: QueryFactory { get { return injectionProvider.queryFactory() } }
	public static var querier: QuerierFactory { get { return injectionProvider.querierFactory() } }
	public static var dataType: DataTypeFactory { get { return injectionProvider.dataTypeFactory() } }
	public static var util: UtilFactory { get { return injectionProvider.utilFactory() } }
	public static var subQueryMatcher: SubQueryMatcherFactory { get { return injectionProvider.subQueryMatcherFactory() } }
	public static var extraInformation: ExtraInformationFactory { get { return injectionProvider.extraInformationFactory() } }
	public static var sampleGrouper: SampleGrouperFactory { get { return injectionProvider.sampleGrouperFactory() } }
	public static var sampleGroupCombiner: SampleGroupCombinerFactory { get { return injectionProvider.sampleGroupCombinerFactory() } }
}
