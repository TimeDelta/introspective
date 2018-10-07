//
//  GraphType.swift
//  Introspective
//
//  Created by Bryan Nova on 10/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import AAInfographics

public enum GraphType: CustomStringConvertible {
	case line
	case bar
	case scatter

	public static let allTypes: [GraphType] = [.line, .bar, .scatter]

	public var description: String {
		switch (self) {
			case .line: return "Line"
			case .bar: return "Bar"
			case .scatter: return "Scatter"
		}
	}

	public var aaChartType: AAChartType {
		switch (self) {
			case .line: return .Spline
			case .bar: return .Column
			case .scatter: return .Scatter
		}
	}
}
