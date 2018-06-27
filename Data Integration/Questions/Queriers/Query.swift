//
//  Query.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

protocol Query {

	var finalOperation: Operations? {get set}
	var startDate: Date? {get set}
	var endDate: Date? {get set}
	var daysOfWeek: Set<DayOfWeek> {get}

	func runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ()) throws
}
