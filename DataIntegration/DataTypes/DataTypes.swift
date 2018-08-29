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
	case mood
	case weight

	public static let allTypes: [DataTypes] = [heartRate, mood, weight]

	public static func attributesFor(_ type: DataTypes) -> [Attribute] {
		switch (type) {
			case .heartRate: return HeartRate.attributes
			case .mood: return MoodImpl.attributes
			case .weight: return Weight.attributes
		}
	}

	public var defaultDependentAttribute: Attribute {
		switch (self) {
			case .heartRate: return HeartRate.heartRate
			case .mood: return MoodImpl.rating
			case .weight: return Weight.weight
		}
	}

	public var defaultIndependentAttribute: Attribute {
		switch(self) {
			case .heartRate: return CommonSampleAttributes.timestamp
			case .mood: return CommonSampleAttributes.timestamp
			case .weight: return CommonSampleAttributes.timestamp
		}
	}

	public var description: String {
		switch (self) {
			case .heartRate: return "Heart Rate"
			case .mood: return "Mood"
			case .weight: return "Weight"
		}
	}
}
