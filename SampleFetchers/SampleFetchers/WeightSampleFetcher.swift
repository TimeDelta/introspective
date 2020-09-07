//
//  WeightSampleFetcher.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection
import Queries
import Samples

public final class WeightSampleFetcher: SingleDateHealthKitSampleFetcher {
	public override var sampleTypePluralName: String { "Weight Data" }

	public init() {
		super.init(
			{ injected(QueryFactory.self).weightQuery() },
			dateAttribute: CommonSampleAttributes.healthKitTimestamp
		)
	}
}
