//
//  BodyMassIndexSampleFetcher.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection
import Queries
import Samples

public final class BodyMassIndexSampleFetcher: SingleDateHealthKitSampleFetcher {
	public override var sampleTypePluralName: String { "Body Mass Indexes" }

	public init() {
		super.init(
			{ injected(QueryFactory.self).bmiQuery() },
			dateAttribute: CommonSampleAttributes.healthKitTimestamp
		)
	}
}
