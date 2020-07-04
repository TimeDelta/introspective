//
//  DataExportInjectionProvider.swift
//  DataExport
//
//  Created by Bryan Nova on 9/30/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection

public class DataExportInjectionProvider: InjectionProvider {
	private typealias Me = DataExportInjectionProvider

	private static let exporterUtil = ExporterUtilImpl()

	public let types: [Any.Type] = [
		ExporterUtil.self,
	]

	public init() {}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
		case is ExporterUtil.Protocol:
			return Me.exporterUtil as! Type
		default:
			throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
