//
//  MetaDataInjectionProvider.swift
//  MetaData
//
//  Created by Bryan Nova on 8/4/21.
//

import Foundation

import Common
import DependencyInjection

public class MetaDataInjectionProvider: InjectionProvider {
	private typealias Me = MetaDataInjectionProvider
	private static let unaccountedForTimeMetaDataCalculator = UnaccountedForTimeMetaDataCalculatorImpl()

	public final let types: [Any.Type] = [
		UnaccountedForTimeMetaDataCalculator.self,
	]

	public init() {}

	public final func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
		case is UnaccountedForTimeMetaDataCalculator.Protocol:
			return Me.unaccountedForTimeMetaDataCalculator as! Type
		default:
			throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
