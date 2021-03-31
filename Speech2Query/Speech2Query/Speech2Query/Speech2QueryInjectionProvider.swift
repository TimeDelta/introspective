//
//  Speech2QueryInjectionProvider.swift
//  Speech2Query
//
//  Created by Bryan Nova on 4/28/21.
//

import Common
import DependencyInjection
import Foundation

public class Speech2QueryInjectionProvider: InjectionProvider {
	private typealias Me = Speech2QueryInjectionProvider

	private static let attributeRestrictionModelFactory = AttributeRestrictionModelFactoryImpl()

	public let types: [Any.Type] = [
		AttributeRestrictionModelFactory.self,
	]

	public init() {}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
		case is AttributeRestrictionModelFactory.Protocol:
			return Me.attributeRestrictionModelFactory as! Type
		default:
			throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}

