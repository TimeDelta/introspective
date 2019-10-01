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

	private static var providers = [AnyHashable: InjectionProvider]()

	public static func register(_ provider: InjectionProvider) {
		for type in provider.types {
			providers[getKey(type)] = provider
		}
	}

	public static func get<ProtocolType>(_ type: ProtocolType.Type) -> ProtocolType {
		let key = getKey(ProtocolType.self)
		if !providers.keys.contains(key) {
			fatalError("Tried to get injectable dependency for \(key) but has not been registered yet")
		}
		do {
			return try providers[key]!.get(ProtocolType.self)
		} catch {
			fatalError("Failed to retrieve injectable instance of \(key): \(error.localizedDescription)")
		}
	}

	private static func getKey(_ type: Any.Type) -> String {
		return String(describing: type)
	}
}
