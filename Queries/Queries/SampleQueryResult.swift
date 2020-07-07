//
//  Result.swift
//  Introspective
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Samples

public protocol QueryResult {
	var samples: [Sample] { get }
}

public class SampleQueryResult<SampleType: Sample>: NSObject, QueryResult {
	public final private(set) var typedSamples: [SampleType]

	public init(_ samples: [SampleType]) {
		typedSamples = samples
	}
}

public extension SampleQueryResult {
	var samples: [Sample] { typedSamples }
}
