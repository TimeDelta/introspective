//
//  DependencyInjector.swift
//  DependencyInjection
//
//  Created by Bryan Nova on 9/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

/// - Tag: DependencyInjector
public final class DependencyInjector {
	private typealias Me = DependencyInjector

	private static var providers = [AnyHashable: InjectionProvider]()
	/// The number of calls that can be made to `semaphore.wait()` simultaneously before locking. This also defines the depth limit for retrieving a dependency (if resolving a dependency requires resolving anothere dependency).
	/// - Note: Should be at least 2 because the call to resolve Settings object requires 2 calls deep in order to retrieve the Database object.
	private static let semaphoreSize = 3
	/// Used to synchronize across threads
	/// - Note: This is mostly needed for testing because we never re-register dependencies once app is running.
	private static var semaphore = DispatchSemaphore(value: semaphoreSize)

	public static func register(_ providers: [InjectionProvider]) {
		// wait for all semaphore locks to finish before re-registering
		for _ in 0 ..< semaphoreSize {
			semaphore.wait()
		}
		for provider in providers {
			for type in provider.types {
				Me.providers[getKey(type)] = provider
			}
		}
		for _ in 0 ..< semaphoreSize {
			semaphore.signal()
		}
	}

	public static func get<ProtocolType>(_: ProtocolType.Type) -> ProtocolType {
		let key = getKey(ProtocolType.self)
		semaphore.wait()
		if !providers.keys.contains(key) {
			fatalError("Tried to get injectable dependency for \(key) but has not been registered yet")
		}
		do {
			let dependency = try providers[key]!.get(ProtocolType.self)
			semaphore.signal()
			return dependency
		} catch {
			fatalError("Failed to retrieve injectable instance of \(key): \(error.localizedDescription)")
		}
	}

	private static func getKey(_ type: Any.Type) -> String {
		String(describing: type)
	}
}
