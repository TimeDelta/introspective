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

	public var defaultAttribute: Attributes {
		switch (self) {
			case .heartRate: return .heartRate
		}
	}

	public var description: String {
		switch (self) {
			case .heartRate: return "Heart Rate"
		}
	}
}
