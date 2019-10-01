//
//  SettingsInjectionProvider.swift
//  Settings
//
//  Created by Bryan Nova on 10/1/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection
import Persistence

public class SettingsInjectionProvider: InjectionProvider {

	private typealias Me = SettingsInjectionProvider
	private static var settings: Settings!

	public static var functionalTesting = false

	public final let types: [Any.Type] = [
		Settings.self
	]

	public init() {
	}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
			case is Settings.Protocol:
				guard !Me.functionalTesting else { return DummySettings() as! Type }
				if Me.settings == nil {
					do {
						let existingSettings = try database().query(SettingsImpl.fetchRequest())
						if existingSettings.count == 0 {
							do {
								let transaction = database().transaction()
								let settings = try retryOnFail({ try transaction.new(SettingsImpl.self) }, maxRetries: 2)
								try retryOnFail({ try transaction.commit() }, maxRetries: 2)
								Me.settings = try database().pull(savedObject: settings)
							} catch {
								fatalError(String(format: "Failed to create or save default settings: %@", errorInfo(error)))
							}
						} else {
							Me.settings = existingSettings[0]
						}
					} catch {
						fatalError(String(format: "Failed to load settings: %@", errorInfo(error)))
					}
				}
				return Me.settings as! Type
			default:
				throw GenericError("Unknown type: " + String(describing: type))
		}
	}

	private final func database() -> Database {
		return DependencyInjector.get(Database.self)
	}
}
