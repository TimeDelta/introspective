//
//  Result.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol QueryResult {

	var samples: [Sample] { get }
}

public class SampleQueryResult<SampleType: Sample>: NSObject, QueryResult {

	public private(set) final var typedSamples: [SampleType]

	public init(_ samples: [SampleType]) {
		self.typedSamples = samples
	}
}

extension SampleQueryResult {

	public var samples: [Sample] { get { return typedSamples } }
}
