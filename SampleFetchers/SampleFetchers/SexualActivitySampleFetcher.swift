//
//  SexualActivitySampleFetcher.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection
import Queries
import Samples

public final class SexualActivitySampleFetcher: SingleDateHealthKitSampleFetcher {
	public override var sampleTypePluralName: String { "Sexual Activity Data" }

	public init() {
		super.init(
			{ injected(QueryFactory.self).sexualActivityQuery() },
			dateAttribute: CommonSampleAttributes.healthKitTimestamp
		)
	}
}
