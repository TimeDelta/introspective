//
//  AttributeRestrictionModelFactory.swift
//  Speech2Query
//
//  Created by Bryan Nova on 4/28/21.
//

import Foundation

// sourcery: AutoMockable
internal protocol AttributeRestrictionModelFactory {

	func getAllAttributeRestrictionModels() -> [AttributeRestrictionModel]
}

internal class AttributeRestrictionModelFactoryImpl: AttributeRestrictionModelFactory {

	private static let allModels: [AttributeRestrictionModel] = []

	func getAllAttributeRestrictionModels() -> [AttributeRestrictionModel] {
		allModels
	}
}
