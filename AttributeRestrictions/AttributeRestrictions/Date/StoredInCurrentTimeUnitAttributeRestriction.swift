//
//  StoredInCurrentTimeUnitAttributeRestriction.swift
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

public final class StoredInCurrentTimeUnitAttributeRestriction: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredInCurrentTimeUnitAttributeRestriction
	public static let entityName = "DoubleComparisonAttributeRestriction"

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		return InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: attribute,
			Calendar.Component.fromInt(Int(value))
		)
	}

	public func populate(from other: InCurrentTimeUnitDateAttributeRestriction, for sampleType: Sample.Type) throws {
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		attributeId = other.restrictedAttribute.id
		value = Int16(other.timeUnit.intValue())
	}
}

extension StoredInCurrentTimeUnitAttributeRestriction {
	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var value: Int16
}
