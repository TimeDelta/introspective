//
//  InjectionProvider.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol InjectionProvider {

	func queryFactory() -> QueryFactory
	func querierFactory() -> QuerierFactory
	func questionFactory() -> QuestionFactory
	func dataTypeFactory() -> DataTypeFactory
	func utilFactory() -> UtilFactory
	func restrictionParserFactory() -> RestrictionParserFactory
	func subQueryMatcherFactory() -> SubQueryMatcherFactory
	func extraInformationFactory() -> ExtraInformationFactory
	func sampleGrouperFactory() -> SampleGrouperFactory
	func sampleGroupCombinerFactory() -> SampleGroupCombinerFactory
}
