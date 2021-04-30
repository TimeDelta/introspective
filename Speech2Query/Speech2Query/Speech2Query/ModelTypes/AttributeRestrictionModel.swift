//
//  AttributeRestrictionModel.swift
//  Speech2Query
//
//  Created by Bryan Nova on 4/26/21.
//

import Foundation

import AttributeRestrictions

// sourcery: AutoMockable
internal protocol AttributeRestrictionModel {

	// do it this way instead of using an associated type to avoid having to
	// use type erasure pattern to hold an array of AttributeRestrictionModel
	static var restrictionClass: AttributeRestriction.Type

	/// - Returns: Whether or not each token is relevant for this type of restriction.
	func predict(for tokens: [String]) -> [Bool]
}
