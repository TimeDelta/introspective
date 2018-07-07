//
//  QuestionPart.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public struct QuestionPart {

	/// The data type to query.
	public var dataType: DataTypes
	/// Apply a final operation to the result of this question part.
	public var finalOperation: QueryOperation?
	/// Ignore everything before this date.
	public var startDate: Date?
	/// Ignore everything after this date.
	public var endDate: Date?
	/// Ignore everything that did not occur on one of the given days of the week unless no days of the week are given.
	public var daysOfWeek: Set<DayOfWeek>
	/// Ignore any entries that don't meet all of these restrictions.
	public var attributeRestrictions: [AttributeRestriction]
	/// Specify the value that should be returned from this part of the question.
	public var returnType: ReturnType
	/// When returning, only give the `returnType` for the most recent entry.
	public var mostRecentEntryOnly: Bool = false
}
