//
//  DateAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common

/// - Note: Do not make any `DateAttributeRestriction`s conform to PredicateAttributeRestriction
///         because it will interfere with the time zone conversion setting
public class DateAttributeRestriction: AnyAttributeRestriction {

	public var typedValue: Date? { nil }
}

public protocol TimeOfDayAttributeRestriction: AttributeRestriction {

	var timeOfDay: TimeOfDay { get }
}

public protocol DayOfWeekAttributeRestriction: AttributeRestriction {

	var daysOfWeek: [DayOfWeek] { get }
}
