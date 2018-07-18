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

public class AttributeRestrictionFactoryImpl: AttributeRestrictionFactory {

	public static let textTypes: [AttributeRestriction.Type] = [
	]

	public static let numberTypes: [NumericAttributeRestriction.Type] = [
		LessThanAttributeRestriction.self,
		LessThanOrEqualToAttributeRestriction.self,
		EqualToAttributeRestriction.self,
		GreaterThanOrEqualToAttributeRestriction.self,
		GreaterThanAttributeRestriction.self,
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

	public func initialize(type: AttributeRestriction.Type, forAttribute attribute: Attribute) -> AttributeRestriction {
		return type.init(attribute: attribute)
	}
}
