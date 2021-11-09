//
//  SleepSampleFetcher.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import AttributeRestrictions
import Attributes
import BooleanAlgebra
import DependencyInjection
import Queries
import Samples

public class SleepSampleFetcher: TwoDateHealthKitSampleFetcher {
	public override var sampleTypePluralName: String {
		"Sleep Data"
	}

	public init() {
		super.init { injected(QueryFactory.self).sleepQuery() }
	}
}
