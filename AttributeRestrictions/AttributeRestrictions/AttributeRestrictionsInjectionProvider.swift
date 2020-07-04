//
//  AttributeRestrictionsInjectionProvider.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 10/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection

public class AttributeRestrictionsInjectionProvider: InjectionProvider {
	private typealias Me = AttributeRestrictionsInjectionProvider
	private static let attributeRestrictionFactory = AttributeRestrictionFactoryImpl()

	public final let types: [Any.Type] = [
		AttributeRestrictionFactory.self,
	]

	public init() {}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
		case is AttributeRestrictionFactory.Protocol:
			return Me.attributeRestrictionFactory as! Type
		default:
			throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
