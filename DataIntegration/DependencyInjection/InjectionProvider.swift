//
//  InjectionProvider.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

protocol InjectionProvider {

	var queryFactory: QueryFactory {get}
	var querierFactory: QuerierFactory {get}
	var questionFactory: QuestionFactory {get}
	var dataTypesFactory: DataTypesFactory {get}
	var utilFactory: UtilFactory {get}
	var restrictionParserFactory: RestrictionParserFactory {get}
}
