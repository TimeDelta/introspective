//
//  BloodPressureSampleFetcher.swift
//  Samples
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection
import Queries
import Samples

public final class BloodPressureSampleFetcher: SingleDateHealthKitSampleFetcher {
	public override var sampleTypePluralName: String { "Blood Pressures" }

	public init() {
		super.init(
			{ injected(QueryFactory.self).bloodPressureQuery() },
			dateAttribute: CommonSampleAttributes.healthKitTimestamp
		)
	}
}
