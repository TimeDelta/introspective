//
//  SampleErrors.swift
//  Introspective
//
//  Created by Bryan Nova on 9/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common

public final class UnknownSampleTypeError: GenericError {

	public init(_ sampleType: Sample.Type) {
		super.init("Unknown sample type: \(sampleType.name)")
	}
}
