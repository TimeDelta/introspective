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

	func database() -> Database
	func queryFactory() -> QueryFactory
	func dataTypeFactory() -> DataTypeFactory
	func utilFactory() -> UtilFactory
	func subQueryMatcherFactory() -> SubQueryMatcherFactory
	func extraInformationFactory() -> ExtraInformationFactory
	func sampleGrouperFactory() -> SampleGrouperFactory
	func sampleGroupCombinerFactory() -> SampleGroupCombinerFactory
}
