//
//  ReturnType.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum ReturnType {

	/// returned value is a number based on an operation such as: average, count, max, min, sum
	case finalOperation
	/// 
	case times(aggregationUnit: Calendar.Component)
	case startDates
	case endDates

	public var type: Any.Type {
		get {
			switch(self) {
				case .finalOperation:
					return [Double].self
				case .times:
					return [DateInterval].self
				case .startDates:
					return [Date].self
				case .endDates:
					return [Date].self
			}
		}
	}
}
