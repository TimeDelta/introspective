//
//  DataTypes.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum DataTypes: CustomStringConvertible {

	case bmi
	case heartRate
	case leanBodyMass
	case mood
	case weight

	public static let allTypes: [DataTypes] = [bmi, heartRate, leanBodyMass, mood, weight]

	public static func attributesFor(_ type: DataTypes) -> [Attribute] {
		switch (type) {
			case .bmi: return BodyMassIndex.attributes
			case .heartRate: return HeartRate.attributes
			case .leanBodyMass: return LeanBodyMass.attributes
			case .mood: return MoodImpl.attributes
			case .weight: return Weight.attributes
		}
	}

	public var defaultDependentAttribute: Attribute {
		switch (self) {
			case .bmi: return BodyMassIndex.bmi
			case .heartRate: return HeartRate.heartRate
			case .leanBodyMass: return LeanBodyMass.leanBodyMass
			case .mood: return MoodImpl.rating
			case .weight: return Weight.weight
		}
	}

	public var defaultIndependentAttribute: Attribute {
		switch (self) {
			case .bmi: return BodyMassIndex.timestamp
			case .heartRate: return HeartRate.timestamp
			case .leanBodyMass: return LeanBodyMass.timestamp
			case .mood: return CommonSampleAttributes.timestamp
			case .weight: return Weight.timestamp
		}
	}

	public var description: String {
		switch (self) {
			case .bmi: return "Body Mass Index"
			case .heartRate: return "Heart Rate"
			case .leanBodyMass: return "Lean Body Mass"
			case .mood: return "Mood"
			case .weight: return "Weight"
		}
	}
}
