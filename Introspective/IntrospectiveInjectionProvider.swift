//
//  IntrospectiveInjectionProvider.swift
//  Introspective
//
//  Created by Bryan Nova on 10/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection

internal class IntrospectiveInjectionProvider: InjectionProvider {
	private typealias Me = IntrospectiveInjectionProvider
	private static let coachMarkFactory = CoachMarkFactoryImpl()

	public final let types: [Any.Type] = [
		CoachMarkFactory.self,
	]

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
		case is CoachMarkFactory.Protocol:
			return Me.coachMarkFactory as! Type
		default:
			throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
