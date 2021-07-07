//
//  StoredInThePastXTimeUnitsAttributeRestrictionm.swift
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

public final class StoredInThePastXTimeUnitsAttributeRestriction: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredInThePastXTimeUnitsAttributeRestriction
	public static let entityName = "InThePastXTimeUnitsAttributeRestriction"

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		return InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: attribute,
			Int(numTimeUnits),
			Calendar.Component.fromInt(Int(timeUnit))
		)
	}

	public func populate(from other: InThePastXTimeUnitsDateAttributeRestriction, for sampleType: Sample.Type) throws {
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		attributeId = other.restrictedAttribute.id
		numTimeUnits = Int64(other.numberOfTimeUnits)
		timeUnit = Int16(other.timeUnit.intValue())
	}
}

extension StoredInThePastXTimeUnitsAttributeRestriction {
	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var timeUnit: Int16
	@NSManaged private var numTimeUnits: Int64
}
