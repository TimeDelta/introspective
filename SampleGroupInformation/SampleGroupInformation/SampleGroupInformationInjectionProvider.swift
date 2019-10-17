//
//  SampleGroupInformationInjectionProvider.swift
//  SampleGroupInformation
//
//  Created by Bryan Nova on 10/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection

public class SampleGroupInformationInjectionProvider: InjectionProvider {

	private typealias Me = SampleGroupInformationInjectionProvider
	private static let extraInformationFactory = ExtraInformationFactoryImpl()

	public final let types: [Any.Type] = [
		ExtraInformationFactory.self,
	]

	public init() {
	}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
			case is ExtraInformationFactory.Protocol:
				return Me.extraInformationFactory as! Type
			default:
				throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
