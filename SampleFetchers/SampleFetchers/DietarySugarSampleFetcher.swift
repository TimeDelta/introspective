//
//  DietarySugarSampleFetcher.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 6/27/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection
import Queries
import Samples

public final class DietarySugarSampleFetcher: SingleDateHealthKitSampleFetcher {
	public override var sampleTypePluralName: String { "Dietary Sugars" }

	public init() {
		super.init(
			{ injected(QueryFactory.self).dietarySugarQuery() },
			dateAttribute: CommonSampleAttributes.healthKitTimestamp
		)
	}
}
