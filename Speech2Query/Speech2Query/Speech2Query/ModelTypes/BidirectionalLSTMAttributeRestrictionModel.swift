//
//  BidirectionalLSTMAttributeRestrictionModel.swift
//  Speech2Query
//
//  Created by Bryan Nova on 4/28/21.
//

import Foundation
import CoreML

import AttributeRestrictions

/// Use Bi-LSTM instead of something like a transformer to keep the number of learned parameters low
internal class BidirectionalLSTMAttributeRestrictionModel<RestrictionType>: AttributeRestrictionModel {

	public static var restrictionClass = RestrictionType.self

	public init() {

	}

	public func predict(for tokens: [String]) -> [Bool] {

	}
}
