//
//  AttributeRestrictionFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class AttributeRestrictionFactory {

	public static let allTypes: [AttributeRestriction.Type] = [
		LessThanAttributeRestriction.self,
		LessThanOrEqualToAttributeRestriction.self,
		EqualToAttributeRestriction.self,
		GreaterThanOrEqualToAttributeRestriction.self,
		GreaterThanAttributeRestriction.self,
	]

	public static let textTypes: [AttributeRestriction.Type] = [
	]

	public static let numberTypes: [AttributeRestriction.Type] = [
		LessThanAttributeRestriction.self,
		LessThanOrEqualToAttributeRestriction.self,
		EqualToAttributeRestriction.self,
		GreaterThanOrEqualToAttributeRestriction.self,
		GreaterThanAttributeRestriction.self,
	]

	public static let dateTypes: [AttributeRestriction.Type] = [
	]
}