//
//  CustomSample.swift
//  Introspective
//
//  Created by Bryan Nova on 9/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData
import os

@objc(CustomSample)
public final class CustomSample: NSManagedObject, CoreDataSample {

	// MARK: - Static Member Variables

	public static let entityName = ""

	// MARK: - Instance Member Variables

	private final var values: Dictionary<AttributeBase, Any>

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		var datesMap: [DateType: Date] = [.start: values[definition.startDateAttribute] as! Date]
		if let attribute = definition.endDateAttribute {
			datesMap[.end] = (values[attribute] as! Date)
		}
		return datesMap
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any {
		guard let attributeBase = attribute as? AttributeBase else {
			os_log("Could not cast Attribute to AttributeBase: %@", type: .error, attribute.name)
			throw AttributeError.unknownAttribute
		}
		if definition.attributes.contains(attributeBase) {
			return values[attributeBase] as Any
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any) throws {
		guard let attributeBase = attribute as? AttributeBase else {
			os_log("Could not cast Attribute to AttributeBase: %@", type: .error, attribute.name)
			throw AttributeError.unknownAttribute
		}
		if !definition.attributes.contains(attributeBase) {
			throw AttributeError.unknownAttribute
		}
		if attribute is DateAttribute {
			guard let _ = value as? Date else { throw AttributeError.typeMismatch }
		} else if attribute is DoubleAttribute {
			guard let _ = value as? Double else { throw AttributeError.typeMismatch }
		} else if attribute is IntegerAttribute {
			guard let _ = value as? Int else { throw AttributeError.typeMismatch }
		} else if attribute is CalendarComponentAttribute {
			guard let _ = value as? Calendar.Component else { throw AttributeError.typeMismatch }
		} else if attribute is TextAttribute {
			guard let _ = value as? String else { throw AttributeError.typeMismatch }
		} else if attribute is BooleanAttribute {
			guard let _ = value as? Bool else { throw AttributeError.typeMismatch }
		} else if attribute is TimeOfDayAttribute {
			guard let _ = value as? TimeOfDay else { throw AttributeError.typeMismatch }
		} else if attribute is DayOfWeekAttribute {
			guard let _ = value as? DayOfWeek else { throw AttributeError.typeMismatch }
		} else if attribute is AttributeSelectAttribute {
			guard let _ = value as? Attribute else { throw AttributeError.typeMismatch }
		} else if attribute is SelectOneAttribute {
			let selectAttribute = attribute as! SelectOneAttribute
			if selectAttribute.indexOf(possibleValue: value) == nil {
				throw AttributeError.unsupportedValue
			}
		}
	}
}
