//
//  DependencyInjector.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class DependencyInjector: NSObject {

	static func setType(newType: InjectionType) {
		switch (newType) {
			case .Production:
				self.injectionProvider = ProductionInjectionProvider()
			case .FunctionalTest:
				self.injectionProvider = FunctionalTestInjectionProvider()
			case .UnitTest:
				self.injectionProvider = UnitTestInjectionProvider()
		}
	}

	fileprivate static var injectionProvider: InjectionProvider = ProductionInjectionProvider()

	public static var question: QuestionFactory { get { return injectionProvider.questionFactory } }
	public static var query: QueryFactory { get { return injectionProvider.queryFactory } }
	public static var querier: QuerierFactory { get { return injectionProvider.querierFactory } }
	public static var dataType: DataTypesFactory { get { return injectionProvider.dataTypesFactory } }
	public static var util: UtilFactory { get { return injectionProvider.utilFactory } }
	public static var restrictionParser: RestrictionParserFactory { get { return injectionProvider.restrictionParserFactory } }
}
