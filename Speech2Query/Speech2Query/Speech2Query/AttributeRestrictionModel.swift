//
//  AttributeRestrictionModel.swift
//  Speech2Query
//
//  Created by Bryan Nova on 4/26/21.
//

import Foundation

import AttributeRestrictions

// sourcery: AutoMockable
protocol AttributeRestrictionModel {

	static associatedtype RestrictionClass: AttributeRestriction

	/// - Returns: Whether or not each token is relevant for this type of restriction.
	func predict(for tokens: [String]) -> [Bool]
}
