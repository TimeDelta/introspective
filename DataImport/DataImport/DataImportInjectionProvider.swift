//
//  DataImportInjectionProvider.swift
//  DataImport
//
//  Created by Bryan Nova on 10/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection

public class DataImportInjectionProvider: InjectionProvider {
	private typealias Me = DataImportInjectionProvider
	private static let importerFactory = ImporterFactoryImpl()

	public final let types: [Any.Type] = [
		ImporterFactory.self,
	]

	public init() {}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
		case is ImporterFactory.Protocol:
			return Me.importerFactory as! Type
		default:
			throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
