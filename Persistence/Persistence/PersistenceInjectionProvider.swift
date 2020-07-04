//
//  PersistenceInjectionProvider.swift
//  Persistence
//
//  Created by Bryan Nova on 9/30/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import Common
import DependencyInjection
import Globals

public class PersistenceInjectionProvider: InjectionProvider {
	private typealias Me = PersistenceInjectionProvider

	private static let codableStorage = CodableStorageImpl()
	private static var database: Database!

	public let types: [Any.Type] = [
		CodableStorage.self,
		Database.self,
	]

	private final let objectModel: NSManagedObjectModel

	public init(_ objectModel: NSManagedObjectModel) {
		self.objectModel = objectModel
	}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
		case is CodableStorage.Protocol:
			return Me.codableStorage as! Type
		case is Database.Protocol:
			if Me.database == nil {
				Me.database = DatabaseImpl(objectModel)
				if Globals.uiTesting {
					try! Me.database.deleteEverything()
					Me.database = DatabaseImpl(objectModel)
				}
			}
			return Me.database as! Type
		default:
			throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
