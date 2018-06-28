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

	static func questionFactory() -> QuestionFactory {
		return injectionProvider.questionFactory
	}

	static func queryFactory() -> QueryFactory {
		return injectionProvider.queryFactory
	}

	static func querierFactory() -> QuerierFactory {
		return injectionProvider.querierFactory
	}

	static func dataTypesFactory() -> DataTypesFactory {
		return injectionProvider.dataTypesFactory
	}
}
