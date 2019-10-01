//
//  QueriesInjectionProvider.swift
//  Queries
//
//  Created by Bryan Nova on 10/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection

public class QueriesInjectionProvider: InjectionProvider {

	private typealias Me = QueriesInjectionProvider
	private static let queryFactory = QueryFactoryImpl()
	private static let subQueryMatcherFactory = SubQueryMatcherFactoryImpl()

	public final let types: [Any.Type] = [
		QueryFactory.self,
		SubQueryMatcherFactory.self
	]

	public init() {
	}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
			case is QueryFactory.Protocol:
				return Me.queryFactory as! Type
			case is SubQueryMatcherFactory.Protocol:
				return Me.subQueryMatcherFactory as! Type
			default:
				throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
