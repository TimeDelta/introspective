//
//  ReturnType.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum ReturnType {

	/// returned value is [(date: Date?, value: Double)], with the value based on an operation such as: average, count, max, min, sum
	case finalOperation
	/// returned value is [DateInterval], with each element of the array representing the start and end time of one matched entry
	case times(aggregationUnit: Calendar.Component)
	/// returned value is [Date], with each elemend representing the start date of one matched entry
	case startDates
	/// returned value is [Date], with each elemend representing the end date of one matched entry
	case endDates
	/// return all attributes in a map of [String: String]
	case attributes

	public var type: Any.Type {
		get {
			switch(self) {
				case .finalOperation: return [(date: Date?, value: Double)].self
				case .times: return [DateInterval].self
				case .startDates: return [Date].self
				case .endDates: return [Date].self
				case .attributes: return [String: String].self
			}
		}
	}
}
