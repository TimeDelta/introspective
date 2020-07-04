//
//  SampleGroupersInjectionProvider.swift
//  SampleGroupers
//
//  Created by Bryan Nova on 10/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection

public class SampleGroupersInjectionProvider: InjectionProvider {
	private typealias Me = SampleGroupersInjectionProvider
	private static let sampleGrouperFactory = SampleGrouperFactoryImpl()

	public let types: [Any.Type] = [
		SampleGrouperFactory.self,
	]

	public init() {}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
		case is SampleGrouperFactory.Protocol:
			return Me.sampleGrouperFactory as! Type
		default:
			throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
