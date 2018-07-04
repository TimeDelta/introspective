//
//  Query.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

protocol Query {

	var finalOperation: QueryOperation? {get set}
	/// Ignore everything before this date.
	var startDate: Date? {get set}
	/// Ignore everything after this date.
	var endDate: Date? {get set}
	/// Ignore everything that did not occur on one of the given days of the week unless no days of the week are given.
	var daysOfWeek: Set<DayOfWeek> {get set}
	///
	var quantityRestrictions: [QuantityRestriction] {get set}
	/// 
	var returnType: ReturnType? {get set}
	/// When returning, only give the `returnType` for the most recent entry
	var mostRecentEntryOnly: Bool {get set}

	func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) throws
}
