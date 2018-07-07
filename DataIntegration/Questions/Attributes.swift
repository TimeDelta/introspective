//
//  Attributes.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum Attributes {

	public enum AttributeType {
		case string
		case quantity
	}

	case heartRate

	public static let heartRateAttributes: [Attributes] = [heartRate]

	public var type: AttributeType {
		switch (self) {
			case .heartRate: return .quantity
		}
	}
}
