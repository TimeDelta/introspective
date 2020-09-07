//
//  SampleFetchersInjectionProvider.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection

public final class SampleFetchersInjectionProvider: InjectionProvider {
	private typealias Me = SampleFetchersInjectionProvider
	private static let sampleFetcherFactory = SampleFetcherFactoryImpl()

	public var types: [Any.Type] = [
		SampleFetcherFactory.self,
	]

	public init() {}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
		case is SampleFetcherFactory.Protocol:
			return Me.sampleFetcherFactory as! Type
		default:
			throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
