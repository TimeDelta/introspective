//
//  BooleanAlgebraInjectionProvider.swift
//  BooleanAlgebra
//
//  Created by Bryan Nova on 9/30/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection

public class BooleanAlgebraInjectionProvider: InjectionProvider {

	public let types: [Any.Type] = [
		BooleanExpressionParser.self,
	]

	public init() {
	}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch (type) {
			case is BooleanExpressionParser.Protocol:
				return BooleanExpressionParserImpl() as! Type
			default:
				throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
