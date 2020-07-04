//
//  InjectionProvider.swift
//  DependencyInjection
//
//  Created by Bryan Nova on 9/30/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

// sourcery: AutoMockable
public protocol InjectionProvider {
	/// This lets the [DependencyInjector](x-source-tag://DependencyInjector) know for what types this
	/// InjectionProvider is responsible.
	var types: [Any.Type] { get }

	/// This method should provide a concrete instance of the provided `Type`.
	func get<Type>(_ type: Type.Type) throws -> Type
}
