//
//  Sample.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum DateType {
	case start
	case end
}

public protocol Sample {

	var dates: [DateType: Date] { get }
}

public class AnySample: Sample {

	public var dates: [DateType: Date]

	public init() {
		dates = [.start: Date()]
	}

	public init(_ dateType: DateType, _ date: Date) {
		dates = [DateType: Date]()
		dates[dateType] = date
	}

	public init(_ dates: [DateType: Date]) {
		self.dates = dates
	}
}
