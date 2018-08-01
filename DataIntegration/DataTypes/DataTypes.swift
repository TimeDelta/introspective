//
//  DataTypes.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum DataTypes: CustomStringConvertible {

	case heartRate

	public static let allTypes: [DataTypes] = [heartRate]

	public static func attributesFor(_ type: DataTypes) -> [Attribute] {
		switch (type) {
			case .heartRate: return HeartRate.attributes
		}
	}

	public var defaultDependentAttribute: Attribute {
		switch (self) {
			case .heartRate: return HeartRate.heartRate
		}
	}

	public var defaultIndependentAttribute: Attribute {
		return AnySample.startDate
	}

	public var description: String {
		switch (self) {
			case .heartRate: return "Heart Rate"
		}
	}
}
