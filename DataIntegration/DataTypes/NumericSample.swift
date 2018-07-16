//
//  Averagable.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol NumericSample: Sample {

	var value: Double { get }
}

public class DoubleValueSample: AnySample, NumericSample {

	public var value: Double

	public init(_ value: Double) {
		self.value = value
		super.init()
	}

	public init(_ value: Double, _ dateType: DateType, _ date: Date) {
		self.value = value
		super.init(dateType, date)
	}

	public init(_ value: Double, _ dates: [DateType: Date]) {
		self.value = value
		super.init(dates)
	}
}
