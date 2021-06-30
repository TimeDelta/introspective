//
//  StoredOnDayOfWeekAttributeRestriction.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 6/30/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples

public final class StoredOnDayOfWeekAttributeRestriction: StoredBooleanExpression, CoreDataObject {

	private typealias Me = StoredOnDayOfWeekAttributeRestriction
	public static let entityName = "OnDayOfWeekAttributeRestriction"

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		var convertedDaysOfWeek = [DayOfWeek]()
		for day in daysOfWeek {
			convertedDaysOfWeek.append(DayOfWeek.fromInt(Int(String(day))!))
		}
		return OnDayOfWeekAttributeRestriction(restrictedAttribute: attribute, daysOfWeek: Set(convertedDaysOfWeek))
	}
}

extension StoredOnDayOfWeekAttributeRestriction {

	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var daysOfWeek: String
}

