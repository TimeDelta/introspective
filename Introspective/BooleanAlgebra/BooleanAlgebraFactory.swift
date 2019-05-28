//
//  BooleanAlgebraFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 4/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol BooleanAlgebraFactory {

	func parser() -> BooleanExpressionParser
}

public final class BooleanAlgebraFactoryImpl: BooleanAlgebraFactory {

	public final func parser() -> BooleanExpressionParser {
		return BooleanExpressionParserImpl()
	}
}
