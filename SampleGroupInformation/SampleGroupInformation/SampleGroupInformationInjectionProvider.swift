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
	private static let sampleGroupInformationFactory = SampleGroupInformationFactoryImpl()

	public final let types: [Any.Type] = [
		SampleGroupInformationFactory.self,
	]

	public init() {
	}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
			case is SampleGroupInformationFactory.Protocol:
				return Me.sampleGroupInformationFactory as! Type
			default:
				throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
