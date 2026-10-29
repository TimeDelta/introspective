//
//  DependencyInjector.swift
//  DependencyInjection
//
//  Created by Bryan Nova on 9/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

/// Retrieve an injected instance (usually a Singleton) of the specified protocol type.
public func injected<ProtocolType>(_ type: ProtocolType.Type) -> ProtocolType {
	DependencyInjector.get(type)
}

/// - Tag: DependencyInjector
public final class DependencyInjector {
	private typealias Me = DependencyInjector

	private static var providers = [AnyHashable: InjectionProvider]()
	private static let registryLock = NSLock()

	public static func register(_ providers: [InjectionProvider]) {
		// Providers can resolve/register other dependencies. Never call their code
		// while holding the registry lock or a limited pool of semaphore permits.
		var updates = [AnyHashable: InjectionProvider]()
		for provider in providers {
			for type in provider.types {
				updates[getKey(type)] = provider
			}
		}
		registryLock.lock()
		let previous = Me.providers
		for (key, provider) in updates { Me.providers[key] = provider }
		registryLock.unlock()
		// Releasing a replaced provider can release managed objects, whose cleanup
		// resolves Database. Keep those destructors outside the critical section.
		withExtendedLifetime(previous) {}
	}

	public static func get<ProtocolType>(_: ProtocolType.Type) -> ProtocolType {
		let key = getKey(ProtocolType.self)
		registryLock.lock()
		let provider = providers[key]
		registryLock.unlock()
		guard let provider = provider else {
			fatalError("Tried to get injectable dependency for \(key) but has not been registered yet")
		}
		do {
			return try provider.get(ProtocolType.self)
		} catch {
			fatalError("Failed to retrieve injectable instance of \(key): \(error.localizedDescription)")
		}
	}

	private static func getKey(_ type: Any.Type) -> String {
		String(describing: type)
	}
}
