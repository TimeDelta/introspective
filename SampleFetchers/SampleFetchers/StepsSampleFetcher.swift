//
//  StepsSampleFetcher.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 11/6/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection
import Queries
import Samples

public final class StepsSampleFetcher: TwoDateHealthKitSampleFetcher {
	public override var sampleTypePluralName: String {
		"Steps Data"
	}

	public init() {
		super.init { injected(QueryFactory.self).stepsQuery() }
	}
}
