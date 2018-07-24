//
//  Attributes.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum AttributeType {

	case quantity
	case string
	case date
}

public enum Attribute: CustomStringConvertible {

	case startDate
	case endDate
	case heartRate

	public static let heartRateAttributes: [Attribute] = [heartRate, startDate]

	public static func attributesFor(dataType: DataTypes) -> [Attribute] {
		switch (dataType) {
			case .heartRate: return heartRateAttributes
		}
	}

	public var type: AttributeType {
		switch (self) {
			case .startDate: return .date
			case .endDate: return .date
			case .heartRate: return .quantity
		}
	}

	public var classType: Any.Type {
		switch (self) {
			case .startDate: return Date.self
			case .endDate: return Date.self
			case .heartRate: return Double.self
		}
	}

	public var description: String {
		switch (self) {
			case .startDate: return "start date"
			case .endDate: return "end date"
			case .heartRate: return "heart rate"
		}
	}

	public var isDate: Bool {
		return type == .date
	}

	public var isQuantity: Bool {
		return type == .quantity
	}

	public var isString: Bool {
		return type == .string
	}
}
