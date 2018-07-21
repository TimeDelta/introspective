//
//  Attributes.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum Attribute: CustomStringConvertible {

	case heartRate

	public static let heartRateAttributes: [Attribute] = [heartRate]

	public static func attributesFor(dataType: DataTypes) -> [Attribute] {
		switch (dataType) {
			case .heartRate: return heartRateAttributes
		}
	}

	public var type: Any.Type {
		switch (self) {
			case .heartRate: return Double.self
		}
	}

	public var description: String {
		switch (self) {
			case .heartRate: return "heart rate"
		}
	}

	public var isQuantity: Bool {
		switch (self) {
			case .heartRate: return true
		}
	}

	public var isString: Bool {
		return type == String.self
	}
}
