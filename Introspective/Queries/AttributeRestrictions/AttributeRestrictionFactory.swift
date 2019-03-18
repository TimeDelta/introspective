//
//  AttributeRestrictionFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol AttributeRestrictionFactory {
	func typesFor(_ attribute: Attribute) -> [AttributeRestriction.Type]
	func initialize(type: AttributeRestriction.Type, forAttribute attribute: Attribute) -> AttributeRestriction
}

public final class AttributeRestrictionFactoryImpl: AttributeRestrictionFactory {

	private typealias Me = AttributeRestrictionFactoryImpl

	private static let textTypes: [AttributeRestriction.Type] = [
		ContainsStringAttributeRestriction.self,
		StartsWithStringAttributeRestriction.self,
		EndsWithStringAttributeRestriction.self,
		EqualToStringAttributeRestriction.self,
		NotEqualToStringAttributeRestriction.self,
		EmptyStringAttributeRestriction.self,
		NotEmptyStringAttributeRestriction.self,
	]

	private static let doubleTypes: [AttributeRestriction.Type] = [
		LessThanDoubleAttributeRestriction.self,
		LessThanOrEqualToDoubleAttributeRestriction.self,
		EqualToDoubleAttributeRestriction.self,
		GreaterThanOrEqualToDoubleAttributeRestriction.self,
		GreaterThanDoubleAttributeRestriction.self,
		NotEqualToDoubleAttributeRestriction.self,
	]

	private static let integerTypes: [AttributeRestriction.Type] = [
		LessThanIntegerAttributeRestriction.self,
		LessThanOrEqualToIntegerAttributeRestriction.self,
		EqualToIntegerAttributeRestriction.self,
		GreaterThanOrEqualToIntegerAttributeRestriction.self,
		GreaterThanIntegerAttributeRestriction.self,
		NotEqualToIntegerAttributeRestriction.self,
	]

	private static let dateTypes: [DateAttributeRestriction.Type] = [
		IsTodayDateAttributeRestriction.self,
		InThePastXTimeUnitsDateAttributeRestriction.self,
		BeforeDateAttributeRestriction.self,
		AfterDateAttributeRestriction.self,
		BeforeDateAndTimeAttributeRestriction.self,
		AfterDateAndTimeAttributeRestriction.self,
		BeforeTimeOfDayAttributeRestriction.self,
		AfterTimeOfDayAttributeRestriction.self,
		OnDayOfWeekAttributeRestriction.self,
		OnDateAttributeRestriction.self,
	]

	private static let selectOneTypes: [AttributeRestriction.Type] = [
		EqualToSelectOneAttributeRestriction.self,
		NotEqualToSelectOneAttributeRestriction.self,
	]

	private static let dosageTypes: [AttributeRestriction.Type] = [
		LessThanDosageAttributeRestriction.self,
		LessThanOrEqualToDosageAttributeRestriction.self,
		EqualToDosageAttributeRestriction.self,
		GreaterThanOrEqualToDosageAttributeRestriction.self,
		GreaterThanDosageAttributeRestriction.self,
		NotEqualToDosageAttributeRestriction.self,
	]

	private static let frequencyTypes: [AttributeRestriction.Type] = [
		LessThanFrequencyAttributeRestriction.self,
		LessThanOrEqualToFrequencyAttributeRestriction.self,
		EqualToFrequencyAttributeRestriction.self,
		GreaterThanOrEqualToFrequencyAttributeRestriction.self,
		GreaterThanFrequencyAttributeRestriction.self,
		NotEqualToFrequencyAttributeRestriction.self,
	]

	private static let tagTypes: [AttributeRestriction.Type] = [
		HasOneOfTagAttributeRestriction.self,
		DoesNotHaveOneOfTagAttributeRestriction.self,
		HasTagAttributeRestriction.self,
		DoesNotHaveTagAttributeRestriction.self,
	]

	private static let tagsTypes: [AttributeRestriction.Type] = [
		HasOneOfTagAttributeRestriction.self,
		DoesNotHaveOneOfTagAttributeRestriction.self,
		HasTagAttributeRestriction.self,
		DoesNotHaveTagAttributeRestriction.self,
	]

	private static let durationTypes: [AttributeRestriction.Type] = [
		LessThanOrEqualToDurationAttributeRestriction.self,
		LessThanOrEqualToDurationAttributeRestriction.self,
		EqualToDurationAttributeRestriction.self,
		GreaterThanOrEqualToDurationAttributeRestriction.self,
		GreaterThanDurationAttributeRestriction.self,
		NotEqualToDurationAttributeRestriction.self,
	]

	private final let log = Log()

	public final func typesFor(_ attribute: Attribute) -> [AttributeRestriction.Type] {
		switch (attribute) {
			case is TextAttribute: return Me.textTypes
			case is DoubleAttribute: return Me.doubleTypes
			case is IntegerAttribute: return Me.integerTypes
			case is DateAttribute: return Me.dateTypes
			case is SelectOneAttribute: return Me.selectOneTypes
			case is DosageAttribute: return Me.dosageTypes
			case is FrequencyAttribute: return Me.frequencyTypes
			case is TagAttribute: return Me.tagTypes
			case is TagsAttribute: return Me.tagsTypes
			case is DurationAttribute: return Me.durationTypes
			default:
				log.error("Forgot a type of attribute: %@", String(describing: type(of: attribute)))
				return []
		}
	}

	public final func initialize(type: AttributeRestriction.Type, forAttribute attribute: Attribute) -> AttributeRestriction {
		return type.init(restrictedAttribute: attribute)
	}
}
