//
//  AttributeRestrictionFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol AttributeRestrictionFactory {
	func initialize(type: AttributeRestriction.Type, forAttribute attribute: Attribute) -> AttributeRestriction
}

public final class AttributeRestrictionFactoryImpl: AttributeRestrictionFactory {

	public static let textTypes: [AttributeRestriction.Type] = [
		ContainsStringAttributeRestriction.self,
		StartsWithStringAttributeRestriction.self,
		EndsWithStringAttributeRestriction.self,
	]

	public static let numberTypes: [NumericAttributeRestriction.Type] = [
		LessThanNumericAttributeRestriction.self,
		LessThanOrEqualToNumericAttributeRestriction.self,
		EqualToNumericAttributeRestriction.self,
		GreaterThanOrEqualToNumericAttributeRestriction.self,
		GreaterThanNumericAttributeRestriction.self,
		NotEqualToNumericAttributeRestriction.self,
	]

	public static let dateTypes: [DateAttributeRestriction.Type] = [
		BeforeDateAttributeRestriction.self,
		AfterDateAttributeRestriction.self,
		BeforeDateAndTimeAttributeRestriction.self,
		AfterDateAndTimeAttributeRestriction.self,
		BeforeTimeOfDayAttributeRestriction.self,
		AfterTimeOfDayAttributeRestriction.self,
		OnDayOfWeekAttributeRestriction.self,
		OnDateAttributeRestriction.self,
	]

	public final func initialize(type: AttributeRestriction.Type, forAttribute attribute: Attribute) -> AttributeRestriction {
		return type.init(attribute: attribute)
	}
}
